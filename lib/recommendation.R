###clean the text data
clean_text <- function(original_text){
  # remove punctuation
  some_txt = gsub("[[:punct:]]", "", some_txt)
  # remove unnecessary spaces
  some_txt = gsub("[ \t]{2,}", " ", some_txt)
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
  return(some_txt)
}


###build the keywords matrix
#define the keywords vector
keywords_vector<-c('d3js','r','c','stan','java',
                   'stata','dashboard','spss','shell','linux','regression','dimension',
                   'forecast','algorithm','nonparametric','sql','python','nosql',
                   'postgresql','ruby','scala','perl','shiny', 'php','sampling','optimization',
                   'html5','tableau','markdown','hadoop','mapreduce','sas','matlab',
                   'excel','ppt','spark','julia','aws','mongodb','javascript','hbase',
                   'pig','hive','zookeeper','deep learning','classify','bayes','gis',
                   'machine learning','survival','multilevel','data mining','linear',
                   'visualization','predict','analytic','design','nlp','recommend',
                   'supervised','unsupervised','cluster','model','hierarchical','etl',
                   'vision')
#fill the matrix we want to use
original_text_cleaned<-unlist(strsplit(original_text_cleaned,' '))
original_text_cleaned<-gsub("\n", "", original_text_cleaned)
post<-matrix(0,nrow=1,ncol=length(keywords_vector))
for(i in 1:length(keywords_vector)){
  post[i]<-sum(keywords_vector[i] %in% original_text_cleaned)
}




### build course recommendation system 
course_matrix<-read.csv('test.csv')
recommendation_course<-function(post){
  
  #matrix preparation
  post_matrix<-matrix(rep(post),nrow=dim(course_matrix)[1],
                      ncol=dim(course_matrix)[2]-2)
  course_matrix_used<-course_matrix[,3:dim(course_matrix)[2]]
  course_matrix_used<-as.matrix(course_matrix_used)
  course_matrix_used<-as.numeric(course_matrix_used)
  
  #give the first recommendation
  #calculate the matrix after substraction
  comparison_result<-post_matrix-course_matrix_used
  #let the negative factors be 0
  comparison_result[which(comparison_result[]<0)]<-0
  #select the most closed course
  row_select<-which.min(rowSums(comparison_result))
  temp<-comparison_result[row_select,]
  
  #give the second recommendation
  #matrix preparation
  post_matrix_2<-matrix(rep(temp),
                        nrow=dim(comparison_result)[1],
                        ncol=dim(comparison_result)[2])
  #calculate the matrix after substraction AGAIN
  comparison_result_2<-post_matrix_2-course_matrix_used
  comparison_result_2[which(comparison_result_2[]<0)]<-0
  row_select_2<-which.min(rowSums(comparison_result_2))
  
  #output 
  result<-list(course_name_1=course_matrix[row_select,1],
               course_URL_1=course_matrix[row_select,2],
               course_name_2=course_matrix[row_select_2,1],
               course_URL_2=course_matrix[row_select_2,2])
  return(result)
}
