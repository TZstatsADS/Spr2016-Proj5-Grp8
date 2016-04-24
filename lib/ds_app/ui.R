library(shinydashboard)

shinyUI(
  dashboardPage(skin="yellow",
    dashboardHeader(title = "Data Science"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("NEWSFEED", tabName = "introduction", icon = icon("hand-peace-o")),
        menuItem("Understand the Market", tabName = "explore", icon = icon("map")),
        menuItem("Prepare for your job",tabName="survey",icon=icon("paper-plane"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName="introduction",
          # h2("Describe the app"),
          HTML(
            "<a class='twitter-timeline' href='https://twitter.com/JPChamps/timelines/724255445637058563' data-widget-id='724281761832808449'>Data Science Events</a>
              <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"
          ),
          HTML(
            "<a class='twitter-timeline' href='https://twitter.com/JPChamps/timelines/724288990690553861' data-widget-id='724291283158740992'>Articles</a>
            <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"
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
