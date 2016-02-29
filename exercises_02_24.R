library(stringr)
library(magrittr)

## Exercise 1

names = c("Jarvez Nguyen", "Kaleb Cho", "Kyana Bradley", "Malik La", 
          "Mario Morales", "Trong Nguyen", "Abigail Ohmie", "Anthony Kessenich", 
          "Laura Gonzales", "Thomas Vue", "Nicolasa Soltero", "Sanjana Stuckey", 
          "Destiny Langley", "Brianna Ortiz", "Condeladio Owens", "Joshua Wilson", 
          "Abigail Adu", "Cassidy Chavez", "Megan Dorsey", "Maomao Brown"
         )

# detects first name starts with a vowel
str_detect(names, "^[AEIOU]") %>% which() %>% names[.]
str_detect(tolower(names), "^[aeiou]") %>% names[.]

# detects last name starts with a vowel
str_detect(names, "\\s[AEIOU]") %>% which() %>% names[.]
str_detect(names, "\\b[AEIOU]") %>% which() %>% names[.] # No good - gets first name

# detects first or last name start with a vowel
str_detect(names, "[AEIOU]") %>% which() %>% names[.]
str_detect(names, "^[AEIOU]|\\s[AEIOU]") %>% which() %>% names[.]

# detects neither first nor last name start with a vowel
!str_detect(names, "^[AEIOU]|\\s[AEIOU]")


str_detect(names, "^[AEIOU][a-z]* [AEIOU][a-z]*") %>% which() %>% names[.]

## Exercise 2