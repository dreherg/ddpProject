

## Create User Interface
ui <- fluidPage(

  tabsetPanel(
     
   ####################################
   
    tabPanel("Instructions",
             
             fluidRow(
               column(1),
               column(10,h3("Instructions for: Newport Half Marathon 2015 Results")),
               column(1)
             ),
             
             tags$br(),
                         
             fluidRow(
               column(1),
               column(10,h5("1. If you want to find information on your personal performance click on the search page")),
               column(1)
             ),
             
             fluidRow(
               column(2),
               column(9,helpText("If you didn't compete try these names Laura Carney or Kevin Burns ")),
               column(1)
             ),	
             
             tags$br(),
                         
             fluidRow(
               column(1),
               column(10,h5("2. If you want to compare yourself to others click on the compare page")),
               column(1)
             ),
             
             fluidRow(
               column(2),
               column(9,helpText("Using the results from the search page. You can compare your performance to all the runners or just males or females")),
               column(1)
             ),
             
             fluidRow(
               column(2),
               column(9,helpText("The graph will also show your percentile for the category you chose")),
               column(1)
             )
             
    ),
  
  ###############################
  
    tabPanel("Search",
             
             tags$br(),
             tags$br(),
             
             fluidRow(
               column(1),
               column(10,h4("Enter your full name , first name followed by last name.")),
               column(1)
             ),
             
		   fluidRow(
               column(2),
               column(9,helpText("Ignore error message when typing into textbox")),
               column(1)
             ),
             
             fluidRow(
               column(2),
               column(9,helpText("If you didn't compete try these names Laura Carney or Kevin Burns ")),
               column(1)
             ),	
		 
             fluidRow(
               column(1),
               column(4,textInput("yourname","", value = "Matt Dreher", width = NULL)),
               column(7)
             ),
             
             tags$br(),
             
             fluidRow(
               column(1),
               column (4,textOutput("yourname")),
               column(7)
             ),
             
             tags$br(),
        
             fluidRow(
               column(1),
               column (4,textOutput("yourplace")),
               column(7)
             ),
		 
		tags$br(),
		
		 fluidRow(
               column(1),
               column (7,textOutput("yourgradedtime")),
               column(4)
             ),
             
             tags$br(),
		 tags$br(),
		 
             fluidRow(
               column(2),
               column(9,helpText("* Basically, Age-Graded Scoring allows all individuals within a race to be scored against each other.")),
               column(1)
             ),
		 
		 fluidRow(
               column(2),
               column(9,helpText("That is done by first comparing the individual's finish time at that particular race distance to an ")),
               column(1)
             ),
		 
		  fluidRow(
               column(2),
               column(9,helpText("ideal or best time (not necessarily the world record) achievable for that individual's age and gender. ")),
               column(1)
             ),
		 
		 fluidRow(
               column(2),
               column(9,helpText("Age-Graded Scoring utilizes statistical tables to compare the performances of individual athletes ")),
               column(1)
             ),
		 
		 fluidRow(
               column(2),
               column(9,helpText("at different distances, between different events, or against other athletes of either gender ")),
               column(1)
             ),
		 
		 fluidRow(
               column(2),
               column(9,helpText("and/or of any age. ")),
               column(1)
             )
		 
    ),
    
#####################################  
  
    tabPanel("Compare",
             fluidRow(
               column(3),
               column(8,h3("Newport Half Marathon 2015")),
               column(1)
             ),
		 
             tags$br(),
             tags$br(),
		 
             fluidRow(
               column(1),
               column(4,sliderInput('mu', 'Look at your time in Minutes',value = 70, min = 65, max = 220, step = 1)),
               column(1),
               column(4,selectInput("dataset", "Choose a Category:", 
                                    choices = c("All Runners", "Male Runners", "Female Runners")))
             ),	
             
             fluidRow(
               column(2),
               column(8,plotOutput('newHist')),
               column(2)
             )		
     ) )    
)
