library(tidyverse)


recipes = read_csv('NYT_recipes2.csv')

# Make new columns

recipes['index'] = 1:nrow(recipes)
recipes['time_in_minutes'] = 0

# Column to factor

col_to_factor = function(column_name, df){
  df$column_ = forcats::as_factor(df$column_name) 
}

col_to_factor(column_name = author, df = recipes)




