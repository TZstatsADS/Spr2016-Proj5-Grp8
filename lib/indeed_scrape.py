# -*- coding: utf-8 -*-
"""
Created on Sun Apr 17 12:15:11 2016

@author: Arnold

This code is written in Python 3.5

This is a script that scrapes information from indeed.com search results.
"""

from selenium import webdriver # set up a web driver inside Python for any browser
from bs4 import BeautifulSoup # web scraping
import requests # get HTML
from time import sleep, strftime # delay requests, get current date and time
import re # regular expressions
import json
import pandas as pd


phantomjs_driver = "C:/Users/Arnold/Downloads/Installers/phantomjs-2.1.1-windows/bin/phantomjs.exe"

def indeed(query, state_abbr, phantomjs_driver):
    '''
    Return metadata from job postings on indeed.com for a given query and state
    within the last 15 days from when the function is called.
    Note that if more than 1000 search results are returned, as might be the case
    for a state like California, this function will only give you the first 1000.
    
    Inputs:
    1.) query - type "str" - what you would put in a search box, e.g. "data scientist"
    2.) state_abbr - type "str" - state abbreviation. 50 states, DC and PR (Puerto Rico) are eligible
    3.) phantomjs_driver - type "str" - The path to phantomjs.exe on your machine. This is required for scraping job postings.
    Outputs:
    a pandas DataFrame containing:
        a.) Job titles
        b.) Company name
        c.) Location
        d.) Date posted (up to 15 days ago)
        e.) Summary of job posting text, as displayed by Indeed
        f.) URL to job posting
        g.) Raw text from the job posting itself
        h.) Date and time that the job postings were scraped
        i.) Number of postings reported by Indeed for the query-state combo
        NOTE THAT THIS WILL NOT BE THE SAME AS THE NUMBER OF POSTINGS RETRIEVED
    '''
    base_url = "http:/www.indeed.com"
    query_plus = "+".join(query.split())
    main_url = ("http://www.indeed.com/jobs?q=" + 
                query_plus +                
                "&l=" + state_abbr +
                "&radius=0&limit=100&fromage=15")
    try:
        response = requests.get(main_url, timeout = 5)
    except:
        return("Could not retrieve HTML")
    
    rawhtml = response.content
    soup = BeautifulSoup(rawhtml, "lxml")
    date_retrieved = strftime("%c")
    
    try:
        num_pages = int(soup.find_all("span", "pn")[-2].get_text())
    except IndexError:
        num_pages = 1
    job_numbers = re.findall('\d+', soup.find(id = "searchCount").get_text())
    if len(job_numbers) > 3: # Total number of jobs > 1000
        num_listings_in_state = (int(job_numbers[2])*1000) + int(job_numbers[3])
    else:
        num_listings_in_state = int(job_numbers[2])
    print(num_listings_in_state)
    
    # Note: this number includes duplicate listings removed from the search results
    
    master_list = []
    title = []
    company = []
    location = []
    days_ago = []
    summary = []
    post_url = []
    post_text = []     
    
    jobscraper = webdriver.PhantomJS(executable_path = phantomjs_driver, 
                                     service_args=['--ignore-ssl-errors=true', 
                                     '--ssl-protocol=any']) 
    jobscraper.set_script_timeout(30)
    jobscraper.set_page_load_timeout(30)
    
    count = 0
    
    for page in range(num_pages):
        print("Scraping page " + str(page + 1))
        
        page_url = main_url + "&start=" + str(page * 100)
        for attempt in range(10):
            try:
                response2 = requests.get(page_url, timeout = 5)
            except:
                continue
            break
        else:
            return("Failed 10 attempts to retrieve HTML")
            
        rawhtml2 = response2.content
        soup2 = BeautifulSoup(rawhtml2, "lxml")    
    
        job_sections = soup2.find_all("div", class_ = re.compile("row"))
        if len(job_sections) == 0:
            return("No results found.")
        
        titles = [job_sections[i].find_all("a")[0]['title'] for i in range(len(job_sections))]
        title.extend(titles)
        
        company_sections = []
        for i in range(len(job_sections)):
            try:
                company_sections.append(job_sections[i].find_all("span", class_ = "company")[0].contents)
            except:
                company_sections.append("No company name")        
        
        companies = []
        for c in company_sections:
            if len(c) == 1:
                companies.append(c[0].strip())
            elif c == "No company name":
                companies.append("No company name")
            else:
                companies.append(c[1].get_text().strip())
        company.extend(companies)
        
        locations = [job_sections[i].find_all("span", "location")[0].get_text() for i in range(len(job_sections))]
        location.extend(locations)
        
        days_ago_pp = [job_sections[i].find_all("span", "date")[0].get_text() for i in range(len(job_sections))]
        days_ago.extend(days_ago_pp)
        
        summaries = [job_sections[i].find_all("span", class_ = "summary")[0].get_text().strip() for i in range(len(job_sections))]
        summary.extend(summaries)
        
        post_urls = [base_url + job_sections[i].find_all("a")[0]['href'] for i in range(len(job_sections))]
        post_url.extend(post_urls)
        
        post_texts = []
        
        for url in post_urls:
            count += 1               
            print(count)
            print(url)
            try:
                jobscraper.get(url)
            except:
                post_texts.append("")
                continue

            soup3 = BeautifulSoup(jobscraper.page_source, "lxml")
            
            for script in soup3(["script", "style"]):
                script.extract()
            
            text = str(soup3.get_text(" ", strip = True))
            text = text.replace(u'\xa0', u' ')
            post_texts.append(text)
            
            sleep(1)
            
        post_text.extend(post_texts)
    
    master_list.extend([title, company, location, days_ago, summary,
                        post_url, post_text])
                        
    numrows = len(master_list[0])
    date_retrieved = [date_retrieved] * numrows
    num_listings_in_state = [num_listings_in_state] * numrows
    master_list.extend([date_retrieved, num_listings_in_state])
    
    master_list = pd.DataFrame(master_list).transpose()
    master_list.columns = ["title", "company", "location", "days_ago",
                           "summary", "post_url", "post_text", "date_retrieved",
                           "num_listings_in_state"]
    return(master_list)

filename = "C:/Users/Arnold/Dropbox/Columbia/2016 Spring/STAT W4249 Applied Data Science/finalproject-p5-team8/data/dc.csv"
dc.to_csv(filename)
    
        
        

        
    
                
                
                
    