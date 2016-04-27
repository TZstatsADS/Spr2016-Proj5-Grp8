
### AUXILIAR FUNCTIONS
###____________________________________________________________________________________________
# col.id <- id.col.custevents
# rm(col.id)
tweets.in.collection <- function(col.id){
  url.temp <- paste0("https://api.twitter.com/1.1/collections/entries.json?id=",col.id)
  current.tweets <- GET(url.temp,config(token=twitter_token))
  temp <- content(current.tweets, as = "text")
  temp <- fromJSON(temp)
  response <- temp$response$timeline
  if(length(response)==0){
    return(NA)
  } else{
    id.current.events <- rep(NA,length(response))
    for (i in 1:length(response)){
      id.current.events[i] <- response[[i]]$tweet[1]
    }
  }
  return(id.current.events)
}
tweets.id <- final.events$id
post.tweets <- function(tweets.id,col.id){
  for (i in 1:length(tweets.id)){
    tweet.id <- tweets.id[i]
    post.tweet <- POST(paste0("https://api.twitter.com/1.1/collections/entries/add.json?tweet_id=",tweet.id,"&id=",col.id),config(token=twitter_token))
    temp <- content(post.tweet, as = "text")
    temp <- fromJSON(temp)
  }
  return(temp)
}
delete.tweets <- function(tweets.id,col.id){
  for (i in 1:length(tweets.id)){
    tweet.id <- tweets.id[i]
    url.temp <- paste0("https://api.twitter.com/1.1/collections/entries/remove.json?id=",col.id,"&tweet_id=",tweet.id)
    call <- POST(url.temp,config(token=twitter_token))
    call.res <- content(call, as = "text")
    call.res <- fromJSON(call.res)
  }
  return(call.res)
}


### CREATE COLLECTIONS
###____________________________________________________________________________________________

###   Suggested Events   ###
#___________________________#

# Post a collection for events:
# col.dsevents <- POST("https://api.twitter.com/1.1/collections/create.json?name=DSEvents",config(token=twitter_token))
temp <- content(col.dsevents, as = "text")
temp <- fromJSON(temp)
id.col.dsevents <- temp$response

# Modify name
url.temp <- paste0("https://api.twitter.com/1.1/collections/update.json?name=Events&id=",id.col.dsevents)
# col.update <- POST(url.temp,config(token=twitter_token))
temp <- content(col.update, as = "text")
temp <- fromJSON(temp)
temp

###   Customized Events   ###
#___________________________#

# Post a collection for events:
# col.custevents <- POST("https://api.twitter.com/1.1/collections/create.json?name=Customized%20Events",config(token=twitter_token))
temp <- content(col.custevents, as = "text")
temp <- fromJSON(temp)
id.col.custevents <- temp$response

###   Suggested Articles   ###
#___________________________#

# col.dsarticles <- POST("https://api.twitter.com/1.1/collections/create.json?name=Articles",config(token=twitter_token))
temp <- content(col.dsarticles, as = "text")
temp <- fromJSON(temp)
id.col.dsarticles <- temp$response

# Modify name
# url.temp <- paste0("https://api.twitter.com/1.1/collections/update.json?name=Events&id=",id.col.dsarticles)
# col.update <- POST(url.temp,config(token=twitter_token))
temp <- content(col.update, as = "text")
temp <- fromJSON(temp)
temp

###   Customized Articles   ###
#___________________________#
# col.custarticles <- POST("https://api.twitter.com/1.1/collections/create.json?name=Customized%20Articles",config(token=twitter_token))
temp <- content(col.custarticles, as = "text")
temp <- fromJSON(temp)
id.col.custarticles <- temp$response

###   Save collections ids   ###
#___________________________#

# save(id.col.custarticles,id.col.dsarticles,id.col.custevents,id.col.dsevents,file="/Users/JPC/Documents/R/twitter API/collections_ids.RData")
# save(col.custarticles,col.dsarticles,col.custevents,col.dsevents,file="/Users/JPC/Documents/R/twitter API/collections_call.RData")

### LOAD CREDENTIALS
###____________________________________________________________________________________________
load("/Users/JPC/Documents/R/twitter API/twitCred.RData")
load("/Users/JPC/Documents/R/twitter API/token.RData")
load("/Users/JPC/Documents/R/twitter API/twitCredentials.RData")
load("/Users/JPC/Documents/R/twitter API/collections_ids.RData")
# setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

### MODIFY TWEETS 
###____________________________________________________________________________________________

###   Suggested Events   ###
#___________________________#

# delete current tweets
# delete.tweets(tweets.in.collection(id.col.dsevents),id.col.dsevents)
tweets.in.collection(id.col.dsevents)
# Add tweets to the list:

delete.events <- c("723239750941822976","723787643176259584","724992968642453504","724868193043529728","724469270223151104","721974701191479296","722057049094418432","722403536567345152","722817347451543552")
index.delete.events <- which(tweets.events$id %in% delete.events)
final.events <- tweets.events[-1*index.delete.events,]
dim(final.events)
post.tweets(rev(final.events$id),id.col.dsevents)

# Delete tweets
delete.tweet(tweets.events$id[12],id.col.dsevents)

###   Customized Events   ###
#___________________________#
# Add tweets to the list:
post.tweet(tweets.events$id[1],id.col.dsevents)
delete.tweet(tweets.events$id[4],id.col.custevents)



###   Suggested Articles   ###
#___________________________#

# delete current tweets
# delete.tweets(tweets.in.collection(id.col.dsarticles),id.col.dsarticles)
tweets.in.collection(id.col.dsarticles)

1
2
3
7
9
12
13
14
15
19
22
23
pp[22]
must.articles <- c("722566794347589632","722111371362594816")
delete.articles <- c("722890699331346433","724542237430915077","724597255290925056","723967944426921985","722846456265060356","724481351701921792","722359900819570688","724360358941589508","722697270571986944","722757481106046976","722778791286870017")
index.delete.articles <- which(tweets.articles.red$id %in% delete.articles)
final.articles <- tweets.articles.red[-1*index.delete.articles,]
dim(final.articles)
length(final.articles$id)
length(unique(final.articles$id))
post.tweets(rev(unique(c(must.articles,final.articles$id))),id.col.dsarticles) 

###   Customized Articles   ###
#___________________________#
pp[[1]]
post.tweet("722566794347589632",id.col.custarticles)
