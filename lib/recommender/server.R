library(shiny)

source("recommendation.R")

shinyServer(
  function(input, output) {
    post <- eventReactive(eventExpr = input$process_post,
                          valueExpr = {build_matrix(input$original_text)})
    course1 <- reactive({
      as.character(recommendation_course(post())$course_name_1)
      })
    course2 <- reactive({
      as.character(recommendation_course(post())$course_name_2)
    })
    book1 <- reactive({
      as.character(recommendation_book(post())$book_name_1)
    })
    book2 <- reactive({
      as.character(recommendation_book(post())$book_name_2)
    })
    
    output$course1url <- renderUI(tags$a(course1(), href = as.character(recommendation_course(post())$course_URL_1)))
    output$course2url <- renderUI(tags$a(course2(), href = as.character(recommendation_course(post())$course_URL_2)))
    output$book1url <- renderUI(tags$a(book1(), href = as.character(recommendation_book(post())$book_URL_1)))
    output$book2url <- renderUI(tags$a(book2(), href = as.character(recommendation_book(post())$book_URL_2)))

  }
  )