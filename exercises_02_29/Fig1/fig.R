r = rlnorm(1000)

h = hist(r, plot=FALSE, breaks=c(seq(0,max(r)+1, .1)))

pdf("fig.pdf", width=7)
plot(h$counts, log="xy", pch=20, col="blue",
     main="Log-normal distribution",
     xlab="Value", ylab="Frequency")
dev.off()