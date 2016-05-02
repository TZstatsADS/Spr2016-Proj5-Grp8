## Data Science Cube:
### Potentialize your Data Science Knowledge and Skills

https://jpchamps.shinyapps.io/dscube_app/

- Keep up to date with the latest in data science events and articles, and find out who to follow to learn more, courtesy of Twitter  
- Wondering which industries want R or which ones want Excel? Wondering what language to concentrate on for machine learning or other skills? Find out from our database of Indeed.com job postings. (Note: This takes a while to load, please be patient.)  
- Find a particular job posting you want to apply for but feel worried you won't make the cut? Paste the text of the job posting into our app and we'll suggest relevant books and free online courses to help you brush up on your skills.  

![screenshot](/figs/dscubefront.PNG)
![screenshot](/figs/dscubenewsfeed.PNG)
![screenshot](/figs/dscubejobmarket.PNG)
![screenshot](/figs/dscuberecomm.PNG)

This app is a prototype that was created for Dr. Tian Zheng's Applied Data Science class at Columbia University, Spring 2016. For detail about how the app was created, please refer to the Readme.md file in the lib folder.  

Group Members: Ding Tianhong, Gu Xinghao, Juan Pablo Campos Gutierrez, Arnold Lau, Zhou Yi

Contributions: 

Juan, Arnold and Yi defined the scope of the application. Juan sifted through 30,503 tweets mentioning “Data Science” to filter out and create a newsfeed to display the most relevant events, articles, and power users. With the objective of analysing the data science job market, Arnold scraped data science job postings from Indeed.com from April 18 to April 22, 2016 to obtain a database of over 2,000 job postings from New York, California, Texas, Washington, District of Columbia, Massachusetts, and other areas with a high number of data science jobs. Yi and Arnold summarized the data by creating frequency and term correlation plots. Arnold, Juan and Xinhao defined a method for creating a recommendation system that suggests courses and books based on a job description. Tianhong and Xinghao created and manually tagged keywords from a database of books and online courses. These were used to define a set of final keywords which were prevalent in both job postings and resources and therefore were used to do the matching. Xinghao implemented the recommendation system in R. Juan, designed the shiny app, Arnold and Yi supported building the tabs. 
