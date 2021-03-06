#' @title returnParams
#'
#' @description This function is designed to return a list of data.frames
#' containing parameter estimates obtained from the EIC and TIC parameter
#' estimation.
#'
#' @param eicParamEsts The objection containing all parameter estimates
#' obtained from running Autotuner's EICparam function.
#' @param Autotuner An Autotuner object used to return the TIC estimated
#' parameters
#'
#' @return A list of data.frames with parameter estimates.
#'
#' @examples
#' Autotuner <- readRDS(system.file("extdata/Autotuner.rds",
#' package="Autotuner"))
#'
#' eicParamEsts <- readRDS(system.file("extdata/eicParamsEsts.rds",
#' package="Autotuner"))
#' outParams <- returnParams(eicParamEsts = eicParamEsts, Autotuner = Autotuner)
#'
#' @export
returnParams <- function(eicParamEsts, Autotuner) {

    params <- TIC_params(getAutoPeak_table(Autotuner),
                         getAutoPeak_difference(Autotuner))
    params <- data.frame(descriptions = names(params),
                         estimates = unlist(params))

    colNameCheck <- all(c("ppm", "peakCount",
                          "noiseThreshold", "prefilterI",
                          "prefilterScan",
                          "TenPercentQuanSN","maxPw", "minPw") %in%
                            colnames(eicParamEsts))

    assertthat::assert_that(colNameCheck,
                            msg = paste("Error in EICparams: some of the",
                                        "column names from the output are",
                                        "missing. Cannot complete parameter",
                                        "estimation."))

    ppmEst <- weighted.mean(eicParamEsts$ppm, eicParamEsts$peakCount)
    noiseEst <- min(eicParamEsts$noiseThreshold, na.rm = TRUE)
    prefilterIEst <- min(eicParamEsts$prefilterI, na.rm = TRUE)
    prefilterScanEst <- min(eicParamEsts$prefilterScan, na.rm = TRUE)
    snEst <- min(eicParamEsts$TenPercentQuanSN, na.rm = TRUE)

    maxPw <- split(eicParamEsts$maxPw, eicParamEsts$sampleID)
    maxPw <- vapply(X = maxPw, FUN = max, FUN.VALUE = numeric(1))
    maxPw <- mean(maxPw)

    minPw <- min(eicParamEsts$minPw)

    estimates <- c(ppm = ppmEst,
                   noise = noiseEst,
                   preIntensity = prefilterIEst,
                   preScan = prefilterScanEst,
                   snThresh = snEst,
                   "Max Peakwidth" = maxPw,
                   "Min Peakwidth" = minPw)

    rm(ppmEst,noiseEst,prefilterIEst,prefilterScanEst,snEst,maxPw,minPw)

    ppmSd <- sd(eicParamEsts$ppm)
    noiseSd <- sd(eicParamEsts$noiseThreshold)
    prefilSd <- sd(eicParamEsts$prefilterI, na.rm = TRUE)
    prefilScanSd <- sd(eicParamEsts$prefilterScan, na.rm = TRUE)
    snEstSd <- sd(eicParamEsts$TenPercentQuanSN, na.rm = TRUE)
    maxPwDist <- abs(diff(sort(eicParamEsts$maxPw, decreasing = TRUE))[1])
    minPwDist <- abs(diff(sort(eicParamEsts$minPw, decreasing = TRUE))[2])

    variability <- c(ppmSd, noiseSd, prefilSd, prefilScanSd, snEstSd,
                     maxPwDist,
                     minPwDist)
    rm(ppmSd, noiseSd, prefilSd, prefilScanSd, snEstSd, maxPwDist, minPwDist)
    description <- c("Standard Deviation of all PPM Estimates",
                     "Standard Deviation of all noise Estimates",
                     'Standard Deviation of all prefileter Intensity Estimates',
                     "Standard Deviation of all scan coung Estimates",
                     "Standard Deviation of all s/n threshold Estimates",
                     "Distance between two highest estimated peak widths",
                     "Distance between two lowest estimated peak widths")


    aggregatedEstimates <- data.frame(Parameters = names(estimates),
                                      estimates = signif(estimates,
                                                         digits = 4),
                                      'Variability Measure' =
                                          signif(variability, digits = 4),
                                      "Measure" = description)

    output <- list(eicParams = aggregatedEstimates, ticParams = params)

    return(output)

}
