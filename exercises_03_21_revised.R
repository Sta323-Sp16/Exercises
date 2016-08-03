library(parallel)
library(magrittr)

set.seed(3212016)
x = 1:120
y = sin(2*pi*x/120) + runif(length(x),-1,1)
d = data.frame(x=x,y=y)

l = loess(y ~ x, data=d)
pred_y = predict(l,data.frame(x=x))
pred_y_se = predict(l,data.frame(x=x),se=TRUE)$se.fit


n_rep = 1000

f1 = function()
{
  sapply(1:n_rep, function(i)
  {
    resample = sample(1:length(x), length(x), replace=TRUE)
    bs = data.frame(
      x = x[resample],
      y = y[resample]
    )
    l = loess(y ~ x, data=bs)
    predict(l, data.frame(x=x))
  })
}


f2 = function()
{
  res = mclapply(1:n_rep, function(i)
  {
    resample = sample(1:length(x), length(x), replace=TRUE)
    bs = data.frame(
      x = x[resample],
      y = y[resample]
    )
    predict(loess(y ~ x, data=bs), data.frame(x=x))
  }, mc.cores = 4)
  do.call(cbind, res)
}

f3 = function()
{
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
}


