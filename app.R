# @author: Berke Ucar
# @version: 0.1.0
# @date: Nov 22, 2023

library(shiny)
library(here)
library(tidyverse)
library(bslib)
library(shiny.fluent)

# read the csv file that contains the dataset into a tibble
dataset <- as_tibble(read.csv(here::here("population.csv")))
# change the column names in a way that it is more meaningful/traceable
dataset <- rename(dataset, country = Entity,
                  year=Year,
                  historical_population = "Population.by.country..1800.to.2015..Gapminder...UN.", 
                  projected_population = "Population.by.country..historic.and.projections..Gapminder...UN.")

# User Interface component of the application
ui <- fluidPage(
    theme = bs_theme(version = 4, bootswatch = "sandstone"), # Feature no 1: Adding a Theme - I don't know about you but I believe themes are necessary for applications to make the UI appealing to the user.
    headerPanel("Country Population Over the Years"), # the title of the page

    sidebarLayout(
        sidebarPanel(
          style = "max-height:91vh; height: 91vh; overflow-y: auto;", # Feature no 2: Scrollbar to the sidebar - This allows the sidebar to have a scrollbar, which was necessary to keep the operator focused on the graphs rather then scrolling the graph with the checkboxes as well.
          Toggle.shinyInput("logToggle", FALSE, label="Log10 Transformation for populations"), # Feature no 3: Toggle input for logarithmic transformation on y axis - This is important since sometimes there is a huge difference between populations of different countries and user cannot see the low-populated country in the graph. This allows to bring those numbers closer and make the populations visible for all the countries.
          Toggle.shinyInput("projectionToggle", FALSE, label="Include projections after 2015"), # Feature no 4: Toggle input for inclusion of the projected population for countries - This dataset contains the predicted populations for the countries after 2015, which may not be irrelevant for all the users. So, there is a toggle bar to include the projections.
          checkboxGroupInput( inputId="countryCheckbox", label="Choose country (or countries) to show in graph:",
                              choices=sort(unique(dataset$country)), 
                              selected="Afghanistan"
            
          ) # Feature no 5: Checkbox inputs for the countries - This option allows users to select different countries to represent on the graph and table. This is relevant for users to compare population of multiple countries on the graph and/or the table.
        ),

        # Show a plot of the generated distribution
        mainPanel(
          style = "max-height:91vh; height: 91vh; overflow-y: auto;", # Feature no 6: Scrollbar to the main panel - This allows users to scroll up or down in order to see the table or graph clearer while not changing the focus on the options and see what they selected without scrolling up and down with the main panel.
          plotOutput("plot"),
          DT::dataTableOutput("table") # Feature no 7: Paginated Data Table - This allows users to search, paginate, sort the datatable in a neat manner. This is relevant since some users may need to check specific years or populations. Also, it is convenient and appealing since it is paginated as well.
        )
    )
)

# Server part of the application
server <- function(input, output) {
  # chooses a subset of the data table using the checkbox and projection toggle input
  subset <- reactive({
    if (is.null(input$countryCheckbox) | is.null(input$projectionToggle)) {
      return()
    }    
    if (input$projectionToggle){
      dataset %>% filter(country%in%input$countryCheckbox) %>% group_by(country)
    }
    else
      dataset %>% filter(country%in%input$countryCheckbox & year <= 2015) %>% group_by(country)
  })
  
  # Generates the graph based on the logartihmic transformation toggle and data set subsampled with subset method
  output$plot <- renderPlot({
    if (is.null(subset()))
      return(NULL)
    
    if (input$logToggle){
      ggplot(subset()) + 
        geom_bar(aes(year, projected_population, fill=country),stat = "identity") +
        scale_y_log10("Population (Scale: log10)") +
        xlab("Year") 
    }
    else{
      ggplot(subset()) + 
        geom_bar(aes(year, projected_population, fill=country),stat = "identity") + 
        scale_y_continuous("Population (Scale: Continuous)", labels=scales::number_format()) +
        xlab("Year") 
    }
    
  })
  
  # Generates the table based on the result generated with subset method
  output$table <- DT::renderDataTable({
    subset()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
