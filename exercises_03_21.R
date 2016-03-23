library(parallel)
library(magrittr)

set.seed(3212016)
x = 1:120
y = sin(2*pi*x/120) + runif(length(x),-1,1)
d = data.frame(x=x,y=y)

l = loess(y ~ x, data=d)
pred_y = predict(l,data.frame(x=x))
pred_y_se = predict(l,data.frame(x=x),se=TRUE)$se.fit

#plot(x, y)
#lines(x, pred_y)
#lines(x, pred_y + 1.96 * pred_y_se, col='red')
#lines(x, pred_y - 1.96 * pred_y_se, col='red')


#Sys.setenv("OMP_NUM_THREADS"=1)

n_rep = 10000
system.time({
  res = sapply(1:n_rep, function(i)
  {
    resample = sample(1:length(x), length(x), replace=TRUE)
    bs = data.frame(
      x = x[resample],
      y = y[resample]
    )
    predict(loess(y ~ x, data=bs), data.frame(x=x))
  })
})


system.time({
  res = mclapply(1:n_rep, function(i)
  {
    resample = sample(1:length(x), length(x), replace=TRUE)
    bs = data.frame(
      x = x[resample],
      y = y[resample]
    )
    predict(loess(y ~ x, data=bs), data.frame(x=x))
  }, mc.cores = 4)
  res = do.call(cbind, res)
})

system.time({
  res = mclapply(1:4, function(i)
  {
    sapply(1:(n_rep/4), function(j)
    {
      resample = sample(1:length(x), length(x), replace=TRUE)
      bs = data.frame(
        x = x[resample],
        y = y[resample]
      )
      predict(loess(y ~ x, data=bs), data.frame(x=x))
    })
  }, mc.cores = 4)
  res = do.call(cbind, res)
})



# Calculate the 95% bootstrap prediction interval
bsi = apply(res,1,quantile,probs=c(0.025,0.975), na.rm=TRUE)

plot(x, y)
lines(x, pred_y, lwd=2)
lines(x, bsi[1,], col="blue")
lines(x, bsi[2,], col="blue")
lines(x, pred_y + 1.96 * pred_y_se, col='red')
lines(x, pred_y - 1.96 * pred_y_se, col='red')