timeToLabels <- function(nsec) {
    secs <- 0:nsec
    sec_labels <- sapply(secs, function(s) ifelse(s %% 600 == 0, as.character(s/60), ""))
    sec_ticks <- which(sec_labels != "")
    sec_labels[length(sec_labels) + 1] <- round(nsec/60)
    sec_ticks[length(sec_ticks) + 1] <- nsec
    sec_labels <- paste0(sec_labels[sec_labels != ""], "'")
    res <- list(
        'label' = sec_labels, 
        'tick' = sec_ticks/60
    )
    return(res)
}