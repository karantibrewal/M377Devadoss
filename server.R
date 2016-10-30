
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)




shinyServer <- function(input, output) {
  
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
                      "Econo",
                      "Psych",
                      "Geos",
                      "Bio",
                      "Chem", 
                      "Phys",
                      "CS",
                      "Math"
  )
  
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
  
  generateFromToDf <- function() { 
    from = sample(majorsAvailable, 25, replace = T)
    to = sample(careersAvailable, 25, replace = T)
    value = sample(c(1,2,3), size = 25, replace = T)
    df <- data.frame("from" = from, "to" = to, "value" = value)
  }
  


  output$sankey <- renderPlot({
    df <- generateFromToDf()
    chordDiagram(df, grid.col = grid.color, transparency = 0)
  })

}

