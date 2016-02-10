
set.seed(112)
d = data.frame(matrix(rnorm(1e5 * 10),ncol=10))
d$cat = sample(LETTERS[1:5], 1e5, replace=TRUE)

### Exercise 1

func1 = function(d) # apply
{
  sub = !(names(d) == "cat")
  return(apply(d[,sub], 1, max))
} 

func2 = function(d) # sapply / lapply
{
  sub = !(names(d) == "cat")
  
  sapply(1:nrow(d), 
         function(i) {
           max(d[i,sub])
         })
}  
  
func3 = function(d) # vapply
{
  sub = !(names(d) == "cat")
  
  vapply(1:nrow(d), 
         function(i) {
           max(d[i,sub])
         },
         1)
}
  
func4 = function(d) # for loop
{
  sub = !(names(d) == "cat")
  
  res = rep(NA, nrow(d))
  for(i in 1:nrow(d))
  {
    res[[i]] = max(d[i,sub])
  }
  
  return(res)
}


system.time( replicate(1, func1(d)) )
system.time( replicate(1, func2(d)) )
system.time( replicate(1, func3(d)) )
system.time( replicate(1, func4(d)) )



### Exercise 2

func2_1 = function(d) # tapply
{
  l = list(
    tapply(d[,1], d$cat, median),
    tapply(d[,2], d$cat, median),
    tapply(d[,3], d$cat, median),
    tapply(d[,4], d$cat, median),
    tapply(d[,5], d$cat, median),
    tapply(d[,6], d$cat, median),
    tapply(d[,7], d$cat, median),
    tapply(d[,8], d$cat, median),
    tapply(d[,9], d$cat, median),
    tapply(d[,10], d$cat, median)
  )
  do.call(rbind, l)
}

func2_2 = function(d)
{
  sub = !(names(d) == "cat")
    
  res = matrix(NA, nrow=length(unique(d$cat)), ncol=sum(sub))
  for(i in 1:sum(sub))
  {
    res[,i] = tapply(d[,i], d$cat, median)
  }
  rownames(res) = sort(unique(d$cat))
  
  return(res)
}

func2_3 = function(d) # tapply
{
  sub = !(names(d) == "cat")
  
  sapply(d[,sub],
         function(x)
         {
           tapply(x, d$cat, median)
         })
}

system.time( replicate(1, func2_1(d)) )
system.time( replicate(1, func2_2(d)) )
system.time( replicate(1, func2_3(d)) )

