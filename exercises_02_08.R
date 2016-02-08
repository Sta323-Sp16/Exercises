## Exercise 3 from 2/3

grades = data.frame(
  student = c("Alice","Bob","Carol","Dan","Eve","Frank",
              "Mallory","Oscar","Peggy","Sam","Wendy"),
  grade   = c(82, 78, 62, 98, 64, 53, 86, 73, 54, 57, 61),
  year    = c(3L, 2L, 2L, 1L, 3L, 3L, 4L, 3L, 2L, 2L, 1L),
  stringsAsFactors = FALSE
)


system.time({
  grades$letter_grade = NA
  
  grades$letter_grade[ grades$grade >= 90 & grades$grade <= 100] = "A"
  grades$letter_grade[ grades$grade >= 80 & grades$grade <= 89 ] = "B"
  grades$letter_grade[ grades$grade >= 70 & grades$grade <= 79 ] = "C"
  grades$letter_grade[ grades$grade >= 60 & grades$grade <= 69 ] = "D"
  grades$letter_grade[ grades$grade >= 0  & grades$grade <= 59 ] = "F"
  
  grades$letter_grade = factor(grades$letter_grade)
})

system.time({
  grade_table = c("F","F","F","F","F","F","D","C","B","A","A")
  grades$letter_grade2 = grade_table[as.integer(grades$grade / 10) + 1]
  grades$letter_grade2 = factor(grades$letter_grade2)
})


grades$passing = FALSE
grades$passing[grades$letter_grade %in% c("A","B","C")] = TRUE



## Exercise 1 

library(testthat)


fib_orig = function(n)
{
  stopifnot(is.integer(n))
  
  if (n < 2)
    return(n);
  
  return( fib(n-1L) + fib(n-2L) );
}

fib = function(n)
{
  stopifnot(is.integer(n))
  stopifnot(length(n) == 1)
  stopifnot(n >= 0)
  
  if (n < 2)
    return(n);
  
  return( fib(n-1L) + fib(n-2L) );
}


context("Testing fib function")

test_that("Good input",{
  expect_equal(fib(0L), 0L)
  expect_equal(fib(1L), 1L)
  expect_equal(fib(2L), 1L)
  expect_equal(fib(3L), 2L)
  expect_equal(fib(18L), 2584L)
})


test_that("Bad input",{
  expect_error(fib(1.1))
  expect_error(fib(-1L))
  expect_error(fib(c(1L,2L)))
  expect_error(fib("A"))
})
