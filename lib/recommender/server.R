library(shiny)

source("recommendation.R")

shinyServer(
  function(input, output) {
    post <- eventReactive(eventExpr = input$process_post,
                          valueExpr = {build_matrix(input$original_text)})
    output$course1 <- as.character(recommendation_course(post())$course_name_1)
    output$course1url <- renderUI(tags$a(output$course1, href = as.character(recommendation_course(post())$course_URL_1)))
    output$course2 <- renderText({as.character(recommendation_course(post())$course_name_2)})
    output$course2url <- renderText({as.character(recommendation_course(post())$course_URL_2)})
    output$book1 <- renderText({as.character(recommendation_book(post())$book_name_1)})
    output$book1url <- renderText({as.character(recommendation_book(post())$book_URL_1)})
    output$book2 <- renderText({as.character(recommendation_book(post())$book_name_2)})
    output$book2url <- renderText({as.character(recommendation_book(post())$book_URL_2)})

  }
  )