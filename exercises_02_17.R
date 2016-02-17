library(rvest)
library(magrittr)

page = read_html("http://imdb.com")

movies = page %>% 
          html_nodes(".aux-content-widget-2:nth-child(15) .title")
df = data.frame(
       title = movies %>% html_nodes("a") %>% html_text(trim=TRUE),
       stringsAsFactors = FALSE
     )

df$gross = movies %>% html_nodes("span") %>% html_text()

links = movies %>% html_nodes("a") %>% html_attr("href") %>% paste0("http://imdb.com", .)

