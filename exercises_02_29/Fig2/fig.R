library(ggplot2)
library(gridExtra)

df = data.frame(x = rlnorm(1000))

pdf("fig.pdf",width = 14)
grid.arrange(
  ggplot(df, aes(x, main="Log Normal")) + stat_ecdf(geom = "step") + ggtitle("Standard Scale"),
  ggplot(df, aes(x, main="Log Normal")) + stat_ecdf(geom = "step") + scale_x_log10() + ggtitle("Log Scale"),
  ncol=2
)
dev.off()