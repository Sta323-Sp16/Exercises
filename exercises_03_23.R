library(profvis)
library(shiny)

### lm example

x = runif(1e5)
y = 1 + 3*x + rnorm(1e5, sd = 0.3)

system.time({l = lm(y~x)})

profvis({l = lm(y~x)})

system.time({l = lm.fit(x=cbind(1,x), y=y)$coefficients})


### Capture / Recapture

profvis({source("exercises_03_09/capture_abc.R")})

profvis({source("exercises_03_09/capture_abc_revise.R")})


### Capture / Recapture - Shiny

profvis({runApp(appDir = "exercises_03_09/")})


### Multicore

source("ex")
