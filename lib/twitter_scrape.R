# install.packages("twitteR")
# install.packages("streamR")
# devtools::install_github("jrowen/twitteR", ref = "oauth_httr_1_0")
# install.packages("Rstem")


library(streamR)
library(twitteR)
library(ROAuth)
library(RCurl)
library(RJSONIO)
library(stringr)
library(httr)  # function GET

setwd("/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5")
### LOAD CREDENTIALS
###____________________________________________________________________________________________
load("/Users/JPC/Documents/R/twitter API/twitCred.RData")
load("/Users/JPC/Documents/R/twitter API/token.RData")
load("/Users/JPC/Documents/R/twitter API/twitCredentials.RData")
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

### UNDERSTANDING SEARCH API
###____________________________________________________________________________________________

# GET ID FROM GEOCODE
id <- GET("https://api.twitter.com/1.1/geo/reverse_geocode.json?lat=37.76893497&long=-122.42284884",config(token = twitter_token))
id <- content(id, as = "text")
id <- fromJSON(id)

# GET ID FROM COUNTRY NAME
geo <- GET("https://api.twitter.com/1.1/geo/search.json?query=Estados&granularity=country",config(token=twitter_token))
geo <- content(geo, as = "text")
geo <- fromJSON(geo)
country_id <- geo$result$places[[1]]$id

france.id <- "f3bfc7dcc928977f"
us.id <- "96683cc9126741d1"

# GET INFORMATION FROM PLACE USING ID
place <- GET("https://api.twitter.com/1.1/geo/id/f3bfc7dcc928977f.json",config(token=twitter_token))
place <- content(place, as = "text")
place <- fromJSON(place)
france.centroid <- place$centroid

# RETRIEVE TWEETS FROM A PARTICULAR PLACE
# Using get function for Mexico
test=GET("https://api.twitter.com/1.1/search/tweets.json?q=place%3A25530ba03b7d90c6&count=30",config(token = twitter_token))
test.df <- twListToDF(test)
test<- content(test, as = "text")
test <- fromJSON(test)
# the problem is that we cannot specify the tweets that we want to retrieve form that place 
# Using searchTwitter for France
tweets <- searchTwitter("place:f3bfc7dcc928977f",n=10)
tweets.df <- twListToDF(tweets)
# Let's try to add a word
tweets <- searchTwitter("place:f3bfc7dcc928977f+zika",n=10)
tweets.df <- twListToDF(tweets)
# Does not work

tweets <- searchTwitter("Obamacare OR ACA OR 'Affordable Care Act' OR #ACA", n=100, lang="en", since="2014-08-20")
tweets.df <- twListToDF(tweets)

tweets <- searchTwitter("#zika OR #zikavirus OR zika",n=10)

### two words
#retrieve id
geo <- GET("https://api.twitter.com/1.1/search/tweets.json?q=%23zika%20virus&count=10",config(token=twitter_token))
geo <- content(geo, as = "text")
geo <- fromJSON(geo)
country_id <- geo$result$places[[1]]$id

# zika and place
geo <- GET("https://api.twitter.com/1.1/search/tweets.json?q=%23zika%20place%3Af3bfc7dcc928977f&count=10",config(token=twitter_token))
geo <- content(geo, as = "text")
geo <- fromJSON(geo)
#zika place:f3bfc7dcc928977f

test=GET("https://api.twitter.com/1.1/search/tweets.json?q=&count=30",config(token = twitter_token))
test.df <- twListToDF(test)

### INITIAL TESTS
###____________________________________________________________________________________________

### NYC
#retrieve id
geo <- GET("https://api.twitter.com/1.1/geo/search.json?query=New%20York&contained_within=96683cc9126741d1&granularity=city",config(token=twitter_token))
geo <- content(geo, as = "text")
geo <- fromJSON(geo)
country_id <- geo$result$places[[1]]$id
nyc.id <- "b6c2e04f1673337f"

nyc.centroid <- geo$result$places[[19]]$contained_within[[1]]$centroid
nyc.box<- geo$result$places[[19]]$contained_within[[1]]$bounding_box

## get tweets 
geo.code <- paste0(paste0(france.centroid,collapse = ","),",10mi")
tweets3 <- searchTwitter("#zika OR #zikavirus OR zika",n=10,geocode=geo.code)

tweets3 <- searchTwitter("#zika OR #zikavirus OR zika",n=15,geocode="40.712784,-74.005941,100mi")
test.df <- twListToDF(tweets3)
nyc.manhattan <- '40.7361,-73.9901,5mi' # according to http://www.r-bloggers.com/getting-started-with-twitter-in-r/

tweets4 <- searchTwitter("'data science' OR #datascience OR 'Data Science'",n=17500)
test.df <- twListToDF(tweets4)
test.df
test.df.noretweet <- twListToDF(strip_retweets(tweets4))
head(test.df.noretweet$text,10)
nrow(test.df.noretweet)
# save(tweets4,test.df,file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/historic1.RData")
names(test.df)
test.df[1,]$favorited
day.hour.created <- test.df$created[1]
day.created <- substr(x,start = 1,stop = 10)

extract.day <- function(x){substr(x,start = 9,stop = 10)}
extract.month <- function(x){substr(x,start = 6,stop = 7)}
extract.year <- function(x){substr(x,start = 1,stop = 4)}
extract.time <- function(x){substr(x,start = 12,stop = 19)}
extract.hour <- function(x){substr(x,start = 12,stop = 13)}
extract.minutes <- function(x){substr(x,start = 15,stop = 16)}
extract.seconds <- function(x){substr(x,start = 18,stop = 19)}
day.v <- sapply(test.df$created,extract.day)
month.v <- sapply(test.df$created,extract.month)
year.v <- sapply(test.df$created,extract.year)
hour.v <- sapply(test.df$created,extract.hour)
minutes.v <- sapply(test.df$created,extract.minutes)
seconds.v <- sapply(test.df$created,extract.seconds)

