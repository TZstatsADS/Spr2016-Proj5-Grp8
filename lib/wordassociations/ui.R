# UI for Shiny app for word associations - to be merged with full app

shinyUI(
fluidPage(
  titlePanel("Term Correlations in Indeed.com Job Postings"),
  
  fluidRow(
    column(width=10,offset=0.3,
      sidebarLayout(
        position = "left",
        sidebarPanel(
          radioButtons("category2",
                       label = "Choose a category:",
                       choices = list("technologies", "techniques", "industries")),
          conditionalPanel(
            condition = "input.category2 == 'technologies'",
            selectInput("term2technologies",
                        label = "Now choose a particular technology:",
                        choices = c("python", "r", "stata", "spss", "sas", "linux", "sql", "nosql", "postgresql", "android",
                                    "ruby", "django", "php", "mysql", "scala", "spark", "hadoop", "mapreduce", "pig",
                                    "java", "angularjs", "kafka", "hive", "aws", "mongodb", "perl", "c",
                                    "html", "javascript", "css", "nodejs", "tableau", "excel", "powerpoint",
                                    "aws", "cassandra", "hbase", "ios"))
          ),
          conditionalPanel(
            condition = "input.category2 == 'techniques'",
            selectInput("term2techniques",
                        label = "Now choose a particular technique:",
                        choices = c("optimization", "forecasting", "predictive", "machine", "analytics", "mining",
                                    "clustering", "classification", "survey", "regression", "bayesian", "modeling",
                                    "hypothesis", "algorithms", "visualization", "deep", "mapping", "recognition",
                                    "retrieval", "algebra", "nlp", "language", "unstructured", "etl"))
          ),
          conditionalPanel(
            condition = "input.category2 == 'industries'",
            selectInput("term2industries",
                        label = "Now choose a particular industry:",
                        choices = c("startup", "consulting", "finance", "retail", "marketing", "engineering", "logistics", "hospitality",
                                    "transportation", "telecommunications", "sales", "banking", "media", "research", "academic", "oil", "construction",
                                    "sports", "genomics", "healthcare", "medicine", "pharmaceutical", "biotech"))
          ),
          radioButtons("category1",
                       label = "Finally, choose a category to compare your chosen term to:",
                       choices = list("technologies", "techniques", "industries"),
                       selected = "techniques"),
          actionButton("refresh", label = "Plot!")
        ),
        mainPanel(
          plotOutput("assocplot")
        )
  ))),
  fluidRow(
    column(width=6,offset=0.2,
           plotOutput("skillplot")
          ),
    column(width=6,offset=0.2,
           plotOutput("knowledgeplot")
           )
    )
)
)
