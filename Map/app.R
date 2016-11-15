#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


lastPlotMap <- data.frame()
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
colors <- c()
colors["Finance"] <- "darkmagenta"
colors["Tech"] <- "green"
colors["Social Work"] <- "deepskyblue"
colors["Education"] <- "firebrick"
colors["Consultancy"] <- "yellow"




library("leaflet")
library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Locating Ephs"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        box(width = NULL, 
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
        box(width = NULL, height = 30),
        box(width = NULL, 
            plotOutput("biggestEmployers"))
        
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
            ),
        box(width = NULL,
            plotOutput("bar", click = "bar_click", hover = "bar_hover")
        ),
        box(width = NULL,
            plotOutput("bar2", click = "bar2_click", hover = "bar2_hover")
        )
      )
   )
))

DF <- generateDF(industry, colors)
lastSubset <- DF
oldClick_X <- 0
oldClick_Y <- 0
# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   output$mymap <- renderLeaflet({
     leaflet(DF) %>% addTiles() %>%
     addCircles(lng = ~Long, lat = ~Lat, weight = 1,
                radius = ~Freq * 10000, color = ~Col, popup = ~Popup) %>%
                addLegend("bottomright", colors = colors, labels = industry, opacity = 1,
                          title = "Industry")
   
                
     
   })
   
   output$biggestEmployers <- renderPlot({
     name <- LETTERS[1:10]
     freqs <- runif(10, 0, 100)
     thisDf <- data.frame(name = name, freq = freqs)
     ggplot(thisDf, aes(x = name, y = freq)) +
       geom_bar(stat = "identity", fill = "blue", width = 0.75) +
       coord_flip() + labs(title = "Biggest Employers") + xlab("Name") + 
       theme(plot.title = element_text(size=22))
     
       
   })
   
  
   output$bar <- renderPlot({
     frequency <- summarise(group_by(DF, Indus), sum(Freq))[2]
     frequency <- c(frequency)[["sum(Freq)"]]
     indus <- ordered(industry)
     indus <- ordered(indus, levels = industry)
     thisDf <- data.frame(freq = frequency, indus = indus)
     isBarGeo <- F
     ggplot(thisDf, aes(x = indus, y = freq)) + 
       geom_bar(stat = "identity", fill = colors, width = 0.75) +
       xlab("Industry") + ylab("") + labs(title = "Distribution of Ephs in Industry") +
       theme(plot.title = element_text(size=22))
     
   })
   

   
   observeEvent(input$visualize, {
     indus <- industry[as.numeric(input$Industry)]
     col <- colors[as.numeric(input$Industry)]
     df <- generateDF(indus, col)
     lastSubset <- df
     output$mymap <- renderLeaflet({
       leaflet(df) %>% addTiles() %>%
         addCircles(lng = ~Long, lat = ~Lat, weight = 1,
                    radius = ~Freq * 10000, color = ~Col, popup = ~Popup) %>%
         addLegend("bottomright", colors = col, labels = indus, opacity = 1,
                   title = "Industry")
     })
     output$bar <- renderPlot({
       frequency <- summarise(group_by(df, Indus), sum(Freq))[2]
       frequency <- c(frequency)[["sum(Freq)"]]
       indus_ <- ordered(indus)
       indus_ <- ordered(indus_, levels = indus)
       thisDf <- data.frame(freq = frequency, indus = indus_)
       ggplot(thisDf, aes(x = indus, y = freq)) + 
         geom_bar(stat = "identity", fill = colors[indus[1:length(indus)]], width = 0.75) +
         xlab("Industry") + ylab("") + labs(title = "Distribution of Ephs in Industry") +
         theme(plot.title = element_text(size=22))
     })
     
     output$biggestEmployers <- renderPlot({
       name <- LETTERS[1:10]
       freqs <- runif(10, 0, 100)
       thisDf <- data.frame(name = name, freq = freqs)
       ggplot(thisDf, aes(x = name, y = freq)) +
         geom_bar(stat = "identity", fill = "blue", width = 0.75) +
         coord_flip() + labs(title = "Biggest Employers") + xlab("Name") + 
         theme(plot.title = element_text(size=22))
       
       
     })
   })
   

  
   
   observeEvent(input$bar_click, {

         indus <- industry[as.numeric(input$Industry)]
         thisIndus <- indus[round(input$bar_click$x)]
         thisDf <- filter(lastSubset, Indus == thisIndus)
         output$bar2 <- renderPlot({
         ggplot(thisDf, aes(x = Cities, y = Freq)) + 
           geom_bar(stat = "identity", fill = colors[thisIndus], width = 0.75) + 
             xlab("Industry") + ylab("") + 
             labs(title = paste0("Geographical Distribution of Ephs in ", thisIndus)) +
             theme(plot.title = element_text(size=22))
         })
         
         df <- lastSubset
         output$bar <- renderPlot({
           df <- filter(df, Indus %in% indus)
           frequency <- summarise(group_by(df, Indus), sum(Freq))[2]
           frequency <- c(frequency)[["sum(Freq)"]]
           indus_ <- ordered(indus)
           indus_ <- ordered(indus_, levels = indus)
           thisDf <- data.frame(freq = frequency, indus = indus_)
           newCol <- rep("black", length(colors))
           newCol[which(names(colors) == thisIndus)] <- colors[thisIndus]
           ggplot(thisDf, aes(x = indus, y = freq)) + 
             geom_bar(stat = "identity", fill = newCol, width = 0.75) +
             xlab("Industry") + ylab("") + labs(title = "Distribution of Ephs in Industry") +
             theme(plot.title = element_text(size=22))
         })
     
         output$mymap <- renderLeaflet({
           leaflet(thisDf) %>% addTiles() %>%
             addCircles(lng = ~Long, lat = ~Lat, weight = 1,
                        radius = ~Freq * 10000, color = ~Col, popup = ~Popup) %>%
             addLegend("bottomright", colors = colors[thisIndus], labels = thisIndus, opacity = 1,
                       title = "Industry")
         })
         
         
     }) 
   

   
  
})

# Run the application 
shinyApp(ui = ui, server = server)

