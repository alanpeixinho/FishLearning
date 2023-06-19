library(datasets)
library(ggplot2)
library(xkcd)
library(reshape2)
library(extrafont)

font_import()

head(iris)

raw <- melt(iris, id='Species')

head(raw)

StatNormalDensity <- ggproto(
  "StatNormalDensity", Stat,
  required_aes = "x",
  default_aes = aes(y = stat(y)), 
  compute_group = function(data, scales, xlim = NULL, n = 101) {
    mean_value <- mean(data$x)
    sd_value <- sd(data$x)
    fun <- function(x) dnorm(x, mean = mean_value, sd = sd_value)
    StatFunction$compute_group(data, scales, fun = fun, xlim = xlim, n = n)
  }
)

xrange <- range(raw$value)
yrange <- c(0,4)

plot <- ggplot(aes(x=value, colour=variable), data=raw) +
  geom_histogram(aes(y=..density..), alpha=0, binwidth=0.25) +
  geom_line(stat = StatNormalDensity, size = 1, alpha=0.5) +
  facet_grid(Species~.)


svg('hue.svg')

print(plot + theme_xkcd())

