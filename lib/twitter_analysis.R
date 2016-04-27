# install.packages("tm")
# install.packages("stringr")
# install.packages("wordcloud")
# install.packages("sentiment")
library(streamR)
library(twitteR)
library(wordcloud)
library(tm)
library(stringr) # str_split_fixed
library(httr)  # function GET
library(Rstem,lib.loc = "/Users/JPC/Documents/R/Packages/Rstem")
# library(sentiment,lib.loc = "/Users/JPC/Documents/R/Packages")

### LOAD DATA
###____________________________________________________________________________________________

### Stream
stream.path <- "/Users/JPC/Documents/Columbia/2nd Semester/1. Applied Data Science/2. Homeworks/Project 5/stream_tweets/"
names.stream <- list.files(stream.path)
stream.data <- data.frame()
for (i in names.stream){
  stream.path.individual <- paste0(stream.path,i)
  temp.df <- parseTweets(stream.path.individual,simplify=FALSE)
  stream.data <- rbind(stream.data,temp.df)  
}
### Historic
load(file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward1.RData")
load(file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward2.RData")
load(file="/Users/JPC/Documents/Columbia/2nd Semester//1. Applied Data Science/2. Homeworks/Project 5/historic_tweets/forward3.RData")
b1 <- twListToDF(strip_retweets(tweets.f1))
b2 <- twListToDF(strip_retweets(tweets.f2))
b3 <- twListToDF(strip_retweets(tweets.f3))
historic.data <- rbind(test.df.f3,test.df.f2[2:nrow(test.df.f2),],test.df.f1[2:nrow(test.df.f1),])
historic.data.nort <- rbind(b3,b2[2:nrow(b2),],b1[2:nrow(b1),])
dim(historic.data.nort)

### CLEAN DATA
###____________________________________________________________________________________________

clean_tweets <- function(some_txt){
  # remove retweet entities
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
  # remove at people
  some_txt = gsub("@\\w+", "", some_txt)
  # remove punctuation
  some_txt = gsub("[[:punct:]]", "", some_txt)
  # remove numbers
  some_txt = gsub("[[:digit:]]", "", some_txt)
  # add an indicator for links
  link.ind=regexpr("http\\w+",some_txt)
  # remove html links
  some_txt = gsub("http\\w+", "", some_txt)
  # remove unnecessary spaces
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)

    # define "tolower error handling" function
  try.error = function(x)
  {
    # create missing value
    y = NA
    # tryCatch error
    try_error = tryCatch(tolower(x), error=function(e) e)
    # if not an error
    if (!inherits(try_error, "error"))
      y = tolower(x)
    # result
    return(y)
  }
  # lower case using try.error with sapply
  some_txt = sapply(some_txt, try.error)
  
  # remove NAs in some_txt
  #some_txt = some_txt[!is.na(some_txt)]
  names(some_txt) = NULL
  list(txt=some_txt,link.ind=link.ind)
}
extract.period <- function(x,period){sapply(x,function(x) substr(x,start = first.last(period)[1],stop = first.last(period)[2]))}
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

base <- historic.data.nort[!is.na(historic.data.nort$text),]
temp <- clean_tweets(base$text)
clean.text <- temp$txt
base$link <- ifelse(temp$link.ind==-1,0,1)
words <- str_split_fixed(clean.text," ",n=50)


# previous version
# base <- stream.data[!is.na(stream.data$text),]
# head(base[,1:4])
# # base <- tw.df[!is.na(tw.df$text),]
# clean.text <- clean_tweets(base$text)
# head(clean.text)
# words <- str_split_fixed(clean.text," ",n=50)
# 
# temp <- union(clean.text,clean.text[1])
# index.norep <- match(temp,clean.text)
# clean.text.no.rt <- clean.text[index.norep]
# words.no.rt <- str_split_fixed(clean.text.no.rt," ",n=50)

### WORDCLOUD
###____________________________________________________________________________________________

all.words <- as.vector(words[!words %in% c("datascience","data","science")])
wordcloud(words=all.words[1:10000],max.words=100)

all.words.no.rt <- as.vector(words.no.rt)
wordcloud(words=all.words.no.rt[1:10000],max.words=100)
head(words.no.rt)
head(all.words.no.rt)

all.words.no.rt.no.ds <- all.words.no.rt[!all.words.no.rt %in% c("datascience","data","science")]
wordcloud(words=all.words.no.rt.no.ds,max.words=100)
head(words.no.rt)
head(all.words.no.rt)

### EVENTS
###____________________________________________________________________________________________

today <-"2016-04-27" 
# Contain event words
words.event <-  c("event","events","attend")
index.events <- which(apply(words,1,function(x) sum(x %in% words.event))!=0)
# Delete duplicates
temp <- union(clean.text[index.events],clean.text[index.events][1])
index.events <- match(temp,clean.text)
# wordcloud(words[index.events],min.freq = 1)
# Delete the ones without links
tweets.events <-base[index.events,]
index.events <- index.events[tweets.events$link==1]
tweets.events <- base[index.events,]
# Delete expired
index.expired <-index.events[extract.period(tweets.events$created,"date")!=today & apply(words[index.events,],1, function(x) sum(x %in% c("today","tomorrow","tonights")))!=0]
index.events <-index.events[!(extract.period(tweets.events$created,"date")!=today & apply(words[index.events,],1, function(x) sum(x %in% c("today","tomorrow","tonights")))!=0)]
tweets.events <- base[index.events,]
# Delete tweets with unwanted words
words.unwanted <- c("berlin","athens")
index.events <- index.events[!apply(words[index.events,],1, function(x) sum(x %in% words.unwanted))!=0]
# Contain words data & science
index.events <- intersect(index.events,which(apply(words,1,function(x) sum(x %in% c("data","science")))==2))
base[index.events,]$text
base[index.events[14],]
tweets.events <- base[index.events,]
words.events <- words[index.events,]
extract.period(tweets.events$created,"day")

top.words <- c("python","hadoop","sql","minning","scala","hive","machine","optimization","predict","visualization","mining")
index.top.tweets.events <- apply(words.events,1, function(x) return(ifelse(sum(x %in% top.words)==0,FALSE,TRUE)))
tweets.events <- rbind(tweets.events[index.top.tweets.events,],tweets.events[!index.top.tweets.events,])
head(tweets.events$text)

# Show the best, include keywords

### ARTICLES
###____________________________________________________________________________________________

index.articles <- which(base$link==1)
# Contain words data & science
index.articles <- intersect(index.articles,which(apply(words,1,function(x) sum(x %in% c("data","science")))==2))
sum(words[index.articles[1],] %in% c("data","science"))==2
base$text[index.articles[1]]
tweets.articles <- base[index.articles,]
tweets.articles <- tweets.articles[order(tweets.articles$favoriteCount,decreasing = T),]
dim(tweets.articles)
tweets.articles.red <- head(tweets.articles,50)
words.articles <- head(words[index.articles,],50)

index.top.tweets.articles <- apply(words.articles,1, function(x) return(ifelse(sum(x %in% top.words)==0,FALSE,TRUE)))
tweets.articles.red <- rbind(tweets.articles.red[index.top.tweets.articles,],tweets.articles.red[!index.top.tweets.articles,])
head(tweets.articles.red$text)

head(tweets.articles$text,10)
head(base$text[index.articles])
tweets.articles[2,]
