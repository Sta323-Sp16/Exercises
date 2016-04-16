## Merge Data

library(dplyr)
library(readr)

load('/data/Sta323/nyc_parking/pluto_data.Rdata')
nyc = read_csv("/data/Sta323/nyc_parking/NYParkingViolations.csv")

names(nyc) = make.names(names(nyc))

nyc_addr = nyc %>%
  select(Issuer.Precinct,House.Number,Street.Name) %>%
  transmute(precinct = Issuer.Precinct, 
            address = paste(House.Number, Street.Name) %>% tolower()) %>%
  filter(precinct >= 1, precinct <= 34)

pluto = pluto_data %>%
  rename(x=longitude, y=latitude)

precincts = inner_join(nyc_addr, pluto)

## Visualizing Precincts

good_precincts = c(1,5,6,7,9,10,13,14,17,18,19,20,22,
                   23,24,25,26,28,30,32,33,34)

d = precincts %>% filter(precinct %in% good_precincts)
table(d$precinct)

set.seed(123)
precinct_colors = rep(NA,34)
colors = scales::hue_pal(h = c(0, 360) + 15, c = 100, l = 65, h.start = 0, direction = 1)(22)
colors = sample(colors,length(colors))

precinct_colors[good_precincts] = colors

plot(d$x, d$y, pch=16, cex=0.5, col=precinct_colors[d$precinct])
legend("topleft",legend=as.character(good_precincts), pch=16, col=colors, 
       ncol = 5, cex=1, x.intersp=0.33, y.intersp=0.33)


## Manhattan Bounday

library(rgdal)
library(raster)

bb = readOGR("/data/Sta323/nyc_parking/nybb/","nybb")
manh = bb[bb$BoroName == "Manhattan",]

r = raster()
extent(r) = bbox(manh)
dim(r) = c(1000,200)

r = rasterize(manh, r)


pred_cells = which(r[] != 0)
pred_locs = xyFromCell(r,pred_cells) %>% as.data.frame()



## Modeling - Logistic Regression

pdata = data.frame(p = (d$precinct == 1), x = d$x, y = d$y)

l = glm(p~poly(x,2)*poly(y,2), data=pdata, family=binomial)

pred_cells = which(r[] != 0)
pred_locs = xyFromCell(r,pred_cells) %>% as.data.frame()

pred = r
pred[pred_cells] = predict(l, newdata=pred_locs, type="response")
plot(pred, asp=0)


## Modeling - Logistic Regression across Precinct

pred_cells = which(r[] != 0)
pred_locs = xyFromCell(r,pred_cells) %>% as.data.frame()

res = list()
for(i in seq_along(good_precincts))
{
  pdata = data.frame(p = (d$precinct == good_precincts[i]), x = d$x, y = d$y)
  
  l = glm(p~poly(x,2)*poly(y,2), data=pdata, family=binomial)
  res[[i]] = predict(l, newdata=pred_locs, type="response")
}

probs = do.call(cbind, res)

pred_prec = good_precincts[ apply(probs, 1, which.max) ]

pred_mlr = r
pred_mlr[pred_cells] = pred_prec
plot(pred_mlr, asp=0)


## Modeling - Multinomial

library(nnet)

l = multinom(precinct~poly(x,2)*poly(y,2), data=d)

pred_mr = r
pred_mr[pred_cells] = predict(l, newdata=pred_locs)
plot(pred_mr, asp=0)


## Modeling - xgboost

library(xgboost)

xg_data = as.matrix(d[,c("x","y")])
xg_label = as.matrix(d[,"precinct"]) %>% 
  as.factor() %>% 
  as.numeric() - 1
  
l = xgboost(data=xg_data, label=xg_label, 
            objective="multi:softmax",num_class=length(good_precincts),
            nrounds=20)

p = predict(l, newdata=as.matrix(pred_locs))
pred_lab = good_precincts[p+1]

  
pred_xg = r
pred_xg[pred_cells] = pred_lab
plot(pred_xg, asp=0)


## Modeling - SVM

library(e1071)

s = svm(as.factor(precinct)~x+y, data=d)

pred_svm = r
pred_svm[pred_cells] = predict(s, newdata=pred_loc)
plot(pred_svm,asp=0)



## Model output

poly = rasterToPolygons(pred_xg, dissolve = TRUE)
names(poly) = "Precinct"

source("https://raw.githubusercontent.com/Sta323-Sp16/Homework/master/hw5/write_geojson.R")

write_geojson(poly, "precincts.json")


