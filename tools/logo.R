library(hexSticker)
library(cowplot)

ggdraw() +
  draw_image(# https://www.flaticon.com/premium-icon/wings_4442490?related_id=4442490
    "man/figures/wings.png", scale = 3, y = .1) +
  draw_image(# https://www.flaticon.com/free-icon/elephant_1123692?term=elephant&related_id=1123692
    "man/figures/elephant.png",
    scale = 1.5,
    y = -.5) -> p
# for windows
sticker(
  p,
  s_x = 1,
  s_y = 0.75,
  package = "e/bird",
  p_size = 55,
  p_y = 1.4,
  p_x = 1,
  filename = "man/figures/logo.png",
  h_fill = "#cce8f4",
  p_color = "#160840",
  h_color = "#003458",
  url = "mrchypark.github.io/elbird",
  u_size = 9,
  u_color = "#003458",
  dpi = 500
)

# wing color : f2d961
