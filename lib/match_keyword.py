"""
@author: Yi
It checks if some key words like "sql" appeared in every job posting.
The output is a matrix showing if the keyword appeared in each job posting.
"""
import csv


cols = ['X','title','senior','company','d3js','r','c','optimization','sampling',
        'stata','dashboard','spss','shell','linux','regression','dimension',
        'forecast','algorithm','nonparametric','sql','python','nosql',
        'postgresql','stan','ruby','scala','java','perl','shiny', 'php',
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
            #d3.js can not be a row name, so this is operated manually
            if raw.find('d3.js') == -1:
                row['d3js'] = 0
            else:
                row['d3js'] = 1
            #r is a single letter, so we match the key word r with other formats
            #which can be shown below:
            if raw.find(' r ') != -1 or raw.find(' r,') != -1 or raw.find(',r,') != -1 or raw.find(',r ') != -1:
                row['r'] = 1
            else:
                row['r'] = 0
            #c++ can not be a row name, so this is operated manually
            if raw.find('c++') == -1:
                row['c'] = 0
            else:
                row['c'] = 1
            #The rest key words are matched automatically.   
            for word in cols[7:]:
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
