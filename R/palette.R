#' moviePalette
#'
#' @export

moviePalette <- function(cols, n = 10) {
    cols <- cols[!is.na(cols)] 
    mat <- sapply(cols, col2rgb) %>% t()
    clus <- kmeans(mat, round(1.5*n))
    # dist <- farver::compare_colour(mat, from_space = 'rgb', method = 'cie2000')
    # clus <- kmeans(dist, round(1.5*n))
    cluster_cols <- sapply(1:round(1.5*n), function(K) {
        averageColors(cols[clus$cluster == K])
    })
    col_sats <- sapply(cluster_cols, getSaturation)
    res <- sample(cluster_cols[order(col_sats, decreasing = TRUE)[1:n]])
    return(res)
}

#' framePalette
#'
#' @export

framePalette <- function(path, time = NULL, outdir = 'frame/', ncols = 10) {
    ext <- tools::file_ext(path)
    if (file.exists(path) & tolower(ext) %in% c('jpg', 'jpeg', 'png')) {
        cols <- getPaletteFromImg(path, ncols = NULL)
    }
    else {
        if (!dir.exists(outdir)) dir.create(outdir)
        system(glue::glue("ffmpeg -i {path} -ss {time} -vframes 1 -qscale:v 1 -qmin 1 {outdir}/frame.jpg"))
        cols <- getPaletteFromImg(glue::glue("{outdir}/frame.jpg"), ncols = NULL)
    }
    cols <- cols[cols != '#000000']
    cols <- moviePalette(cols, n = ncols)
    cols <- orderColors(cols)
    return(cols)
}

