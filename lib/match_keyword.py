"""
@author: Yi
It checks if some key words like "sql" appeared in every job posting.
The output is a matrix showing if the keyword appeared in each job posting.
"""
import csv


cols = ['X','title','senior','company','d3js','r','c','stan','java',
        'stata','dashboard','spss','shell','linux','regression','dimension',
        'forecast','algorithm','nonparametric','sql','python','nosql',
        'postgresql','ruby','scala','perl','shiny', 'php','sampling','optimization',
        'html5','tableau','markdown','hadoop','mapreduce','sas','matlab',
        'excel','ppt','spark','julia','aws','mongodb','javascript','hbase',
        'pig','hive','zookeeper','deep learning','classify','bayes','gis',
        'machine learning','survival','multilevel','data mining','linear',
        'visualization','predict','analytic','design','nlp','recommend',
        'supervised','unsupervised','cluster','model','hierarchical','etl',
        'vision']


doc = {}
with open('combined.csv',encoding="utf-8",errors="surrogateescape") as csvinput:
    with open('keymatrix.csv',"w",encoding="utf-8",errors="surrogateescape") as csvoutput:
        writer = csv.DictWriter(csvoutput, fieldnames=cols,extrasaction='ignore',lineterminator='\n')
        reader = csv.DictReader(csvinput) # read rows into a dictionary format
        writer.writeheader()
        for row in reader: # read a row as {column1:value1, column2:value2,...}
            '''We find the key words in the job description text.'''
            raw = row['post_text'].lower()
            #d3.js can have multiple terms, so this is operated manually
            if raw.find('d3.js') != -1 or raw.find('d3js') != -1 :
                row['d3js'] = 1
            else:
                row['d3js'] = 0
            #java is included in javascript
            if raw.find(' java ') != -1 or raw.find(' java,') != -1 or raw.find(',java,') != -1 or raw.find(',java ') != -1:
                row['java'] = 1
            else:
                row['java'] = 0
            #sql is included in nosql
            if raw.find(' sql ') != -1 or raw.find(' sql,') != -1 or raw.find(',sql,') != -1 or raw.find(',sql ') != -1:
                row['sql'] = 1
            else:
                row['sql'] = 0
            #r is a single letter, so we match the key word r with other formats
            #which can be shown below:
            if raw.find(' r ') != -1 or raw.find(' r,') != -1 or raw.find(',r,') != -1 or raw.find(',r ') != -1:
                row['r'] = 1
            else:
                row['r'] = 0
            #stan can be confused with standard, so we match the key word r with other formats
            #which can be shown below:
            if raw.find(' stan ') != -1 or raw.find(' stan,') != -1 or raw.find(',stan,') != -1 or raw.find(',stan ') != -1:
                row['stan'] = 1
            else:
                row['stan'] = 0
            #c++ can not be a row name, so this is operated manually
            if raw.find('c++') == -1:
                row['c'] = 0
            else:
                row['c'] = 1
            #The rest key words are matched automatically.   
            for word in cols[9:]:
                if raw.find(word) == -1:
                    row[word] = 0
                else:
                    row[word] = 1
            '''Search the title to see if it's a senior position'''
            title = row['title'].lower()
            if title.find('principal') != -1 or title.find('senior') != -1 or title.find('manager') != -1 or title.find('lead') != -1:
                row['senior'] = 1
            else:
                row['senior'] = 0
                
            writer.writerow(row)
            doc = {}
csvinput.close()
csvoutput.close()
