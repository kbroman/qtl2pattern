% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_snpprobs.R
\name{get_snpprobs}
\alias{get_snpprobs}
\title{Get SNP genotype probabilities in window around peak}
\usage{
get_snpprobs(chr_id = NULL, peak_Mbp = NULL, window_Mbp = NULL, phename,
  probs_obj, probs_map, snpinfo = query_variants(chr_id, peak_Mbp -
  window_Mbp, peak_Mbp + window_Mbp))
}
\arguments{
\item{chr_id}{chromosome identifier}

\item{peak_Mbp}{position in Mbp of peak}

\item{window_Mbp}{half-width of \code{window} around \code{peak_Mbp}}

\item{phename}{names of phenotypes}

\item{probs_obj}{object of class \code{\link[qtl2]{calc_genoprob}} for \code{chr_id}}

\item{probs_map}{map of markers/pseudomarkers in \code{probs_obj}}

\item{snpinfo}{SNP information table from user supplied \code{query_variants}; see \code{\link[qtl2]{create_variant_query_func}}}
}
\value{
list with \code{snpprobs} and \code{snpinfo}
}
\description{
Get SNP information from SQLite database within \code{window_Mbp} of \code{peak_Mbp} on \code{chri_id}
}
\examples{
\dontrun{get_snpprobs(chr_id, peak_Mbp, window_Mbp, scan_obj, probs_obj, datapath)}

}
\author{
Brian S Yandell, \email{brian.yandell@wisc.edu}
}
\keyword{utilities}
