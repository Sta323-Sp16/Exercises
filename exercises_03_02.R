library(dplyr)
library(nycflights13)



# 1. Which plane (check the tail number) flew out of 
#    each New York airport the most?

flights %>% group_by(origin, tailnum) %>% 
            summarize(n=n()) %>% 
            filter(tailnum != "") %>%
            ungroup() %>%
            arrange(desc(n),origin,tailnum) %>% 
            group_by(origin) %>%
            summarize(n = max(n), tailnum = tailnum[1])

# 2. What was the shortest flight out of each airport 
#    in terms of distance? In terms of duration?

flights %>% filter(!is.na(air_time)) %>%
            group_by(origin) %>% 
            arrange(air_time) %>% 
            summarize(air_time=min(air_time), dest=dest[1])

# 3. How many flights to Los Angeles (LAX) did each of 
#    the legacy carriers (AA, UA, DL or US) have in May 
#    from JFK, and what was their average duration?

flights %>% filter(origin == "JFK", dest == "LAX", month == 5, !is.na(air_time)) %>% 
            filter(carrier %in% c("AA", "UA", "DL", "US")) %>%
            group_by(origin, dest, carrier) %>% 
            summarize(n = n(), dur = mean(air_time))



# 4. Which date should you fly on if you want to have the 
#    lowest possible average depature delay? What about 
#    arrival delay?

flights %>% mutate(date = paste(month,day,year,sep="/")) %>%
            filter(!is.na(dep_delay), dep_delay > 0) %>%
            group_by(date) %>% summarize(avg_delay = mean(dep_delay)) %>%
            arrange(avg_delay)

flights %>% mutate(date = paste(month,day,year,sep="/")) %>%
            filter(!is.na(arr_delay), arr_delay > 0) %>%
            group_by(date) %>% summarize(avg_delay = mean(arr_delay)) %>%
            arrange(avg_delay)

# 5. Create a time series plot of each of the legacy 
#    carriers' average departure delay by day and origin 
#    airport.

# Pick UA

library(lubridate)

df = flights %>% filter(carrier %in% c("AA", "UA", "DL", "US"), !is.na(dep_delay)) %>% 
                 mutate(date = paste(month,day,year,sep="/") %>% mdy()) %>%
                 group_by(carrier, date, origin) %>%
                 summarize(avg_dep_delay = mean(dep_delay))
                 
df_ua_jfk = df %>% filter(carrier == "UA", origin == "JFK")
df_ua_ewr = df %>% filter(carrier == "UA", origin == "EWR")
df_ua_lga = df %>% filter(carrier == "UA", origin == "LGA")

plot(df_ua_jfk$date, df_ua_jfk$avg_dep_delay, type='l')
lines(df_ua_ewr$date, df_ua_ewr$avg_dep_delay, col='blue')
lines(df_ua_lga$date, df_ua_lga$avg_dep_delay, col='red')
