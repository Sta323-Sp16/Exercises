## Exercise 1

d = data.frame(
      Patient = 1:16,
      Gender  = rep(c("Male","Female"),c(8,8)),
      "Trt1"  = rep(c("Yes","No"),c(4,4)),
      "Trt2"  = rep(c("Yes","No"),c(2,2)),
      "Trt3"  = c("Yes","No")
    )

## Exercise 2

x = c(56, 3, 17, 2, 4, 9, 6, 5, 19, 5, 2, 3, 5, 0, 13, 12, 
      6, 31, 10, 21, 8, 4, 1, 1, 2, 5, 16, 1, 3, 8, 1,
      3, 4, 8, 5, 2, 8, 6, 18, 40, 10, 20, 1, 27, 2, 11, 
      14, 5, 7, 0, 3, 0, 7, 0, 8, 10, 10, 12, 8, 82,
      21, 3, 34, 55, 18, 2, 9, 29, 1, 4, 7, 14, 7, 1, 2, 
      7, 4, 74, 5, 0, 3, 13, 2, 8, 1, 6, 13, 7, 1, 10,
      5, 2, 4, 4, 14, 15, 4, 17, 1, 9)

primes = c(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 
           43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)

n = length(x)

# Select every third value starting at position 2 in x.

s = seq(2, n, by=3)
x[s]

s = (1:n)*3 - 1
s = s[s<=100]
x[s]



# Remove all values with an odd index (e.g. 1, 3, etc.) 

x[-seq(1,n,by=2)]

x[ 1:n %% 2 == 0 ]

x[ !(1:n %% 2 == 1) ]

# Select only the values that are primes. (You may assume all values are less than 100)

x[ x %in% primes ]

# Remove every 4th value, but only if it is odd.

x[! ((1:n %% 4 == 0) & (x %% 2 == 1))] 



## Exercise 3


# In class on Monday 2/8