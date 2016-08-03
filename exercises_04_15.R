library(magrittr)
library(dplyr)
library(stringr)

## Word Count Example

data = list("the quick brown fox", "jumped over the lazy dog", "",
            "the the the the the the the", "dog fox dog")

#data = readLines("/data/Sta323/Shakespeare/hamlet.txt")


map_res = lapply(data, function(l) {
             str_split(l," ")[[1]] %>% .[. != ""] %>%  table() %>% as.list()
          }) %>% unlist(recursive = FALSE)

keys = unique(names(map_res))

shuffle = lapply(keys, function(x) map_res[names(map_res) == x] %>% unlist()) %>% setNames(keys)

reduce = lapply(shuffle, sum)

data.frame(keys = names(reduce), values = unlist(reduce)) %>% arrange(desc(values)) %>% head(n=50)


## Generic Map Reducer


mapreduce = function(map_func, reduce_func)
{
  function(data)
  {
    # Map Step
    map_res = lapply(data, map_func) %>% unlist(recursive = FALSE)
    
    # Shuffle step
    keys = names(map_res) %>% unique()
    shuffle = lapply(keys, function(x) map_res[names(map_res) == x] %>% unlist()) %>% setNames(keys)
    
    # Reduce step 
    reduce = lapply(shuffle, reduce_func)
    
    return(reduce)
  }
}

word_count_map = function(l)
{
    str_split(l," ")[[1]] %>% .[. != ""] %>%  table() %>% as.list()
}

word_count = mapreduce(word_count_map, sum)
word_count(data)


word_unique = mapreduce(word_count_map, function(x) return(1))
tmp = word_unique(data)



word_length_map = function(l)
{
  words = str_split(l, " ")[[1]] %>% .[. != ""]
  word_lengths = nchar(words)
  return(table(word_lengths) %>% as.list())
}

word_length = mapreduce(word_length_map, sum)
word_length(data)


