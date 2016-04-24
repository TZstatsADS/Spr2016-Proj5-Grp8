"""
@author: Yi
This is a script that cleans the "post_text" column of the csv file.
"""
import csv
from nltk.tokenize import word_tokenize
import re
import string
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer


cols = ['X','title','company','location','days_ago','clean_text']
        

doc = {}
with open('combined.csv',encoding="utf-8",errors="surrogateescape") as csvinput:
    with open('clean_text.csv',"w",encoding="utf-8",errors="surrogateescape") as csvoutput:
        writer = csv.DictWriter(csvoutput, fieldnames=cols,extrasaction='ignore',lineterminator='\n')
        reader = csv.DictReader(csvinput) # read rows into a dictionary format
        writer.writeheader()
        for row in reader: # read a row as {column1:value1, column2:value2,...}
            raw = row['post_text'].lower()
            #Tokenizing text into bags of words
            tokenized_doc = word_tokenize(raw)
            #Removing punctuation
            regex = re.compile('[%s]' % re.escape(string.punctuation))
            tokenized_docs_no_punctuation = []
            for token in tokenized_doc:
                new_token = regex.sub(u'', token)
                if not new_token == u'':
                    tokenized_docs_no_punctuation.append(new_token)
            #Cleaning text of stopwords
            tokenized_docs_no_stopwords = []
            for word in tokenized_docs_no_punctuation:
                if not word in stopwords.words('english'):
                    tokenized_docs_no_stopwords.append(word)
            #Stemming and Lemmatizing
            porter = PorterStemmer()
            processed_doc = []
            for word in tokenized_docs_no_stopwords:
                processed_doc.append(porter.stem(word))
            #Create a string from the list of words
            text = ' '.join(processed_doc)
            row['clean_text'] = text
            writer.writerow(row)
            doc = {}
csvinput.close()
csvoutput.close()
