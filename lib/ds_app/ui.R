library(shinydashboard)

shinyUI(
  dashboardPage(skin="yellow",
    dashboardHeader(title = "Data Science"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Introduction",tabName="introduction",icon = icon("hand-peace-o")),
        menuItem("NEWSFEED", tabName = "newsfeed", icon = icon("hand-peace-o")),
        menuItem("Understand the Market", tabName = "explore", icon = icon("map")),
        menuItem("Prepare for your job",tabName="survey",icon=icon("paper-plane"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "introduction",
                fluidPage(center=T,
                          h1("show intro"),
                          HTML("<img src='http://49.media.tumblr.com/3da243faf084c38ec80954cbd750df08/tumblr_nbadm3ODgJ1r2geqjo1_500.gif' alt='cube / octahedron'>"),
                          HTML("<img class='irc_mi iZ0Ufc0OZdbU-pQOPx8XEepE' alt='' style='margin-top: 45px;' src='http://digitalblock.eu/wpimages/wp4ad06172.gif' width='304' height='304'>")
                )
        ),
        tabItem(
          tabName="newsfeed",
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
          ),
          fluidRow(
            column(width=10,offset=.3, h3("Looking for any specific topic? Customize your search!")),
            br()
          ),
          fluidRow(
            box(
              textInput("events.text",label="", value = ""),
              actionButton("show.custom.events","Search"),
              uiOutput("custom.events.widget")
            ),
            box(
              textInput("articles.text",label="", value = ""),
              actionButton("show.custom.articles","Search"),
              uiOutput("custom.articles.widget")
            )
          )
        ),
        tabItem(tabName = "explore",
                fluidPage(center=T,
                  h1("show sumary")
                )
        ),
        tabItem(tabName = "survey",
                h2("display recommendation app")
        )
      )
    )
  )
)
