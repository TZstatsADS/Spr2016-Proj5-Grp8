

# Post a collection for events:

col.dsevents <- POST("https://api.twitter.com/1.1/collections/create.json?name=DSEvents",config(token=twitter_token))
pp <- content(col.dsevents, as = "text")
pp <- fromJSON(pp)
id.col.dsevents <- pp$response

# Add tweets to the list:

tweet.id <- tweets.events$id[1]
post.tweet <- POST(paste0("https://api.twitter.com/1.1/collections/entries/add.json?tweet_id=",tweet.id,"&id=",id.col.dsevents),config(token=twitter_token))
pp <- content(post.tweet, as = "text")
pp <- fromJSON(pp)

