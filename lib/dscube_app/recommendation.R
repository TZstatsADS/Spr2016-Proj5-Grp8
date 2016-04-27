###clean the text data
clean_text <- function(some_txt){
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
                   'pig','hive','zookeeper','deep','classify','bayes','gis',
                   'machine','survival','multilevel','mining','linear',
                   'visualization','predict','analytic','design','nlp','recommend',
                   'supervised','unsupervised','cluster','model','hierarchical','etl',
                   'vision')
build_matrix<-function(original_text){
  #fill the matrix we want to use
  original_text_cleaned<-clean_text(original_text)
  original_text_cleaned<-unlist(strsplit(original_text_cleaned,' '))
  original_text_cleaned<-gsub("\n", "", original_text_cleaned)
  post<-matrix(0,nrow=1,ncol=length(keywords_vector))
  for(i in 1:length(keywords_vector)){
    post[i]<-sum(keywords_vector[i] %in% original_text_cleaned)
  }
  return(post)
}




### build course recommendation system 
course_matrix<-read.csv('course_recommend.csv')
recommendation_course<-function(post){
  
  #matrix preparation
  post_matrix<-matrix(rep(post),nrow=dim(course_matrix)[1],
                      ncol=dim(course_matrix)[2]-2,byrow = TRUE)
  course_matrix_used<-course_matrix[,3:dim(course_matrix)[2]]
  course_matrix_used<-as.matrix(course_matrix_used)
  
  #give the first recommendation
  #calculate the matrix after substraction
  comparison_result<-post_matrix-course_matrix_used
  #let the negative factors be 0
  comparison_result[which(comparison_result[]==-1)]<-0
  #order the rows
  row_sum<-rowSums(comparison_result)
  row_order<-order(row_sum)
  
  #output 
  result<-list(course_name_1=as.character(course_matrix[row_order[1],1]),
               course_URL_1=as.character(course_matrix[row_order[1],2]),
               course_name_2=as.character(course_matrix[row_order[2],1]),
               course_URL_2=as.character(course_matrix[row_order[2],2]),
               course_name_3=as.character(course_matrix[row_order[3],1]),
               course_URL_3=as.character(course_matrix[row_order[3],2]),
               course_name_4=as.character(course_matrix[row_order[4],1]),
               course_URL_4=as.character(course_matrix[row_order[4],2]),
               course_name_5=as.character(course_matrix[row_order[5],1]),
               course_URL_5=as.character(course_matrix[row_order[5],2]))
  
  return(result)
}


### build book recommendation system 
book_matrix<-read.csv('book_recommend.csv')
recommendation_book<-function(post){
  
  #matrix preparation
  post_matrix<-matrix(rep(post),nrow=dim(book_matrix)[1],
                      ncol=dim(book_matrix)[2]-2,byrow = TRUE)
  book_matrix_used<-book_matrix[,3:dim(book_matrix)[2]]
  book_matrix_used<-as.matrix(book_matrix_used)
  
  #give the first recommendation
  #calculate the matrix after substraction
  comparison_result<-post_matrix-book_matrix_used
  #let the negative factors be 0
  comparison_result[which(comparison_result[]==-1)]<-0
  #order the rows
  row_sum<-rowSums(comparison_result)
  row_order<-order(row_sum)
  
  #output 
  result<-list(book_name_1=as.character(book_matrix[row_order[1],1]),
               book_URL_1=as.character(book_matrix[row_order[1],2]),
               book_name_2=as.character(book_matrix[row_order[2],1]),
               book_URL_2=as.character(book_matrix[row_order[2],2]),
               book_name_3=as.character(book_matrix[row_order[3],1]),
               book_URL_3=as.character(book_matrix[row_order[3],2]),
               book_name_4=as.character(book_matrix[row_order[4],1]),
               book_URL_4=as.character(book_matrix[row_order[4],2]),
               book_name_5=as.character(book_matrix[row_order[5],1]),
               book_URL_5=as.character(book_matrix[row_order[5],2]))
  
  return(result)
}
