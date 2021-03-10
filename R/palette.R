#' moviePalette
#'
#' @export

moviePalette <- function(cols, n = 10) {
    cols <- cols[!is.na(cols)] 
    mat <- sapply(cols, col2rgb) %>% t()
    clus <- kmeans(mat, round(1.5*n))
    cluster_cols <- sapply(1:round(1.5*n), function(K) {
        averageColors(cols[clus$cluster == K])
    })
    col_sats <- sapply(cluster_cols, getSaturation)
    res <- sample(cluster_cols[order(col_sats, decreasing = TRUE)[1:n]])
    return(res)
}