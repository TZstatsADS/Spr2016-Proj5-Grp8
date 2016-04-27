library(markdown)
library(shinythemes)
tags$style
shinyUI(navbarPage(
                  # fluidRow(column(5,img(src="cube.png",width=35)),column(5,offset=5,h2("DSCube"))),
                  fluidRow("DSCube",img(src="cube.png",width=35),column(10,offset=10,br()),column(10,offset=10,br()),column(10,offset=10,br())),

                   theme=shinytheme("united"),
                   tabPanel("",
                      fluidPage(
                        column(12,offset=4,
                                h1("Data Science Cube"),
                                # HTML("<img src='http://49.media.tumblr.com/3da243faf084c38ec80954cbd750df08/tumblr_nbadm3ODgJ1r2geqjo1_500.gif' alt='cube / octahedron'>"),
                                HTML("<img class='irc_mi iZ0Ufc0OZdbU-pQOPx8XEepE' alt='' style='margin-top: 45px;' src='http://digitalblock.eu/wpimages/wp4ad06172.gif' width='304' height='304'>"),
                               br(),
                               br()
                                
                        ),
                        h3("Potentialialize your Data Science Knowledge and Skills",align="center")
                      )
                   ),
                   tabPanel("Newsfeed",
                      tags$head(
                        HTML(
                          "<style>
                          body {background-color:black;}
                          h1   {color:lightgrey;}
                          h3   {color:lightgrey;}
                          p    {color:green;}
                          </style>"
                        )
                      ),
                      fluidRow(
                        box(
                          HTML(
                            "<a class='twitter-timeline' href='https://twitter.com/JPChamps/timelines/724255445637058563' data-widget-id='724281761832808449'>Data Science Events</a>
                            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"
                          ) 
                        ),
                        box(
                          HTML(
                            "<a class='twitter-timeline' href='https://twitter.com/JPChamps/timelines/724288990690553861' data-widget-id='724291283158740992'>Articles</a>
                            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"
                          )
                          )
                        )
#                       fluidRow(
#                         column(width=10,offset=.3, h3("Looking for any specific topic? Customize your search!")),
#                         br()
#                       ),
#                       fluidRow(
#                         box(
#                           textInput("events.text",label="", value = ""),
#                           actionButton("show.custom.events","Search")
#                           # uiOutput("custom.events.widget")
#                         ),
#                         box(
#                           textInput("articles.text",label="", value = ""),
#                           actionButton("show.custom.articles","Search")
#                           # uiOutput("custom.articles.widget")
#                         )
#                       )

                   ),
                   tabPanel("Job Market",
                      fluidPage(
                        fluidRow(h1("Term Correlations in Indeed.com Job Postings",align="center"),br()),
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
                   ),
                   tabPanel("Prepare for your interview",
                            fluidPage()
                   )

#                    navbarMenu("More",
#                               tabPanel("Table",
#                                        DT::dataTableOutput("table")
#                               ),
#                               tabPanel("About",
#                                        fluidRow(
#                                          column(3,
#                                                 img(class="img-polaroid",
#                                                     src=paste0("http://upload.wikimedia.org/",
#                                                                "wikipedia/commons/9/92/",
#                                                                "1919_Ford_Model_T_Highboy_Coupe.jpg")),
#                                                 tags$small(
#                                                   "Source: Photographed at the Bay State Antique ",
#                                                   "Automobile Club's July 10, 2005 show at the ",
#                                                   "Endicott Estate in Dedham, MA by ",
#                                                   a(href="http://commons.wikimedia.org/wiki/User:Sfoskett",
#                                                     "User:Sfoskett")
#                                                 )
#                                          )
#                                        )
#                               )
#                    )
))