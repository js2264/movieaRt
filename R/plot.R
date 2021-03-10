#' colorStack
#'
#' @export

colorStack <- function(
    cols, 
    orientation = 'landscape', 
    ratio = 10,
    nsec = NULL, 
    tp = NULL
) {
    `%>%` <- magrittr::`%>%`
    # ----- Prepare data
    cols <- cols[!is.na(cols)]
    df <- data.frame(
        x = scales::rescale(1:length(cols), c(0, ifelse(!is.null(nsec), nsec, length(cols))))/60,
        y = 1, 
        col = factor(cols, levels = unique(cols))
    )
    if (orientation != 'landscape') {
        df <- data.frame(
            x = df$y, 
            y = rev(df$x), 
            col = df$col
        )
        ratio = 1/ratio
    }
    # ----- Get color stack
    p <-ggplot(df, aes(x = x, y = y, fill = col)) + 
        geom_tile() + 
        scale_fill_manual(values = cols) + 
        theme(
            panel.background = element_blank(),
            panel.grid = element_blank(),
            axis.line = element_blank(),
            axis.title.y = element_blank(), 
            axis.text.y = element_blank(), 
            axis.ticks.y = element_blank(), 
            legend.position = 'none'
        ) + 
        labs(x = "") +
        coord_fixed(ratio = ratio, clip = 'off')
    # ----- Add timeline
    if (!is.null(nsec)) {
        br <- timeToLabels(nsec)$tick
        lab <- timeToLabels(nsec)$label
        p <-p + 
            scale_x_continuous(
                name = "", 
                breaks = round(br), 
                labels = lab
            )
    }
    else {
        p <-p + 
        theme(
            axis.title.x = element_blank(), 
            axis.text.x = element_blank(), 
            axis.ticks.x = element_blank()
        ) 
    }
    # ----- Add timepoints
    if (!is.null(tp)) {
        df_tp <- data.frame(
            x = as.numeric(names(tp)), 
            y = 1.8,
            label = unlist(tp)
        )
        p <-p +
            geom_vline(xintercept = df_tp$x, col = 'red', size = 1) + 
            geom_point(data = df_tp, mapping = aes(x = x, y = y), col = 'red', size = 2, inherit.aes = FALSE) + 
            annotate(
                geom = 'text',
                x = df_tp$x,
                y = df_tp$y,
                label = paste0('   ', df_tp$label), 
                col = 'red', 
                size = 2, 
                hjust = 0
            )
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

