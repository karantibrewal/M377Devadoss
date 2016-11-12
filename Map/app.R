#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

generateDF <- function(industry, colors){
  Col <- c()
  for(i in 1:length(industry)){
    Col <- c(Col, rep(colors[i], 10))
  }
  cities <- c("NYC", "San Francisco", "Chicago", "Seattle", "Boston", "Austin", "Miami", "Las Vegas",
              "Philadelphia", "Pittsburgh")
  lat <- c(40.71, 37.62, 41.87, 47.6062, 42.3601, 30.2672, 25.7617, 36.1699, 39.9526, 40.4406)
  long <- c(-74.00, -122.37, -87.62, -122.3321, -71.0589, -97.7431, -80.1918, -115.1398, -75.1652,
            -79.9959)
  Cities <- c()
  Indus <- c()
  Lat <- c()
  Long <- c()
  Freq <- c()
  for(i in 1:length(industry)) {
    freq <- runif(5, 0, 100)
    freq <- freq/sum(freq) * 100
    Indus <- c(Indus, rep(industry[i], 10))
    Lat <- c(Lat, lat)
    Long <- c(Long, long)
    freq <- runif(10, 0, 100)
    freq <- freq/sum(freq) * 100
    Freq <- c(Freq, freq)
    Cities <- c(Cities, cities)
  }
  
  Popup <- paste(Indus, "in", Cities)
  df <- data.frame(Cities, Lat, Long, Indus, Freq, Popup, Col)
  return(df)
}

industry <- c("Finance", "Tech", "Social Work", "Education", "Consultancy")
colors <- c("darkmagenta", "green", "deepskyblue", "firebrick", "yellow")


library("leaflet")
library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Locating Ephs"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        checkboxGroupInput("Industry", "Show",
                           choices = c(
                             "Finance" = 1,
                             "Tech" = 2,
                             "Social Work" = 3,
                             "Education" = 4,
                             "Consultancy" = 5
                           ),
                           selected = 1:5
        ),
        actionButton("visualize", "Visualize")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        box(width = NULL, title = strong("Location by Industry of Ephs"),
            p(
              class = "text-muted",
              paste("The size of the circle represents % of ephs in the industry. Use checkboxes
                    to subset.")
              ),
            leafletOutput("mymap")
            )
      )
   )
))
DF <- generateDF(industry, colors)
# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   
   output$mymap <- renderLeaflet({
     leaflet(DF) %>% addTiles() %>%
     addCircles(lng = ~Long, lat = ~Lat, weight = 1,
                radius = ~Freq * 10000, color = ~Col, popup = ~Popup) %>%
                addLegend("bottomright", colors = colors, labels = industry, opacity = 1,
                          title = "Industry")
   
                
     
   })
   observeEvent(input$visualize, {
     indus <- industry[as.numeric(input$Industry)]
     print(as.numeric(input$Industry))
     col <- colors[as.numeric(input$Industry)]
     df <- generateDF(indus, col)
     print(df)
     output$mymap <- renderLeaflet({
       leaflet(df) %>% addTiles() %>%
         addCircles(lng = ~Long, lat = ~Lat, weight = 1,
                    radius = ~Freq * 10000, color = col, popup = ~Popup) %>%
         addLegend("bottomright", colors = col, labels = indus, opacity = 1,
                   title = "Industry")
       
       
       
     })
   })
   
   
   
  
})

# Run the application 
shinyApp(ui = ui, server = server)

