library(dplyr)
library(lubridate)

## Exercise 1

# 1. Which day had the most tickets issued? 
#    Which day the least? Be careful about your date range.

names(nyc) = make.names(names(nyc))

nyc %>% 
  select(Issue.Date) %>%
  group_by(Issue.Date) %>% 
  summarize(n=n()) %>% 
  mutate(Issue.Date = mdy(Issue.Date)) %>%
  arrange(Issue.Date) %>%
  filter(Issue.Date >= mdy("08/01/2013"), 
         Issue.Date <= mdy("06/25/2014")) %>%
  filter(n == min(n) | n == max(n))


# 2. Create a plot of the weekly pattern (tickets issued per day of the week) - 
#    When are you most likely to get a ticket and when are you least likely to get a ticket?

nyc %>% 
  select(Issue.Date) %>%
  mutate(Issue.Date = mdy(Issue.Date)) %>%
  filter(Issue.Date >= mdy("08/01/2013"), 
         Issue.Date <= mdy("06/25/2014")) %>%
  mutate(weekday = wday(Issue.Date, label=TRUE)) %>%
  group_by(weekday) %>%
  summarize(n=n()) %>%
  plot()


# 3. Which precinct issued the most tickets to Toyotas in Manhattan?

nyc %>% 
  filter(Vehicle.Make == "TOYOT") %>%
  filter(Issuer.Precinct <= 34, Issuer.Precinct > 0) %>%
  group_by(Issuer.Precinct) %>%
  summarize(n = n()) %>%
  arrange(desc(n))


# 4. How many different colors of cars were ticketed?

nyc %>% 
  select(Vehicle.Color) %>% 
  distinct() %>% 
  summarize(n_colors=n())
