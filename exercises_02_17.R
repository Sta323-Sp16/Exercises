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

subpages = lapply(links, read_html)

get_poster = function(page)
{
  res = page %>% 
          html_nodes("#img_primary img") %>% 
          html_attr("src")
  if(length(res) == 0)
  {
    res = page %>%
            html_nodes("#title-overview-widget img") %>%
            .[1] %>%
            html_attr("src")
  }
  
  return(res)
}

df$poster_link = sapply(subpages, get_poster)

get_score = function(page)
{
  page %>%
    html_nodes("strong span") %>% 
    html_text()
}

df$score = sapply(subpages, get_score)
