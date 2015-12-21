
library(shiny)
library(dplyr)

#######################################################################################

toSeconds <- function(x){
  if (!is.character(x)) stop("x must be a character string of the form H:M:S")
  if (length(x)<=0)return(x)
  
  unlist(
    lapply(x,
           function(i){
             i <- as.numeric(strsplit(i,':',fixed=TRUE)[[1]])
             if (length(i) == 3) 
               i[1]*3600 + i[2]*60 + i[3]
             else if (length(i) == 2) 
               i[1]*60 + i[2]
             else if (length(i) == 1) 
               i[1]
           }  
    )  
  )  
}

secondsToString <- function(x,digits=2){
   unlist(
      lapply(x,
         function(i){
            # fractional seconds
            fs <- as.integer(round((i - round(i))*(10^digits)))
            fmt <- ''
            if (i >= 3600)
               fmt <- '%H:%M:%S'
            else if (i >= 60)
            fmt <- '%M:%S'
            else
               fmt <- '%OS'

            i <- format(as.POSIXct(strptime("0:0:0","%H:%M:%S")) + i, format=fmt)
            if (fs > 0)
               sub('[0]+$','',paste(i,fs,sep='.'))
            else
               i
         }
      )
   )
}


########################################################################################

## Read and organize data 
newporthalf <- read.csv(file="newporthalf.csv",head=TRUE,sep=",",stringsAsFactors=FALSE)
ageGradeTable <- read.csv(file="ageGradeTable.csv",head=TRUE,sep=",",stringsAsFactors=FALSE)

newporthalf <- mutate(newporthalf, Seconds = toSeconds(newporthalf$ChipTime))
newporthalf <- mutate(newporthalf, Minutes = Seconds/60)

## Create the three categories of runners
Males <- filter(newporthalf, Sex =="M")
Females <- filter(newporthalf, Sex =="F")
All <- newporthalf  

########################################################################################


## Create Server
server <- function(input, output){
  
  ## Monitor input for name search
  output$yourname <- renderText({
    name <- input$yourname
    index <- match(name, newporthalf$Name)
    time <- secondsToString(newporthalf$Seconds[index])
    #time <- round(newporthalf$Minutes[index],2)
    paste("Your chip time ", time ) })
  
  output$yourplace <- renderText({
    name <- input$yourname
    index <- match(name, newporthalf$Name)
    place <- newporthalf$Place[index]
    paste("You Placed ", place, "out of ", nrow(newporthalf), "runners" ) })
  
  output$yourgradedtime <- renderText({
    name <- input$yourname
    index <- match(name, newporthalf$Name)
    indexagt <- match(newporthalf$Age[index],ageGradeTable$Age)
    
    if (newporthalf$Sex[index] =='M')
       {
         agegradedtime <- round((newporthalf$Seconds[index] * ageGradeTable$AGFmale[indexagt]),2)
	   agegradedscore <- round(((3503 / agegradedtime ) *100),2)
	  }
    else
       {  
         agegradedtime <- round((newporthalf$Seconds[index] * ageGradeTable$AGFfemale[indexagt]),2)
         agegradedscore <- round(((3912 / agegradedtime ) *100),2)
       }
    
    paste("* Your Age Graded Time ", secondsToString(agegradedtime), "Your Age Graded Score ", agegradedscore,"%" )  })
  
   
  ## Monitor input for a change in requested category
  datasetInput <- reactive({
    switch(input$dataset,
           "All Runners" = All$Minutes,
           "Male Runners" = Males$Minutes,
           "Female Runners" = Females$Minutes)
  })
  
  ## Produce interactive plot 
     output$newHist <- renderPlot({
    ## Which category to plot    
    dataset <- datasetInput()
    ## Basic plot
    hist(dataset, xlab='Minutes',
         col='lightblue',
         breaks=50,
         xlim = c(50,250),
         main='')
	   
    ## Monitor input for change in slider and store minutes in mu
    mu <- input$mu  
    ## Calculate where a runner finished by percentile and print on plot
    percentile <- round(( 1 - pnorm(mu, mean= mean(dataset), sd=sd(dataset), lower.tail=F) ) *100, 1) 
    text(180, 80, paste("top = ", percentile,"%"), cex=2)			
    ## Create vertical red bar 
    lines(c(mu, mu), c(0, 200),col="red",lwd=5)
  })
}