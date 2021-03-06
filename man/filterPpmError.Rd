% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checkEICFunctions.R
\name{filterPpmError}
\alias{filterPpmError}
\title{filterPpmError}
\usage{
filterPpmError(
  approvedPeaks,
  useGap,
  varExpThresh,
  returnPpmPlots,
  plotDir,
  observedPeak,
  filename
)
}
\arguments{
\item{approvedPeaks}{This is a data.frame with information on bins retained
after filtering with user input mz error threshold and continuity checks.}

\item{useGap}{Parameter carried into checkEICPeaks that tells Autotuner
whether to use the gap statustic to determine the proper number of clusters
to use during ppm parameter estimation.}

\item{varExpThresh}{Numeric value representing the variance explained
threshold to use if useGap is false.}

\item{returnPpmPlots}{Boolean value that tells R to return plots for
ppm distributions.}

\item{plotDir}{Path where to store plots.}

\item{observedPeak}{A list with names 'start' and 'end' containing
scalar values representing the calculated peak boundary points}

\item{filename}{A string containing the name of the current data file being
analyzed.}
}
\value{
This function returns a scalar value representing ppm error estimate.
}
\description{
This function computes an estimate for the ppm error threshold.
}
\details{
A distribution is created from the set of all ppm values identified.
The most dense peak of this distribution is assumed to represent the standard
ppm error of the data.
}
