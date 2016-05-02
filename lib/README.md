# Library folder

The shiny app has three main components each displayed on a different tab: *Newsfeed*, *Job Market* and *Prepare for your interview*. It is located in the *dscube_app* folder; the *recommender* and *wordassociation* folders are preliminary apps that were used to build the *dscube_app*. This prototype was constructed based on different R and Python codes as described below.

### Newsfeed 
This tab provides the most recent and relevant information related to Data Science, based on tweets. It was born from the necessity of keeping up to date with the evolving methods and topics in Data Science. The most relevant information is summarised in this tab into 3 categories: *Events*, *Articles*, and *Tweetstars*. The following codes are used to create this tab: 

- **twitter_scrape.R** - The different available tools for collecting data from twitter were explored, but for the purpose of this app only data from the Search API is used. Only tweets in english, containing the hashtag #datascience or mentioning “data science” are collected. 
- **twitter_analysis.R** - The collected tweets are analysed and filtered using this R code. First retweets where deleted. Then the text of the remaining tweets is cleaned to obtain a vector of words for each tweet. The following lines describe in broad terms the criteria used to create a collection of tweets for each category:
    - **Events**
        - Contain words such as “event”, “events” and “attend”
        - Contain a link
        - Expired events are sought and deleted
        - Tweets containing top keywords from the *Job Market* analysis are displayed first.
    - **Articles**
        - Contain a link
        - Most liked articles (based on count of users that “favourited” the article) are displayed first.
        - Tweets containing top keywords from the *Job Market* analysis are displayed first.
    -  **Tweetstars**
        - Users are ranked based on average count of “favourited” 
        - Top 2 favourited users tweeting more than 20 tweets in the last 2 weeks are selected. 
        - Most recent tweets are displayed
- **twitter_collections.R** - The selected tweets for each category are displayed using twitter collections which are created with this code. 

### Job Market 
This tab provides graphical interactive tools for a deeper understanding of the Data Science job market, based on recent posts from Indeed.com. For this task, a set of relevant keywords for Data Science was defined based on the team’s personal knowledge and exploratory analysis of the posts. The keywords were grouped into three categories: *Technologies*, *Techniques* and *Industries*, and can be found in *data/keywords.txt*. The most frequent keywords in the posts and the correlation between keywords is displayed in this tab. The following codes were used to create this tab: 
 
- **indeed_scrape.py** - More than 2,000 job postings for “Data Scientists” from the more relevant cities in the United States where scraped using this function.
- **text_cleaning.py**: This script cleans the scrapped data's *post_text*, it’s output *clean_text.csv* can be found in the data folder.
- **match_keyword.py**: This script matches job description texts with keywords and creates a matrix populated with ones and zeros, where the rows contain posts and the columns are the keywords. Using this matrix, correlations between keywords (Pearson’s correlation for pairs of columns) were computed. It is also useful to assess whether the list of keywords covers all the job posts or more keywords should be found. The matrix can be found in *data/keymatrix.csv*. 
- **dscube_app/server.R** - A static plot showing the top mentioned keywords in job postings is created here. This also generates an interactive tool to compare the highest correlations between a particular keyword and a particular category (technologies, techniques, industries).

### Prepare for your interview 
A recommendation system was built to suggest ad hoc free courses and books given a particular job description. This method is based on the predefined Data Science keywords and on collections of books and courses that were gathered aiming to cover all the keywords. The collection of books can be found in *data/book_recommend.csv* and the collection of courses in *data/course_recommend.csv*. 

- **recommendation_new.R** -  This code is called inside the shiny app. It contains a function that receives as input a job description, it cleans the text and creates a vector of words. A vector of ones and zeros indicating wether the description contains each keyword is created. Then the distance between the vector of keywords of the job posting and the vector of keywords of the books is computed to identify the most related books to the job description. The same logic is followed to suggest courses.
