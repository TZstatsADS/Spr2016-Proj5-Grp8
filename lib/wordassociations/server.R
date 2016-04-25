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
  points <- sort(sapply(vec1, FUN = term_assoc, term2 = term2, dtm = dtm), decreasing = TRUE)
  point_names <- gsub(paste("[.]", term2, sep = ""), "", names(points))
  points <- data.frame(points)
  points$index <- c(1:nrow(points))
  points$labels <- point_names
  points_plot <- ggplot(points, aes(x = index, y = points)) + 
    geom_point(size = 3) + 
    geom_label_repel(aes(label = labels)) +
    xlab(capitalize(deparse(substitute(vec1)))) +
    ylab("Correlation") +
    ggtitle(paste("How often various", deparse(substitute(vec1)), 
                  "are in the same job posting as", term2)) +
    theme_classic() +
    theme(panel.background = element_rect(fill = "#cdcfff"))
  return(points_plot)
}

shinyServer(function(input, output) {
  output$assocplot <- renderPlot({
    term2 <- switch(input$category2,
                    "technologies" = input$term2technologies,
                    "techniques" = input$term2techniques,
                    "industries" = input$term2industries)
    # if statements are messy but it avoids a bug caused by using switch() for category1
    if (input$category1 == "technologies") term_assoc_plot(technologies, term2, dtm)
    else if (input$category1 == "techniques") term_assoc_plot(techniques, term2, dtm)
    else if (input$category1 == "industries") term_assoc_plot(industries, term2, dtm)
  })
})
