### M377 Data Visualiaztion Project
### Williams College
### Thomas Rosal, Karan Tibrewal
### Advisors: Steven Miller, Don Kjelleren, Dan Costanza



library(shiny)
library(ggplot2)

## Server for back end
shinyServer <- function(input, output, clientData, session) {
  
  ## Career Choices 
  careersAvailable = c("Art",
                       "Writing",
                       "Social",
                       "Govt",
                       "Law",
                       "Sales",
                       "Consulting",
                       "Finance",
                       "Insurance",
                       "K-12 Ed",
                       "College Ed",
                       "Health",
                       "Eng",
                       "Tech",
                       "Other"
  )
  
  ##Major Choices
  majorsAvailable = c("Art",
                      "Langs",
                      "Eng Lit" ,
                      "Phil",
                      "Cult Stud",
                      "Hist",
                      "PoliSci",
                      "Econ",
                      "Psych",
                      "Geos",
                      "Bio",
                      "Chem", 
                      "Phys",
                      "CS",
                      "Math"
  )
  
  ## Color Mapping
  grid.color = c("Art" = "#003366" ,
                 "Langs" = "#336699",
                 "Eng Lit" = "#0099cc",
                 "Phil" = "#00ccff",
                 "Cult Stud" = "#00ffff",
                 "Hist" = "#00ffcc",
                 "PoliSci"= "#009999",
                 "Econo" = "#006699",
                 "Psych" = "#0066ff",
                 "Geos" = "#3366ff",
                 "Bio" = "#333399",
                 "Chem" = "#000066", 
                 "Phys" = "#6666ff",
                 "CS" = "#6600cc",
                 "Math" = "#6699ff", 
                 "Writing" = "#003366", 
                 "Social" = "#336699",
                 "Govt" = "#0099cc",
                 "Law" = "#00ccff",
                 "Sales" = "#00ffff",
                 "Consulting" = "#00ffcc",
                 "Finance" = "#009999",
                 "Insurance" = "#006699",
                 "K-12 Ed" =  "#0066ff",
                 "College Ed" = "#0066ff",
                 "Health" = "#3366ff",
                 "Eng" = "#333399",
                 "Tech" = "#000066", 
                 "Other"  = "#6600cc")
  
  
  ## Function to generate placeholder data set from careers and majors as subsetted.
  ## @param majors subsetted majors
  ## @param careers subsetted careers
  ## @return placeholder data set with links from "majors" --> "careers"
  generateFromToDf <- function(majors, careers) { 
    from = sample(majors, 25, replace = T)
    to = sample(careers, 25, replace = T)
    value = sample(c(1,2,3), size = 25, replace = T)
    df <- data.frame("from" = from, "to" = to, "value" = value)
  }
  
  ## OBSERVE EVENT: "VISUALIZE BUTTON"
  ## @post: new subsets are loaded in from check boxes, and appropriate visualization
  ##        is created and delivered.
  observeEvent(input$visualize, {
     majors <- majorsAvailable[as.numeric(input$major)]
     careers <- careersAvailable[as.numeric(input$career)]
    output$sankey <- renderPlot({
      df <- generateFromToDf(majors, careers)
      chordDiagram(df, grid.col = grid.color, transparency = 0)
    })
  })
  
  ## OBSERVE EVENT: "VISUALIZE2 BUTTON"
  ## @post: new subsets are loaded in from check boxes, and appropriate sankey plot
  ##        is created and delivered
  observeEvent(input$visualize2, {
    majors <- majorsAvailable[as.numeric(input$major)]
    careers <- careersAvailable[as.numeric(input$career)]
    output$sankey <- renderPlot({
      df <- generateFromToDf(majors, careers)
      chordDiagram(df, grid.col = grid.color, transparency = 0)
    })
  })
  
  ## OBSERVE EVENT: "TIMELINE SLIDER"
  ## @post: new timeline is loaded in from slider, and appropriate bar plot
  ##        is created and delivered
  observeEvent(input$timeline, {
    output$timelinePlot <- renderPlot({
      freq <- sample(1:10, size = length(majorsAvailable), replace = TRUE)
      freq <- 100 * freq + runif(length(freq), min = -1, max = 1) * 100
      freq <- freq / sum(freq) * 2500
      df <- data.frame("majors" = majorsAvailable, "dist" = freq)
      g <- ggplot(df, aes(x = majors, y = dist)) + xlab("Major") + ylab("% Distribution")
      g + geom_bar(fill = "#9370DB", color = "black", stat = "identity")
    })
  })
  
 
  
  ## Creates and delivers default sankey visualization
  output$sankey <- renderPlot({
    df <- generateFromToDf(majorsAvailable, careersAvailable)
    chordDiagram(df, grid.col = grid.color, transparency = 0)
  })
  
  ## Creates and delivers default barplot (timeline) visualization
  output$timelinePlot <- renderPlot({
    # simulate placeholder data
    freq <- sample(1:10, size = length(majorsAvailable), replace = TRUE)
    # add jitters
    freq <- 100 * freq + runif(length(freq), min = -1, max = 1) * 100
    #normalize and distribute among 2500 students (5 years)
    freq <- freq / sum(freq) * 2500
    df <- data.frame("majors" = majorsAvailable, "dist" = freq)
    g <- ggplot(df, aes(x = majors, y = dist)) + xlab("Major") + ylab("Number of Majors")
    g + geom_bar(fill = "#9370DB", color = "black", stat = "identity")
  })

}

