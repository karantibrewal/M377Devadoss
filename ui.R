library(shinydashboard)
library(leaflet)

header <- dashboardHeader(
  title = "Williams College"
)

body <- dashboardBody(
  fluidRow(
    column(width = 8,
           box(width = NULL, title = strong("Career Path for 15600 Williams College Alums"),
               p(
                 paste("Each of the 15600 alums has an arc going from the left side of the circle to the right. Those with double majors have two arcs on the left (one from each of their majors, each arc with half thickness) that combine into one resulting career choice. Mouseover the labels on the image below to highlight that particular major or career compilation. 
                       Click the image on the right to select the Compilation graphic.")
               ),
               plotOutput("sankey")
           ),
           box(width = NULL, solidHeader = TRUE,
               sliderInput(inputId = "timeline", label = "Timeline", 
                           min = 1960, max = 2016, value = 2010, step = 5),
               p(
                 class = "text-muted",
                 paste("Five year intervals are grouped together.")
               )
           )
    ),
    column(width = 4,
           box(width = NULL, status = "warning", title = strong("Major"), 
               p(class = "text-muted",
                 "Subset by Major"
               ),
               checkboxGroupInput("major", "Show",
                                  choices = c(
                                    "Art/Music" = 1,
                                    "Languages" = 2,
                                    "English Literature" = 3,
                                    "Philosphy/Religion" = 4,
                                    "Culture Studies" = 5,
                                    "History" = 6,
                                    "Political Science" = 7,
                                    "Economics" = 8,
                                    "Psychology" = 9,
                                    "Geosciences" = 10, 
                                    "Biology" = 11,
                                    "Chemistry" = 12, 
                                    "Physics/Astrology" = 13,
                                    "Computer Science" = 14,
                                    "Math" = 15
                                  ),
                                  selected = 1:15
               ),
               actionButton("visualize", "Visualize")
           ),
               
           box(width = NULL, status = "warning", title = strong("Career"), 
               p(class = "text-muted",
                 "Subset by Career"
               ),
               checkboxGroupInput("career", "Show",
                                  choices = c(
                                    "Art/Entertainment" = 1,
                                    "Writing/Communication" = 2,
                                    "Social/Religious Services" = 3,
                                    "Government" = 4,
                                    "Law" = 5,
                                    "Sales" = 6,
                                    "Consulting" = 7,
                                    "Banking/Finance" = 8,
                                    "Insurance/Management" = 9,
                                    "K-12 Education" = 10, 
                                    "College Education" = 11,
                                    "Health/Medicine" = 12, 
                                    "Engineering/Construction" = 13,
                                    "Technology" = 14,
                                    "Math" = 15
                                  ),
                                  selected = 1:15
               ),
               actionButton("visualize", "Visualize")
           )
           
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)