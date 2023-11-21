library(shiny)
library(here)
library(tidyverse)
library(bslib)
library(shiny.fluent)

# read the csv file that contains the dataset into a tibble
dataset <- as_tibble(read.csv(here::here("population.csv")))
dataset <- rename(dataset, country = Entity,
                  year=Year,
                  historical_population = "Population.by.country..1800.to.2015..Gapminder...UN.", 
                  projected_population = "Population.by.country..historic.and.projections..Gapminder...UN.")
    
ui <- fluidPage(
    theme = bs_theme(version = 4, bootswatch = "sandstone"),
    # Application title
    
    headerPanel("Country Population by Years"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          style = "max-height:90vh; height: 90vh; overflow-y: auto;", 
          Toggle.shinyInput("logToggle", FALSE, label="Log10 Transformation for populations"),
          Toggle.shinyInput("projectionToggle", FALSE, label="Include projections after 2015"),
          checkboxGroupInput( inputId="countryCheckbox", label="Choose country (or countries) to show in graph:",
                              choices=sort(unique(dataset$country)), 
                              selected="Afghanistan"
            
          )
        ),

        # Show a plot of the generated distribution
        mainPanel(
          style = "max-height:90vh; height: 90vh; overflow-y: auto;", 
          plotOutput("plot"),
          DT::dataTableOutput("table")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  subset <- reactive({
    if (is.null(input$countryCheckbox)) {
      return(NULL)
    }    
    if (input$projectionToggle)
      dataset %>% filter(country==input$countryCheckbox) %>% group_by(country)
    else
      dataset %>% filter(country==input$countryCheckbox & year <= 2015) %>% group_by(country)
  })
  
  output$plot <- renderPlot({
    if (is.null(subset()))
      return()
    
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
  
  output$table <- DT::renderDataTable({
    subset()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
