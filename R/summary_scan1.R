
#' Summary of scan1 object
#'
#' @param object object from \code{\link[qtl2]{scan1}}
#'
#' @param map A list of vectors of marker positions, as produced by
#' \code{\link[qtl2]{insert_pseudomarkers}}.
#'
#' @param snpinfo Data frame with SNP information with the following
#'     columns (the last three are generally derived from with
#'     \code{\link[qtl2]{index_snps}}):
#' \itemize{
#' \item \code{chr} - Character string or factor with chromosome
#' \item \code{pos} - Position (in same units as in the \code{"map"}
#'     attribute in \code{genoprobs}.
#' \item \code{sdp} - Strain distribution pattern: an integer, between
#'     1 and \eqn{2^n - 2} where \eqn{n} is the number of strains, whose
#'     binary encoding indicates the founder genotypes
#' \item \code{snp} - Character string with SNP identifier (if
#'     missing, the rownames are used).
#' \item \code{index} - Indices that indicate equivalent
#'     groups of SNPs.
#' \item \code{intervals} - Indexes that indicate which marker
#'     intervals the SNPs reside.
#' \item \code{on_map} - Indicate whether SNP coincides with a marker
#'     in the \code{genoprobs}
#' }
#'
#' @param lodcolumn one or more lod columns
#' @param chr one or more chromosome IDs
#' @param sum_type type of summary
#' @param drop LOD drop from maximum
#' @param show_all_snps show all SNPs if \code{TRUE}
#' @param ... other arguments not used
#'
#' @return tbl summary
#'
#' @author Brian S Yandell, \email{brian.yandell@@wisc.edu}
#' @keywords utilities
#'
#' @examples
#' # load qtl2 package for data and genoprob calculation
#' library(qtl2)
#' 
#' # read data
#' iron <- read_cross2(system.file("extdata", "iron.zip", package="qtl2"))
#' # insert pseudomarkers into map
#' map <- insert_pseudomarkers(iron$gmap, step=1)
#' 
#' # calculate genotype probabilities
#' probs <- calc_genoprob(iron, map, error_prob=0.002)
#' 
#' # grab phenotypes and covariates; ensure that covariates have names attribute
#' pheno <- iron$pheno
#' covar <- match(iron$covar$sex, c("f", "m")) # make numeric
#' names(covar) <- rownames(iron$covar)
#' Xcovar <- get_x_covar(iron)
#' 
#' # perform genome scan
#' out <- scan1(probs, pheno, addcovar=covar, Xcovar=Xcovar)
#' 
#' # summary
#' summary(out, map)
#'
#' @export
#' @importFrom dplyr arrange desc group_by mutate select summarize tbl_df ungroup
#' @importFrom tidyr gather
#'
summary_scan1 <- function(object, map, snpinfo=NULL,
                          lodcolumn=seq_len(ncol(object)),
                          chr = names(map),
                          sum_type = c("common","best"), drop=1.5,
                          show_all_snps = TRUE,
                          ...) {
  if(is.null(snpinfo)) {
    if(!is.null(chr))
      map <- map[chr]
    
    # scan1 LOD summary
    thechr <- factor(qtl2:::map2chr(map), names(map))
    thepos <- qtl2:::map2pos(map)
    lod <- unclass(object)
    sign <- (lod >= 0) * 2 - 1
    coln <- colnames(lod)
    mnames <- rownames(lod)
    if (is.character(lodcolumn)) {
      tmp <- match(lodcolumn, coln)
      if (any(is.na(tmp))) 
        stop("column \"", paste(lodcolumn, collapse = ","), "\" not found")
      lodcolumn <- tmp
    }
    if (any(lodcolumn < 1) || any(lodcolumn > ncol(lod))) 
      stop("column [", paste(lodcolumn, collapse = ","), "] out of range (should be in 1, ..., ", 
           ncol(lod), ")")
    
    lod <- lod[, lodcolumn, drop = FALSE]
    sign <- sign[, lodcolumn, drop = FALSE]
    if (!is.null(chr)) {
      keep <- (thechr %in% chr)
      thechr <- thechr[keep]
      thepos <- thepos[keep]
      mnames <- mnames[keep]
      lod <- lod[keep,, drop = FALSE] * sign[keep,, drop = FALSE]
    }
    lod <- data.frame(chr = thechr, 
                      pos = thepos, 
                      mnames = mnames,
                      lod,
                      check.names = FALSE)
    dplyr::arrange(
      dplyr::ungroup(
        dplyr::summarize(
          dplyr::group_by(
            tidyr::gather(lod, pheno, lod, -chr, -pos, -mnames),
            pheno, chr),
          marker = mnames[which.max(lod)],
          pos = pos[which.max(lod)],
          lod = max(lod))),
      chr)
  } else {
    # snpinfo summary
    ## top_snps() Adapted to multiple phenotypes.
    object <- top_snps_all(object, snpinfo, drop, show_all_snps)

    if(!nrow(object))
      return(NULL)

    haplos <- snpinfo_to_haplos(snpinfo)
    sum_type <- match.arg(sum_type)
    switch(sum_type,
           best = { ## Top SNPs across all phenotypes.
             if(!nrow(object))
               return(NULL)
             dplyr::arrange(
               dplyr::mutate(object,
                             pattern = sdp_to_pattern(sdp, haplos)),
               dplyr::desc(lod))},
           common = { ## Find most common patterns by pheno.
             dplyr::arrange(
               dplyr::mutate(
                 dplyr::ungroup(
                   dplyr::summarize(
                     dplyr::group_by(object,pheno,sdp),
                     count=n(),
                    pct=round(100 * n() / nrow(object), 2),
                    min_lod=min(lod),
                    max_lod=max(lod),
                    max_snp=snp_id[which.max(lod)],
                    max_pos=pos[which.max(lod)])),
                 pattern = sdp_to_pattern(sdp, haplos)),
               dplyr::desc(max_lod))
           })
  }
}

#' @method summary scan1
#' @rdname summary_scan1
#' @export
#' @export summary.scan1
#'
summary.scan1 <- function(object, ...) {
  summary_scan1(object, ...)
}
