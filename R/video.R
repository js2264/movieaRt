#' makeFrames
#'
#' @export

makeFrames <- function(path = NULL, fps = '1/60', outdir = 'frames/') {
    system(glue::glue("ffmpeg -i {path} -vf fps={fps} {outdir}/out%04d.jpg"))
}

#' getColorList
#'
#' @export

getColorList <- function(dir = 'frames/') {
    # Get predominant color for every frame
    frames <- list.files(dir, pattern = 'out.*jpg', full.names = TRUE)
    cols <- parallel::mclapply(
        mc.cores = 5, 
        1:length(frames), 
        function(K)
        {
            if (K %% 10 == 0) message(K, '...')
            frame <- frames[K]
            getPaletteFromImg(frame, ncols = 30)
        }
    )
}

