#' colorStack
#'
#' @export

colorStack <- function(main_colors, orientation = 'landscape') {
    `%>%` <- magrittr::`%>%`
    cols <- main_colors[!is.na(main_colors)]
    if (orientation == 'landscape') {
        p <- data.frame(x = 1:length(cols), y = 1, col = factor(cols, levels = unique(cols))) %>% 
            ggplot(aes(x = x, y = y, fill = col)) + 
            geom_tile() + 
            scale_fill_manual(values = cols) + 
            theme_void() + 
            coord_fixed(ratio = 400) +
            theme(legend.position = 'none')
    }
    else {
        p <- data.frame(x = 1, y = rev(1:length(cols)), col = factor(cols, levels = unique(cols))) %>% 
            ggplot(aes(x = x, y = y, fill = col)) + 
            geom_tile() + 
            scale_fill_manual(values = cols) + 
            theme_void() + 
            coord_fixed(ratio = 1/400) +
            theme(legend.position = 'none')
    }
    return(p)
}

#' checkPalette
#'
#' @export

checkPalette <- function(cols, unique = FALSE) {
    `%>%` <- magrittr::`%>%`
    if (unique) {
        cols <- cols[!is.na(cols)]
        cols <- unique(cols)
        p <- data.frame(x = 1, y = 1, z = 1:length(cols), col = factor(cols, levels = cols)) %>% 
            ggplot(aes(x = x, y = y, fill = col)) + 
            geom_tile() + 
            facet_wrap(~col) + 
            theme_void() + 
            coord_fixed() + 
            theme(legend.position = 'none') +
            theme(panel.spacing = unit(0.005, "lines")) + 
            scale_fill_manual(values = cols)
        return(p)
    } 
    else { 
        cols <- cols[!is.na(cols)]
        p <- data.frame(x = 1, y = 1, z = 1:length(cols), col = factor(cols, levels = unique(cols))) %>% 
            ggplot(aes(x = x, y = y, fill = col)) + 
            geom_tile() + 
            facet_wrap(~z) + 
            theme_void() + 
            coord_fixed() + 
            theme(legend.position = 'none') +
            theme(panel.spacing = unit(0.005, "lines")) + 
            scale_fill_manual(values = cols)
        return(p)
    }
}

