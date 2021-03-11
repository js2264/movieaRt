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

## Processing the colors and plotting a color story

```r
data(colors) # this set of colors was extracted from The Grand Budapest Hotel, directed by Wes Anderson.
main_colors <- filterColors(colors)
average_colors <- smoothColors(main_colors)
movieStack(average_colors)
```

![](man/figures/TGBH.png)

Timeline can be added using the `nsec` argument: 

```r
movieStack(average_colors, nsec = length(colors))
```

Timepoints can be added using the `tp` argument: 

```r
tp <- list(
    '24' = 'Funerals', 
    '36' = 'Part III: Criminal Internment Camp', 
    '77' = 'Snow pursuit'
)
movieStack(average_colors, nsec = length(colors), tp = tp)
```

![](man/figures/TGBH_with-timepoints.png)

## Tidy workflow

```r
makeFrames("path/to/video.mp4")
p <- getColorList() %>% 
    filterColors() %>% 
    smoothColors() %>% 
    movieStack()
```

## Movie palette

```r
data(colors)
palette <- colors %>%
    purrr::flatten() %>% 
    unlist() %>% 
    unique() %>% 
    moviePalette()
checkPalette(palette, unique = TRUE)
```

![](man/figures/TGBH_palette.png)

## Frame palette

```r
makeFastFrames("path/to/movie.mp4", range = c("00:12:29.660", "00:12:31.000"))
colors <- framePalette("path/to/movie.mp4", time = '00:12:29.660')
checkPalette(colors, unique = TRUE)
```

Or directly from a pre-existing image: 

```r
colors <- framePalette("path/to/frame.jpg", ncols = 20)
checkPalette(colors, unique = TRUE)
```

![](man/figures/LaLaLand-frame.png)
![](man/figures/LaLaLand-frame_palette.png)

## Acknowledgments

https://twitter.com/CINEMAPALETTES inspired me to implement the movie color palette.  
https://thecolorsofmotion.com/ inspired me the movie color stacks. 
