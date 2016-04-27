library(shiny)

shinyUI(
  fluidPage(
    fluidRow(
      column(8, align = "center", offset = 2,
             tags$textarea(id="original_text", rows=15, cols=80, "Enter job posting..."),
             tags$style(type="text/css", "#string { height: 50px; width: 100%; text-align:center; font-size: 30px; display: block;}")
      ),
      column(8, align = "center", offset = 2,
             actionButton(inputId = "process_post", label = "Recommend!"))
    ),
    fluidRow(
      column(8, offset = 2,
      uiOutput("course1url"),
      uiOutput("course2url")
      ),
      column(8, offset = 2,
      uiOutput("book1url"),
      uiOutput("book2url")
      )
    )
  )
)