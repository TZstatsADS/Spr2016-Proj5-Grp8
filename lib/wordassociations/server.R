# Server for Shiny app for word associations - to be merged with full app

library(tm)
library(ggplot2)
library(ggrepel)
library(R.utils)

dtm <- readRDS("./jp_dtm_sparse.RDS") # document-term matrix

technologies <- c("python", "r", "stata", "spss", "sas", "linux", "sql", "nosql", "postgresql", "android",
                  "ruby", "django", "php", "mysql", "scala", "spark", "hadoop", "mapreduce", "pig",
                  "java", "angularjs", "kafka", "hive", "aws", "mongodb", "perl", "c",
                  "html", "javascript", "css", "nodejs", "tableau", "excel", "powerpoint",
                  "aws", "cassandra", "hbase", "ios")

techniques <- c("optimization", "forecasting", "predictive", "machine", "analytics", "mining",
                "clustering", "classification", "survey", "regression", "bayesian", "modeling",
                "hypothesis", "algorithms", "visualization", "deep", "mapping", "recognition",
                "retrieval", "algebra", "nlp", "language", "unstructured", "etl")

industries <- c("startup", "consulting", "finance", "retail", "marketing", "engineering", "logistics", "hospitality",
                "transportation", "telecommunications", "sales", "banking", "media", "research", "academic", "oil", "construction",
                "sports", "genomics", "healthcare", "medicine", "pharmaceutical", "biotech")

term_assoc <- function(term1, term2, dtm) {
  if (!term1 %in% dtm$dimnames[2][[1]] | !term2 %in% dtm$dimnames[2][[1]]) {
    return(0)
  }
  if (term1 == term2) {
    return(1)
  }
  result <- findAssocs(dtm, term1, corlimit = 0)[[1]][term2]
  if (is.na(result)) {
    return(0)
  }
  else return(result)
}

term_assoc_plot <- function(vec1, term2, dtm) {
  if ("python" %in% vec1) {category_name <- "technologies"}
  else if ("optimization" %in% vec1) {category_name <- "techniques"}
  else if ("startup" %in% vec1) {category_name <- "industries"}
  points <- sort(sapply(vec1, FUN = term_assoc, term2 = term2, dtm = dtm), decreasing = TRUE)
  point_names <- gsub(paste("[.]", term2, sep = ""), "", names(points))
  points <- data.frame(points)
  points$index <- c(1:nrow(points))
  points$labels <- point_names
  points_plot <- ggplot(points, aes(x = index, y = points)) + 
    geom_point(size = 3) + 
    geom_label_repel(aes(label = labels)) +
    xlab(capitalize(category_name)) +
    ylab("Correlation") +
    ggtitle(paste("How often various", category_name, 
                  "are in the same job posting as", term2)) +
    theme_classic() +
    theme(panel.background = element_rect(fill = "#cdcfff"))
  return(points_plot)
}

shinyServer(function(input, output) {
  term2 <- eventReactive(eventExpr = input$refresh,
               valueExpr = {
      switch(input$category2,
             "technologies" = input$term2technologies,
             "techniques" = input$term2techniques,
             "industries" = input$term2industries)},
      ignoreNULL = TRUE)
  vec1 <- eventReactive(eventExpr = input$refresh,
               valueExpr = {
      switch(input$category1,
             "technologies" = technologies,
             "techniques" = techniques,
             "industries" = industries)},
      ignoreNULL = TRUE)
  output$assocplot <- renderPlot({
    term_assoc_plot(vec1(), term2(), dtm)
  # define your new plot here
  })
})
