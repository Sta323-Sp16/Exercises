
## Exercise 1

### Part 1

typeof( c(1, NA+1L, "C") ) # character
typeof( c(1L / 0, NA) )    # double
typeof( c(1:3, 5) )        # double
typeof( c(3L, NaN+1L) )    # double
typeof( c(NA, TRUE) )      # logical


### Part 2

typeof( c(1, 1L) )
typeof( c(1, "one") )
typeof( c(1, TRUE) )
typeof( c(1L, "one") )
typeof( c(1L, TRUE) )
typeof( c("one", TRUE) )

# character > double > interger > logical



## Exercise 2

text = '
{
  "firstName": "John",
  "lastName": "Smith",
  "age": 25,
  "address": 
  {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": 10021
  },
  "phoneNumber": 
  [
    {
      "type": "home",
      "number": "212 555-1239"
    },
    {
      "type": "fax",
      "number": "646 555-4567"
    }
  ]
}'

library(jsonlite)
  
l = fromJSON(text, simplifyVector = FALSE)
str(l)



## Exercise 3

lvls = c("sun", "clouds", "rain", "snow")
forecast = c(3L,2L,3L,1L,1L,1L,1L)

attr(forecast, "levels") = lvls
attr(forecast, "class") = "factor"
attr(forecast, "names") = c("Mon","Tue","Wed","Thur","Fri","Sat","Sun")

