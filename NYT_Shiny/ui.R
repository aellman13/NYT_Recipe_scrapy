
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # App title ----
    titlePanel("NYT Recipes"),
    
    # Sidebar layout with input and output definitions ---
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(type = "tabs",
                        tabPanel("Front Page"),
                        tabPanel("Ratings", column(7,plotOutput('rating_v_numRating'),
                                                h3('Pearson Correlation coefficient = .276')),
                                            column(4, img(src = 'num_ratings.png'))),
                        tabPanel("Picture or No Picture", column(5, plotOutput('picture'),
                                                                 h2('F-test p-value = 9.07e-05')),
                                                            column(4, img(src = 'Picture.png'),
                                                                    img(src = 'No_Picture.png'))),
                        tabPanel("Cooking Category", column(6, plotOutput('cook_category_density'),
                                                        plotOutput('cook_category_box')),
                                                    column(6, img(src='cook_category.png'))),
                        tabPanel("NYT Category")
            )
            
        )
    )
