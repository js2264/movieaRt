# movieaRt

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![pkgdown](https://github.com/js2264/movieaRt/workflows/pkgdown/badge.svg)](https://github.com/js2264/movieaRt/actions)
<!-- badges: end -->

## Getting main colors per frame

```r
video <- "path/to/video.mp4"
makeFrames(video, outdir = 'frames/')
list_colors <- getColorList(dir = 'frames/')
```

## Processing the colors and plotting them

```r
data(colors) # this set of colors was extracted from The Grand Budapest Hotel, directed by Wes Anderson.
main_colors <- filterColors(colors)
average_colors <- smoothColors(main_colors)
colorStack(average_colors)
```

![](man/figures/TGBH.png)

## Tidy workflow

```r
makeFrames("path/to/video.mp4")
p <- getColorList() %>% 
    filterColors() %>% 
    smoothColors() %>% 
    colorStack()
```
