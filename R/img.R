#' readImg
#'
#' @export

readImg <- function(img) {
    isLink <- strsplit(img, '/')[[1]][1] %in% c('https:', 'http:')
    ext <- tools::file_ext(img)
    if (isLink) {
        msg_note(glue::glue("Fetching img from {img}"))
        z <- glue::glue(tempfile(), '.{ext}')
        download.file(img, z)
        img <- z
    }
    if (ext == 'png') {
        img <- png::readPNG(img)
    }
    else if (ext == 'jpeg' | ext == 'jpg') {
        img <- jpeg::readJPEG(img)
    } 
    else {
        stop(msg_warning("Please provide a png or jpeg image"))
    }
    return(img)
}

#' getPaletteFromImg
#'
#' @export

getPaletteFromImg <- function(img, ncols = 5) {
    `%>%` <- magrittr::`%>%`
    img <- readImg(img)
    cols <- lapply(1:dim(img)[1], function(i) {
        lapply(1:dim(img)[2], function(j) {rgb2hex(img[i, j, ])}) %>% unlist()
    }) %>% 
        do.call(c, .) %>% 
        table() %>% 
        sort(decreasing = TRUE) %>% 
        head(30) %>% 
        names()
    # print(checkPalette(cols))
    return(cols[1:ncols])
}