first.last <- function(period){
  switch(period,
         date=c(1,10),
         day=c(9,10),
         month=c(6,7),
         year=c(1,4),
         time=c(12,9),
         hour=c(12,13),
         minutes=c(15,16),
         seconds=c(18,19)
  )
}
extract.period <- function(x,period){sapply(x,function(x) substr(x,start = first.last(period)[1],stop = first.last(period)[2]))}



table(year.v)
table(year.v)
table(month.v)
table(day.v)
table(hour.v)
table(minutes.v)
table(seconds.v)

head(test.df$text,20)
# tweet20 is very interesting "Accepting Applications: Associate Director, Data Science in New York, NY https://t.co/pe77Q2Z9si #job" 
# tweet 19 free online resources to learn more about data science and analysis. Is it spam?

sum(!is.na(test.df$latitude))
# only 47 had location

tweets5 <- searchTwitter("'data science' OR #datascience OR 'Data Science'",n=17900,lang = "en",geocode="40.712784,-74.005941,100mi")
test2.df <- twListToDF(tweets5)
test2.df 
test2.df$created

tweets6 <- searchTwitter("'data science' OR #datascience OR 'Data Science'",n=100,lang = "en",since = "2016-04-01",until = "2016-04-09")
test2.df <- twListToDF(tweets6)
head(test2.df)
dim(test2.df)
test2.df$created
# before the 8th of april there is no data. The conlcusion is that there are only 9 days of history.

getCurRateLimitInfo()

### RETRIEVING PAST TWEETS WITH SEARCH
###____________________________________________________________________________________________
max.id <- test.df$id[nrow(test.df)]
tweets.h2 <- searchTwitter("'data science' OR #datascience OR 'Data Science'",n=17800,maxID =max.id )
test.df.h2 <- twListToDF(tweets.h2)
# we reached the end
# save(tweets.h2,test.df.h2,file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/historic2.RData")

min.id <- test.df$id[1]
tweets.f1 <- searchTwitter("'data science' OR #datascience OR 'Data Science'",n=17800,sinceID = min.id)
test.df.f1 <- twListToDF(tweets.f1)
# save(tweets.f1,test.df.f1,file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward1.RData")
tail(test.df.h3)


# load(file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward1.RData")

min.id <- test.df.f1$id[1]
tweets.f2 <- searchTwitter("'data science' OR #datascience OR 'Data Science'",n=17900,sinceID = min.id)
test.df.f2 <- twListToDF(tweets.f2)
# save(tweets.f2,test.df.f2,file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward2.RData")

# load(file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward2.RData")

min.id <- test.df.f2$id[1]
tweets.f3 <- searchTwitter("'data science' OR #datascience OR 'Data Science'",n=17900,sinceID = min.id)
test.df.f3 <- twListToDF(tweets.f3)
# save(tweets.f3,test.df.f3,file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward3.RData")


ppp <- extract.period(x = test.df.f1$created,"day")
table(ppp)



getCurRateLimitInfo()


### STREAM
###____________________________________________________________________________________________

# tw.df <- data.frame()

total.min <- 60*7
alive.min <- 10
Sys.time()
end.date <- Sys.time()+60*total.min
end.date


## continue running until current date is end.date
while (Sys.time() < end.date){
  ## preparing file name so that it mentions time
  current.time <- format(Sys.time(), "%Y_%m_%d_%H_%M")
  json.file <- paste("/Users/JPC/Documents/Columbia/2nd Semester/1. Applied Data Science/2. Homeworks/Project 5/stream_tweets/datascience_tweets_", current.time, ".json", sep="")
  ## capture tweets about Scotland or #Indyref (Independence Referendum)
  
  filterStream(file.name = json.file, # 
               track = c('data science','#datascience','Data Science'), 
               language = "en",
               # location = c(-119, 33, -117, 35), # latitude/longitude pairs providing southwest and northeast corners of the bounding box.
               timeout = 60*alive.min, # Keep connection alive for 60 seconds
               oauth = twitCred) 
  # filterStream(file=json.file, track="scotland", oauth=my_oauth, timeout=5)
  if (file.info(json.file)$size > 0) {
    df <- parseTweets(json.file,simplify=FALSE)
    #Remove unknown locations
    # df <- df[complete.cases(df), ]
    #Bind all files
    tw.df <- as.data.frame(rbind(tw.df, df))
  } else {
    print ("no tweets found")
  }
  #   if (length(df$place_lon) >= 1) {
  #     #get icon
  #     shape = "http://maps.google.com/mapfiles/kml/pal2/icon18.png"
  #     #bloody timestap
  #     tw.df$time <- substr(tw.df$created_at, 12, 19)
  #     tw.df$time <- as.POSIXct(strptime(tw.df$time, "%H:%M:%S"))
  #     #Plot
  #     sp <- SpatialPoints(tw.df[,c("place_lon","place_lat")])
  #     proj4string(sp) <- CRS("+proj=longlat +datum=WGS84")
  #     df_st <- STIDF(sp, time = tw.df$time, data = tw.df[,c("name","retweet_count")])
  #     #Plot KML - opens Google Earth on loop[1] then updates for following
  #     plotKML(df_st, dtime = 24*3600, points_names=df$name, LabelScale = .4)
  #   } else {
  #     Sys.sleep(1)
  #     print("No geo-located tweets found, restart stream")
  #   }
}
