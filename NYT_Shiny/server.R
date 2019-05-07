
library(shiny)
library(googleVis)


server <- function(input, output, session){
    
    output$rating_v_numRating = renderPlot({
        recipes2 %>% ggplot(aes(x = rating, y = log(num_ratings), group = rating, fill = rating)) +
            geom_boxplot() + 
            ggtitle('Rating vs. Total Number of Ratings')+
            xlab('Rating (1-5)') +
            ylab('Total Number of Ratings (log)') + 
            coord_cartesian(xlim = 2.5:5.5, expand = TRUE) +
            theme(legend.position = 'none')
    })
    
    output$picture = renderPlot({
        recipes2 %>% ggplot(aes(x = picture, y = log(num_ratings), group = picture, fill = picture)) +
            geom_boxplot() + 
            ggtitle('Pcture vs. No Picture')+
            xlab('Picture') +
            ylab('Total Number of Ratings (log)') + 
            theme(legend.position = 'none')
    })
    
    output$cook_category_density = renderPlot({
        recipes2 %>% ggplot(aes(x = log(num_ratings), color = cook_category)) +
            geom_density() +
            ggtitle("Distributuions of ratings for 'Special Categories'") + 
            xlab('Number of ratings (log)') + 
            ylab('Density') +
            theme(legend.position = 'none')
    })
    
    output$cook_category_box = renderPlot({
        recipes2 %>% ggplot(aes(x = cook_category, y = log(num_ratings), fill = cook_category)) +
            geom_boxplot() +
            ggtitle("Distributuions of ratings for 'Special Categories'") + 
            xlab('Category') + 
            ylab('Number of Ratings (log)') +
            theme(legend.position = 'none')
    })
    
    
    
}


 
