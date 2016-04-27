previous <- 0
display.lag <- 1

library(tm)
library(ggplot2)
library(ggrepel)
library(R.utils)
library('scales')

quartz()
#### SECOND TAB
#_____________________________________________________________________________________________

# dtm <- readRDS("/Users/JPC/Documents/Columbia/2nd Semester/1. Applied Data Science/2. Homeworks/Project 5/finalproject-p5-team8/lib/dscube_app/jp_dtm_sparse.RDS") # document-term matrix
# keymatrix <- read.csv("/Users/JPC/Documents/Columbia/2nd Semester/1. Applied Data Science/2. Homeworks/Project 5/finalproject-p5-team8/lib/dscube_app/keymatrix.csv")
dtm <- readRDS("jp_dtm_sparse.RDS") # document-term matrix
keymatrix <- read.csv("keymatrix.csv")

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

########################
#Static Plots

skill_n <- c("d3js","r","c","stan","java","stata","linux","sql","python","nosql","postgresql","ruby","scala","perl","shiny","php","html5","tableau","markdown","hadoop","mapreduce","sas","matlab","excel","ppt","spark","julia","aws","mongodb","javascript","hbase","pig","hive","zookeeper","spss","shell")
skill_f <- colMeans(keymatrix[, skill_n])
skill <- data.frame(name = skill_n,freq = skill_f)
skill20 <- skill[order(-skill$freq), ][1:20,]
skill20 <- transform(skill20, name = reorder(name, freq))

knowledge_n <- c("dashboard","regression","dimension","forecast","algorithm","nonparametric","unsupervised","cluster","model","hierarchical","machine.learning","survival","multilevel","data.mining","linear","visualization","predict","analytic","design","sampling","optimization","deep.learning","classify","bayes","recommend","supervised","vision","gis","nlp","etl")
knowledge_f <- colMeans(keymatrix[, knowledge_n])
knowledge <- data.frame(name = knowledge_n,freq = knowledge_f)
knowledge20 <- knowledge[order(-knowledge$freq), ][1:20,]
knowledge20 <- transform(knowledge20, name = reorder(name, freq))

#### THIRD TAB
#_____________________________________________________________________________________________


#### SERVER
#_____________________________________________________________________________________________

shinyServer(
  function(input,output){
    
    # FIRST TAB
    # ________________________________________________________________________________________
    
    # CUSTOMIZED EVENTS
    # _________________________
    output$custom.events.widget<-renderUI(dynamic.events())
    dynamic.events <- eventReactive(input$show.custom.events,{
      end.time <- Sys.time()+display.lag
      # post.tweet(tweets.events$id[7],id.col.custevents)
      # while(Sys.time() < end.time){}
      return(
        HTML(
          "<a class='twitter-timeline' href='https://twitter.com/JPChamps/timelines/724826911453663232' data-widget-id='724827787769556993'>Customized Events</a>
          <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"
        ) 
        )
    })
    
    # CUSTOMIZED ARTICLES
    # ___________________________
    output$custom.articles.widget<-renderUI(dynamic.articles())
    dynamic.articles <- eventReactive(input$show.custom.articles,{
      end.time2 <- Sys.time()+display.lag
      # post.tweet(tweets.events$id[7],id.col.custarticles)
      # while(Sys.time() < end.time2){}
      return(
        HTML(
          "<a class='twitter-timeline' href='https://twitter.com/JPChamps/timelines/725065379920359424' data-widget-id='725090915874910209'>Customized Articles</a>
          <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"
        ) 
        )
    })
    
    # SECOND TAB
    # ________________________________________________________________________________________    
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
    })
    # define your new plot here
    output$skillplot <- renderPlot({
      ggplot(skill20, aes(x = name, y = freq)) + geom_bar(stat = "identity", fill = "#FF99CC") + 
        coord_flip() + geom_text(aes(label = percent(freq)), hjust = -0.05, size = 3.5) + 
        theme(text = element_text(size=15), plot.title = element_text(size = rel(2),vjust = 2)) +
        labs(title = "Technology Ranking",x = "Technology",y = "Frequency") + scale_y_continuous(labels = scales::percent)
    })
    output$knowledgeplot <- renderPlot({
      ggplot(knowledge20, aes(x = name, y = freq)) + geom_bar(stat = "identity", fill = "#99CCFF") + 
        coord_flip() + geom_text(aes(label = percent(freq)), hjust = -0.05, size = 3.5) + 
        theme(text = element_text(size=15), plot.title = element_text(size = rel(2),vjust = 2)) + 
        labs(title = "Technique Ranking",x = "Technique",y = "Frequency") + scale_y_continuous(labels = scales::percent)
    })
    
    # THIRD TAB
    # ________________________________________________________________________________________
    
    }
    )