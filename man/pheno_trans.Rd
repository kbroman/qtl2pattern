% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pheno_trans.R
\name{pheno_trans}
\alias{pheno_trans}
\title{Get phenotypes}
\usage{
pheno_trans(phe, phename, transform = NULL, offset = 0, winsor = 0.02)
}
\arguments{
\item{phe}{phenotypes in data frame}

\item{phename}{vector of phenotype names (subset of \code{colnames(phe)})}

\item{transform}{vector of function names (\code{NULL} for no transformations)}

\item{offset}{vector of offsets}

\item{winsor}{vector of winsorize values}
}
\value{
data frame of phenotypes
}
\description{
Get phenotypes using data frame of phenopypes filtered by \code{analyses_tbl}
}
\examples{
\dontrun{get_pheno(phe, analyses_tbl)}

}
\author{
Brian S Yandell, \email{brian.yandell@wisc.edu}
}
\keyword{utilities}
