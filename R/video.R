#' makeFrames
#'
#' @export

makeFrames <- function(path = NULL, fps = '1', outdir = 'frames/', range = NULL) {
    if (!dir.exists(outdir)) dir.create(outdir)
    opts <- glue::glue("-vf fps={fps}")
    if (!is.null(range)) {
        ss <- range[1]
        nb <- diff(range)
        opts <- 'n'
    }
    cmd <- glue::glue("ffmpeg -i {path} {opts} {outdir}/out%04d.jpg")
    system(cmd)
}

#' makeFastFrames
#'
#' @export

makeFastFrames <- function(path = NULL, outdir = 'frames-fast/', rate = 30, range = c("00:01:00", "00:01:03")) {
    if (!dir.exists(outdir)) dir.create(outdir)
    ss <- range[1]
    nsecs <- as.numeric(stringr::str_replace(range[2], '.*\\:', '')) - as.numeric(stringr::str_replace(range[1], '.*\\:', ''))
    nb <- nsecs * rate
    opts <- glue::glue("-ss {ss} -r {rate} -vframes {nb}")
    cmd <- glue::glue("ffmpeg -i {path} {opts} {outdir}/out%04d.jpg")
    system(cmd)
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

