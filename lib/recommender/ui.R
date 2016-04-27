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
      textOutput("course1"),
      uiOutput("course1url"),
      textOutput("course2"),
      textOutput("course2url")
      ),
      column(8, offset = 2,
      textOutput("book1"),
      textOutput("book1url"),
      textOutput("book2"),
      textOutput("book2url")
      )
    )
  )
)