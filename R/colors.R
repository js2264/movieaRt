#' rgb2hex
#'
#' @export

rgb2hex <- function(cols) {
    rgb(cols[[1]], cols[[2]], cols[[3]], maxColorValue = 1)
}

#' adjustColors
#'
#' @export

filterColors <- function(list_colors, threshold_sat = 0.2, threshold_lum = 0.05, min = 0.5, max = 0.7) {
    cols <- sapply(seq_along(list_colors), function(K) {
        cols <- list_colors[[K]]
        cols <- cols[!is.na(cols)]
        cols <- cols[cols != '#000000']
        cols <- cols[sapply(cols, getSaturation) >= threshold_sat]
        cols <- cols[sapply(cols, getLuminance) >= threshold_lum]
        if (length(cols) == 0) {
            return(NA)
        }
        else {
            if (length(cols) > 1) cols <- reduceColors(cols)
            if (length(cols) > 1) cols <- cols[1]
            return(cols)
        }
    })
    cols <- cols[!is.na(cols)]
    return(cols)
}

#' reduceColors
#'
#' @export

reduceColors <- function(cols) {
    mat <- colorDistances(cols)
    db <- dbscan::dbscan(mat, eps = 100, minPts = 1)
    nclus <- length(unique(db$cluster))
    cols <- sapply(1:nclus, function(clus) sample(cols[db$cluster == clus], 1))
    return(cols)
}

#' smoothColors
#'
#' @export

smoothColors <- function(list_colors, bin = 20) {
    cols <- zoo::rollapply(list_colors, width = bin, by = 1, averageColors)
    return(cols)
}

#' orderColors
#'
#' @export

orderColors <- function(cols, by) {
    cols <- sapply(cols, col2rgb) %>% 
        rgb2hsv() %>% 
        t() %>% 
        as.data.frame() %>%
        rownames_to_column() %>%
        arrange(h, s) %>%
        pull(rowname)
    return(cols)
}