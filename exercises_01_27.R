# Exercise 1

primes = c(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41,
           43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)
x = c(3, 4, 12, 19, 23, 48, 50, 61, 63, 78)


for(v in x)
{
  is_prime = FALSE
  for(prime in primes)
  {
    if (v == prime)
    {
      is_prime= TRUE
      break
    } 
  }
  if (!is_prime)
    print(v)
}

x[!x %in% primes]

