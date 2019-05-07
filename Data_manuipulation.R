search_word = function(list_){
  
  if (length(list_==1)){
    return(grep(list_[1], recipes$ingredient_name, value = T))
  } else{
    
  }
}

recipes['index'] = 1:nrow(recipes)



# Converting Time '1 hour x minutes'
hour_minute = grep('(1)\\s\\b[hour]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)
one_hour_minutes_df = recipes %>% filter(index %in% hour_minute) %>% select(time)
as.integer(str_extract(string = one_hour_minutes_df$time, '\\d{2}'))
recipes[c(grep('(1)\\s\\b[hour]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)),]$time_in_minutes = as.integer(str_extract(string = one_hour_minutes_df$time, '\\d{2}'))+60

# Converting Time '2 hours x minutes'
two_hour_minute = grep('(2)\\s\\b[hour]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)
two_hour_minutes_df = recipes %>% filter(index %in% two_hour_minute) %>% select(time)
recipes[c(grep('(2)\\s\\b[hour]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)),]$time_in_minutes = as.integer(str_extract(string = two_hour_minutes_df$time, '\\d{2}'))+120

# Converting Time '2 hours x minutes'
two_hours_minute = grep('(2)\\s\\b[hours]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)
two_hours_minutes_df = recipes %>% filter(index %in% two_hours_minute) %>% select(time)
recipes[c(grep('(2)\\s\\b[hours]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)),]$time_in_minutes = as.integer(str_extract(string = two_hours_minutes_df$time, '\\d{2}'))+120

#Converting time '3 hours x minutes'
three_hour_minute = grep('(3)\\s\\b[hours]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)
three_hour_minutes_df = recipes %>% filter(index %in% three_hour_minute) %>% select(time)
recipes[c(grep('(3)\\s\\b[hours]+\\s(\\d+)\\s\\b[minutes]+', recipes$time)),]$time_in_minutes = as.integer(str_extract(string = three_hour_minutes_df$time, '\\d{2}'))+180

#Converting time 'x hour'
x_hour = grep('(?<!\\/)(\\d)\\s[hours?]+(?!.)', recipes$time, perl = T)
x_hour_df = recipes %>% filter(index %in% x_hour) %>% select(time)
recipes[c(grep('(?<!\\/)(\\d)\\s[hours?]+(?!.)', recipes$time, perl = T)),]$time_in_minutes = as.integer(str_extract(string = x_hour_df$time, '\\d(?=\\shour)'))*60

#Converting time 'x minutes'
x_minutes = grep('(?<!.)(\\d+\\sto\\s)?(A?a?bout\\s)?\\d{1,2}\\s(minutes)', recipes$time, perl = T)
x_minutes_df = recipes %>% filter(index %in% x_minutes) %>% select(time)
recipes[c(grep('(?<!.)(\\d+\\sto\\s)?(A?a?bout\\s)?\\d{1,2}\\s(minutes)', recipes$time, perl = T)),]$time_in_minutes = as.integer(str_extract(string = x_minutes_df$time, '\\d+(?=\\sminutes)'))

#Converting time 'x y/4 hours'
x_half4_hour = grep('\\d\\s\\d\\/4', recipes$time, perl = T)
x_half4_hour_df = recipes %>% filter(index %in% x_half4_hour) %>% select(time)
recipes[c(grep('\\d\\s\\d\\/4', recipes$time, perl = T)),]$time_in_minutes = as.integer(str_extract(string = x_half4_hour_df$time, '\\d(?=\\s\\d\\/4)'))*75

#Converting time 'x y/2 hours'
x_half2_hour = grep('\\d\\s\\d\\/2', recipes$time, perl = T)
x_half2_hour_df = recipes %>% filter(index %in% x_half2_hour) %>% select(time)
recipes[c(grep('\\d\\s\\d\\/2', recipes$time, perl = T)),]$time_in_minutes = as.integer(str_extract(string = x_half2_hour_df$time, '\\d(?=\\s\\d\\/2)'))*90

recipes2 = recipes %>% filter(time_in_minutes!=0)

recipes2['picture'] = ifelse(recipes2$picture_src=='https://i.pinimg.com/564x/51/b5/6b/51b56b3b04cfce032209558197e1f993.jpg',
                             'No Picture', 'Picture')
# Fast - Medium - Slow
recipes2 = recipes2 %>% mutate('Time_Category' = ifelse(time<=10, 'Quick', ifelse(time<=60, 'Mid_length', 'Long'))) 

# Review num - time of recipe
recipes2 %>% 
  ggplot(aes(x = picture, y = log(num_ratings))) +
  geom_boxplot()




# Two sample t test that shows having a picture gives a 
# statistically significant difference to the mean num_ratings
plot_ly(data = recipes2, y = num_ratings, x = ~rating, type = 'box')

x1 = recipes2 %>% filter(picture=='Picture') %>% select(num_ratings)
x2 = recipes2 %>% filter(picture=='No Picture') %>% select(num_ratings)

var.test(x1$num_ratings, x2$num_ratings)

t.test(x1$num_ratings, x2$num_ratings)

# Author vs. avg_rating
recipes2 %>% group_by(author) %>% summarise(n = n(), mean_rating=mean(num_ratings)) %>% 
  arrange(desc(n)) # %>% 
  ggplot(aes(x = author, y = mean_rating)) +
  geom_col()
  
# Time vs. Rating
recipes2 %>% 
  group_by(rating) %>% summarise(mean_time = mean(time_in_minutes))

recipes2 %>% ggplot(aes(x = rating, y = log(time_in_minutes), group = rating)) +
  geom_boxplot() 



# Correlation values for rating vs. num_ratings
recipes %>% ggplot(aes(x = rating, y = log(num_ratings), group = rating)) +
  geom_boxplot()

summary(lm(data = recipes2, formula = num_ratings ~ rating))

cor(x = recipes2$rating, y = log(recipes2$num_ratings), method = 'pearson')

cor.test(recipes2$rating,log(recipes2$num_ratings))
# p-value = 2.2e-16
# cor = .276

x = recipes2[1,] %>%
  transform(y = unlist(tags)) %>%
  unnest(y)





# Finding most popular tags with tag having n>4
dt = data.table(recipes2)
tags_list = dt[ , list( tags = unlist( strsplit( tags , "," ) ) )]

tag_words_count = tags_list %>% group_by(tags) %>% summarise(n = n()) %>% arrange(desc(n))
grep(tag_words_count$tags, recipes2$tags)


num_ratings = c()

for (tag_word in tag_words_count$tags){
  df_temp = recipes2 %>% filter(index %in% grep(tag_word, tags))
  num_ratings = append(num_ratings, mean(df_temp$num_ratings))
}

tag_words_count['mean_num_ratings'] = num_ratings

# significant difference if cook_category is used or not

used = recipes2 %>% filter(is.na(cook_category)==F)
notused = recipes2 %>% filter(is.na(cook_category)==T)
TimesClassic = recipes2 %>% filter(cook_category=='Times Classic')
Easy = recipes2 %>% filter(cook_category=='Easy')
Healthy = recipes2 %>% filter(cook_category=='Healthy')
ePick = recipes2 %>% filter(cook_category=="Editors' Pick")
cookbook = recipes2 %>% filter(cook_category=="Cookbook Exclusive")
mean(used$num_ratings)
mean(notused$num_ratings)
mean(TimesClassic$num_ratings)
mean(Easy$num_ratings)
mean(Healthy$num_ratings)
mean(ePick$num_ratings)
mean(cookbook$num_ratings)




# Boxplot by cook_category 
recipes2 %>% ggplot(aes(x = fct_relevel(cook_category, c('Healthy', 'NA', 'Easy', 'Cookbook Exclusive', 'Times Classic', "Editors' Pick")), y = log(num_ratings))) + 
  geom_boxplot()
#density curves by cook_category
recipes2 %>% ggplot(aes(x = log(num_ratings), color = cook_category)) +
  geom_density() +
  ggtitle("Distributuions of ratings for 'Special Categories'") + 
  xlab('Number of ratings') + 
  ylab('Density')

t.test(TimesClassic$num_ratings, notused$num_ratings)
t.test(ePick$num_ratings, notused$num_ratings)



# There is a significant difference if the TimesClassic category is used vs. not using a category

t.test(notused$num_ratings, TimesClassic$num_ratings)
t.test(notused$num_ratings, Easy$num_ratings)


# Popularity by time_category
recipes2 %>% ggplot(aes(x = Time_Category, y = log(num_ratings))) +
  geom_boxplot()




