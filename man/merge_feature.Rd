% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/merge_feature.R
\name{merge_feature}
\alias{merge_feature}
\alias{summary.merge_feature}
\title{Merge SNP lod peaks with SNP feature information}
\usage{
merge_feature(top_snps_tbl, snpinfo, out_lmm_snps, drop = 1.5, dropchar = 0,
  gene_exon = get_gene_exon_snp(top_snps_tbl))

\method{summary}{merge_feature}(object, sum_type = c("SNP type", "pattern"),
  ...)
}
\arguments{
\item{top_snps_tbl}{tbl from \code{\link{get_top_snps_tbl}} or \code{\link[qtl2]{top_snps}}}

\item{snpinfo}{SNP information table}

\item{out_lmm_snps}{tbl from \code{\link[qtl2]{scan1}} on SNPs}

\item{drop}{include LOD scores within \code{drop} of max for each phenotype}

\item{dropchar}{number of characters to drop on phenames}

\item{gene_exon}{tbl from \code{\link{get_gene_exon_snp}}}

\item{object}{of class \code{merge_feature}}

\item{sum_type}{one of \code{c("SNP type","pattern")}}

\item{...}{other arguments not used}
}
\value{
tbl with added information on genes and exons

table summary
}
\description{
Merge all SNPs in small region with LOD peaks across multiple phenotype.

Summary of merge_feature object
}
\examples{
\dontrun{merge_feature(...)}

}
\author{
Brian S Yandell, \email{brian.yandell@wisc.edu}

Brian S Yandell, \email{brian.yandell@wisc.edu}
}
\keyword{hplot}
\keyword{utilities}
