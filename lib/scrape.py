'''
This code is written in Python 3.5

ALREADY DONE:
- Can successfully scrape information from Indeed search results, including name of company, name of position, location, 
  whether or not the link is sponsored, a brief summary of the job posting, and the full text of the job posting

NOT YET DONE:
- Write a function to loop over all the results from a query to Indeed and scraoe them
*** Running the above function may take a long while and bugs are still likely ***
- Get the scraped data into a clean format, e.g. CSV
- Process the text data for analysis

'''

from selenium import webdriver # set up a web driver inside Python for any browser
from bs4 import BeautifulSoup # web scraping
import requests # get HTML
from time import sleep # delay requests
import re # regular expressions
import json

base_url = "http://www.indeed.com"

test_url = "http://www.indeed.com/jobs?q=data+scientist"

try:
    response = requests.get(test_url, timeout = 5)
except:
    print('That city/state combination did not have any jobs. Exiting . . .') # In case the city is invalid

rawhtml = response.content
soup = BeautifulSoup(rawhtml, "lxml") # Get the html from the first page

job_sections = soup.find_all("div", class_ = re.compile("row"))

# Create a list of job titles
titles = [job_sections[i].find_all("a")[0]['title'] for i in range(len(job_sections))]

# Create a list of URLs to the job posting
links = [base_url + job_sections[i].find_all("a")[0]['href'] for i in range(len(job_sections))]

# Create a list of locations
locations = [job_sections[i].find_all("span", "location")[0].get_text() for i in range(len(job_sections))]

# Create a list (True/False) if job posting is sponsored or not
is_sponsored = [job_sections[i].find_all("script")[0] for i in range(len(job_sections))]
is_sponsored = [json.loads(is_sponsored[i].contents[0][is_sponsored[i].contents[0].index("{"):-1])['sponsored'] for i in range(len(is_sponsored))]

# Create a list of company names
company_sections = [job_sections[i].find_all("span", class_ = "company")[0].contents for i in range(len(job_sections))]
companies = []
for c in company_sections:
    if len(c) == 1:
        companies.append(c[0].strip())
    else:
        companies.append(c[1].get_text().strip())

# Create a list of job posting summaries as seen on indeed.com       
summaries = [job_sections[i].find_all("span", class_ = "summary")[0].get_text().strip() for i in range(len(job_sections))]

test_jp_url = links[9]

response2 = requests.get(test_jp_url, timeout = 5)

class JobScraper(object):
    def __init__(self):
        self.driver = webdriver.PhantomJS()
        self.driver.set_window_size(1120, 550)
    
    def scrape(self):
        pass
    
        self.driver.quit()
        
if __name__ == '__main__':
    scraper = JobScraper()
    scraper.scrape()

phantomjs_driver = "C:/Users/Arnold/Downloads/Installers/phantomjs-2.1.1-windows/bin/phantomjs.exe"
testdrive = webdriver.PhantomJS(executable_path = phantomjs_driver)
rawhtml2 = response2.content
soup2 = BeautifulSoup(rawhtml2, "lxml")
soup2 = BeautifulSoup(testdrive.page_source, "lxml")

for script in soup2(["script", "style"]):
    script.extract() # Remove these two elements from the BS4 object

# View the website text line per line
text_strings = []
for string in soup2.stripped_strings:
    string.replace(u'\xa0', u' ')
    text_strings.append(repr(string))
    
# Or treat the text as a single string:
text = str(soup2.get_text(" ", strip = True))
text = text.replace(u'\xa0', u' ')





