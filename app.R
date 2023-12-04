library(shiny)

tags$head(
  tags$link(href = "bootstrap.min.css", rel = "stylesheet")
)

# m <- data.frame(
#   rbind(
#     cbind("winter", "gronkal with potatoes", "gronkal, potatoes, onions"),
#     cbind("summer", "peperonata", "peperoni, selery, onions, potatoes, tomatoes")
#   )
# )
# colnames(m) <- c("season", "dish", "ingredient")
# write.csv(m, "menu.csv")

data <- read.csv("menu.csv")
data <- data[, c("season", "dish", "ingredient")]

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  titlePanel("Menu"),
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(
      6,
      selectInput(
        "season",
        "Season:",
        c(
          "All",
          sort(unique(as.character(data$season)))
        )
      )
    ),
    column(
      6,
      selectInput(
        "ingredient",
        "Ingredient:",
        c(
          "All",
          sort(unique(unlist(strsplit(data$ingredient, ", ", as.character(data$ingredient)))))
        )
      )
    )
  ),
  # Create a new row for the table.
  DT::dataTableOutput("table")
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({

    if (input$season != "All") {
      m <- data[data$season == input$season, ]
    }
    if (input$ingredient != "All" && input$season == "All") {
      m <- data[grepl(input$ingredient, data$ingredient), ]
    }
    if (input$ingredient != "All" && input$season != "All") {
      m <- data[data$season == input$season, ]
      m <- m[grepl(input$ingredient, m$ingredient), ]
    }
    m
  }))
}

# Run the application 
shinyApp(ui = ui, server = server)
