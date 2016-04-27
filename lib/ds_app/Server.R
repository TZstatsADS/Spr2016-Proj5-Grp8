previous <- 0
display.lag <- 1
shinyServer(
  function(input,output){
    
    # CUSTOMIZED EVENTS
    # ________________________________________________________________________________________
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
    # ________________________________________________________________________________________
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
  }
)