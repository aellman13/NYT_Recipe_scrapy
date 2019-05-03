library(tidyverse)


recipes = read_csv('NYT_recipes.csv')

# Column to factor

col_to_factor = function(column_name, df){
  df$column_ = forcats::as_factor(df$column_name) 
}

col_to_factor(column_name = author, df = recipes)


# Fill in missing picture src
recipes$picture_src = ifelse(is.na(recipes$picture_src)== TRUE, 'https://i.pinimg.com/564x/51/b5/6b/51b56b3b04cfce032209558197e1f993.jpg', recipes$picture_src)

# split yield_num column
recipes$yield_num = stringr::str_split(recipes$yield_num, pattern = ',')

# Fix Yield columns and combine
structure_yield_column = function(){
  recipes$yield_metric = ifelse(length(recipes$yield_num)==2 & recipes$yield_num
}


# Combine the ingredient_amount and ingredient_name columns

stringr::str_split(recipes$ingredient_amount, pattern=',')
gsub(pattern = ".[,].", replacement = '--', x = recipes$ingredient_name, perl=TRUE)
stringr::str_split(recipes$ingredient_name, pattern=',')

x = c(1:4)
y = c(5:8)
list(x,y)
x1 = str_split(x, pattern=',')
y1 = str_split(y, pattern=',')
as.list(paste(x,y))       
paste('a', 1)
