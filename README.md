## Data Science Cube:
### Potentialize your Data Science Knowledge and Skills

https://jpchamps.shinyapps.io/dscube_app/

- Keep up to date with the latest in data science events and articles, and find out who to follow to learn more, courtesy of Twitter  
- Wondering which industries want R or which ones want Excel? Wondering what language to concentrate on for machine learning or other skills? Find out from our database of Indeed.com job postings  
- Find a particular job posting you want to apply for but feel worried you won't make the cut? Paste the text of the job posting into our app and we'll suggest relevant books and free online courses to help you brush up on your skills.  

<p align = "center">
<img src = "https://github.com/TZstatsADS/finalproject-p5-team8/tree/master/figs/dscubefront.PNG" />
</p>

This app was created for Dr. Tian Zheng's Applied Data Science class at Columbia University, Spring 2016.  

Group Members: Ding Tianhong, Gu Xinghao, Juan Pablo Campos Gutierrez, Arnold Lau, Zhou Yi

Juan sifted through Twitter data to filter out and display relevant events, articles, and power users. Arnold scraped data science job postings from Indeed.com from April 18 to April 22, 2016 to obtain a database of over 2,000 job postings from New York, California, Texas, Washington, District of Columbia, Massachusetts, and other areas with a high number of data science jobs. Yi and Arnold created frequency and term correlation plots to analyze the sample of job postings. Tianhong and Xinghao created and manually tagged keywords from a database of books and online courses. These were used to define a set of final keywords we deemed to be prevalent in both job postings and resources. Xinghao created a system to recommend books and online courses given any data science job posting. Juan, Arnold, and Yi built the app interface using Shiny.
