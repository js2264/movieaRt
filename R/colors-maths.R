#' sRGBtoLin
#'
#' @export

sRGBtoLin <- function(ch) {
    if ( ch <= 0.04045 ) {
        return(ch / 12.92)
    } 
    else {
        lin <- ( (ch + 0.055) / 1.055 )^2.4
        return(lin)
    }
}

#' YtoLstar
#'
#' @export

YtoLstar <- function(Y) {
    if ( Y <= 216/24389) {
        return( Y * (24389/27) )
    } 
    else {
        Lstar <- ( Y )^(1/3) * 116 - 16
        return(Lstar)
    }
}

#' getLuminance
#'
#' @export

getLuminance <- function(hex) {
    vR = col2rgb(hex)[1] / 255
    vG = col2rgb(hex)[2] / 255
    vB = col2rgb(hex)[3] / 255
    Y = (0.2126 * sRGBtoLin(vR) + 0.7152 * sRGBtoLin(vG) + 0.0722 * sRGBtoLin(vB))
    Lstar <- YtoLstar(Y)/100
    return(Lstar)
}

#' getSaturation
#'
#' @export

getSaturation <- function(hex) {
    Lstar <- getLuminance(hex)
    if ( Lstar == 1 ) {
        return( 0 )
    } 
    else if ( Lstar == 0 ) {
        return( 1 )
    } 
    else {
        maxc <- max(col2rgb(hex))/255
        minc <- min(col2rgb(hex))/255
        div <- -1 * (abs(2*Lstar - 1) - 1)
        S <- (maxc - minc) / ( div )
        return(S)
    }
}

#' adjustLuminance
#'
#' @export

adjustLuminance <- function(hex, threshold_min, threshold_max) {
    Lstar <- getLuminance(hex)
    if (Lstar < threshold_min | Lstar > threshold_max) {
        diff <- threshold_max - ((threshold_max - threshold_min) / 2) - Lstar
        return(colorspace::lighten(hex, diff))
    } 
    else {
        return(hex)
    }
}

#' colorDistances
#'
#' @export

colorDistances <- function(cols) {
    mat <- lapply(1:length(cols), function(i) {
        lapply(1:length(cols), function(j) {
            rgb_col1 <- col2rgb(cols[i])
            rgb_col2 <- col2rgb(cols[j])
            d <- sqrt(
                (rgb_col2[1] - rgb_col1[1])^2 + 
                (rgb_col2[2] - rgb_col1[2])^2 + 
                (rgb_col2[3] - rgb_col1[3])^2 
            )
        }) %>% unlist()
    }) %>% do.call(rbind, .)
    colnames(mat) <- cols
    rownames(mat) <- cols
    if (length(cols) == 1) mat <- mat[1,2]
    return(mat)
}

#' averageColors 
#'
#' @export

averageColors <- function(cols) {
    cols <- cols[!is.na(cols)]
    cols <- rgb(matrix(
        rowMeans(col2rgb(cols)), nrow = 1
    ), maxColorValue = 255)
    return(cols)
}
