#' makeFrames
#'
#' @export

makeFrames <- function(path = NULL, fps = '1', outdir = 'frames/') {
    if (!dir.exists(outdir)) dir.create(outdir)
    system(glue::glue("ffmpeg -i {path} -vf fps={fps} {outdir}/out%04d.jpg"))
}

#' getColorList
#'
#' @export

getColorList <- function(dir = 'frames/', cores = 3) {
    # Get predominant color for every frame
    frames <- list.files(dir, pattern = 'out.*jpg', full.names = TRUE)
    cols <- parallel::mclapply(
        mc.cores = cores, 
        1:length(frames), 
        function(K)
        {
            if (K %% 10 == 0) message(K, '...')
            frame <- frames[K]
            getPaletteFromImg(frame, ncols = 30)
        }
    )
}

