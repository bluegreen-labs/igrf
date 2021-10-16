library(hexSticker)
library(tidyverse)
library(metR)

df <- igrf::igrf_grid(
  year = 2000,
  altitude = 2,
  resolution = 1
)

b <- data.frame(b = seq(-90,90,5))
b %>%
  mutate(
    c = ifelse(b<0,"red","blue"),
    c = ifelse(b == 0, "green", c)
  )

p <- ggplot(df) +
  geom_contour2(
    aes(
      lon,
      lat,
      z = D
    ),
    color = "grey",
    breaks = b$b
  ) +
  theme_void() +
  theme_transparent()

print(p)

sticker(p,
        package="igrf",
        p_size=20,
        p_color = "black",
        h_color = "black",
        h_fill = "white",
        filename="logo.png",
        s_width = 3,
        s_height = 3
        )
