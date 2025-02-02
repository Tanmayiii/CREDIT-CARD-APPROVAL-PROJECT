library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(reticulate)
library(lubridate)

#define server input and output based on user input
server <- function(input, output) {
  # load python environment and machine learning model
  if (!Sys.info()[['sysname']] == 'shiny'){
    reticulate::virtualenv_create(envname = 'python35_env')
    reticulate::virtualenv_install('python35_env', packages = c('joblib', 'pandas','xgboost','scikit-learn'))
  } 
  reticulate::use_virtualenv("python35_env", required =  TRUE)
  #pd <- import("pandas")
  #import("xgboost")
  model <- import("joblib")$load("xgb_jl.joblib")
  # preprocess function for Age, Income, Employement Length
  input_skew <- function(input_value, min_value, max_value) {
    x_skewed <- input_value^(1/3)
      if (x_skewed < min_value) {
        x_skewed <- min_value
      } else if (x_skewed > max_value) {
        x_skewed <- max_value
      }
      return(x_skewed)
  }

  input_scale <- function(input_value, min_value, max_value) {
    x_scaled <- (input_value - min_value) / (max_value - min_value)
      if (x_scaled < 0) {
        x_scaled <- 0
      } else if (x_scaled > 1) {
        x_scaled <- 1
      }
      return(x_scaled)
  }
  
  # convert the input to relevant formats for model process
  status <- eventReactive(input$cal, {
    if(input$Own_email == "Y"){
      Own_email_Y <- 1
      Own_email_N <- 0
    } else {
      Own_email_Y <- 0
      Own_email_N <- 1
    }
    if(input$Own_phone == "Y"){
      Own_phone_Y <- 1
      Own_phone_N <- 0
    } else {
      Own_phone_Y <- 0
      Own_phone_N <- 1
    }
    if(input$Own_work_phone == "Y"){
      Own_work_phone_Y <- 1
      Own_work_phone_N <- 0
    } else {
      Own_work_phone_Y <- 0
      Own_work_phone_N <- 1
    }
    if(input$Gender == "M"){
      Gender_M <- 1
      Gender_F <- 0
    } else {
      Gender_M <- 0
      Gender_F <- 1
    }
    if(input$Own_car == "Y"){
      Own_car_Y <- 1
      Own_car_N <- 0
    } else {
      Own_car_Y <- 0
      Own_car_N <- 1
    }
    if(input$Own_property == "Y"){
      Own_property_Y <- 1
      Own_property_N <- 0
    } else {
      Own_property_Y <- 0
      Own_property_N <- 1
    }
    if(input$Employment_status == "Commercial associate"){
      Employment_status_Commercial_associate <- 1
      Employment_status_Pensioner <- 0
      Employment_status_State_servant <- 0
      Employment_status_Student <- 0
      Employment_status_Working <- 0
    } else if(input$Employment_status == "Pensioner") {
      Employment_status_Commercial_associate <- 0
      Employment_status_Pensioner <- 1
      Employment_status_State_servant <- 0
      Employment_status_Student <- 0
      Employment_status_Working <- 0
    } else if(input$Employment_status == "State_servant") {
      Employment_status_Commercial_associate <- 0
      Employment_status_Pensioner <- 0
      Employment_status_State_servant <-1
      Employment_status_Student <- 0
      Employment_status_Working <- 0
    } else if(input$Employment_status == "Student") {
      Employment_status_Commercial_associate <- 0
      Employment_status_Pensioner <- 0
      Employment_status_State_servant <-0
      Employment_status_Student <- 1
      Employment_status_Working <- 0
    } else {
      Employment_status_Commercial_associate <- 0
      Employment_status_Pensioner <- 0
      Employment_status_State_servant <-0
      Employment_status_Student <- 0
      Employment_status_Working <- 1
    } 
    if(input$Dwelling == "Co-op apartment"){
      Dwelling_Co_op_apartment <- 1
      Dwelling_House_apartment <- 0
      Dwelling_Municipal_apartment <- 0
      Dwelling_Office_apartment <- 0
      Dwelling_Rented_apartment <- 0
      Dwelling_With_parents <- 0
    } else if(input$Dwelling == "House / apartment"){
      Dwelling_Co_op_apartment <- 0
      Dwelling_House_apartment <- 1
      Dwelling_Municipal_apartment <- 0
      Dwelling_Office_apartment <- 0
      Dwelling_Rented_apartment <- 0
      Dwelling_With_parents <- 0
    } else if(input$Dwelling == "Municipal apartment"){
      Dwelling_Co_op_apartment <- 0
      Dwelling_House_apartment <- 0
      Dwelling_Municipal_apartment <- 1
      Dwelling_Office_apartment <- 0
      Dwelling_Rented_apartment <- 0
      Dwelling_With_parents <- 0
    } else if(input$Dwelling == "Office apartment"){
      Dwelling_Co_op_apartment <- 0
      Dwelling_House_apartment <- 0
      Dwelling_Municipal_apartment <- 0
      Dwelling_Office_apartment <- 1
      Dwelling_Rented_apartment <- 0
      Dwelling_With_parents <- 0
    } else if(input$Dwelling == "Rented apartment"){
      Dwelling_Co_op_apartment <- 0
      Dwelling_House_apartment <- 0
      Dwelling_Municipal_apartment <- 0
      Dwelling_Office_apartment <- 0
      Dwelling_Rented_apartment <- 1
      Dwelling_With_parents <- 0
    } else {
      Dwelling_Co_op_apartment <- 0
      Dwelling_House_apartment <- 0
      Dwelling_Municipal_apartment <- 0
      Dwelling_Office_apartment <- 0
      Dwelling_Rented_apartment <- 0
      Dwelling_With_parents <- 1
    }
    if(input$Marital_status == "Civil marriage"){
      Marital_status_Civil_marriage <- 1
      Marital_status_Married <- 0
      Marital_status_Separated <- 0
      Marital_status_Single_not_married <- 0
      Marital_status_Widow <- 0
    } else if(input$Marital_status == "Married"){
      Marital_status_Civil_marriage <- 0
      Marital_status_Married <- 1
      Marital_status_Separated <- 0
      Marital_status_Single_not_married <- 0
      Marital_status_Widow <- 0
    } else if(input$Marital_status == "Separated"){
      Marital_status_Civil_marriage <- 0
      Marital_status_Married <- 0
      Marital_status_Separated <- 1
      Marital_status_Single_not_married <- 0
      Marital_status_Widow <- 0
    } else if(input$Marital_status == "Single / not married"){
      Marital_status_Civil_marriage <- 0
      Marital_status_Married <- 0
      Marital_status_Separated <- 0
      Marital_status_Single_not_married <- 1
      Marital_status_Widow <- 0
    } else {
      Marital_status_Civil_marriage <- 0
      Marital_status_Married <- 0
      Marital_status_Separated <- 0
      Marital_status_Single_not_married <- 0
      Marital_status_Widow <- 1
    }
    if(input$Education_level == "Academic degree"){
      Education_level <- 1
    } else if(input$Education_level == "Higher education"){
      Education_level <- 2
    } else if(input$Education_level == "Incomplete higher"){
      Education_level <- 3
    } else {
      Education_level <- 4
    }
    age1 <- input_skew((abs(as.numeric(input$Age-today()))/365), 2.7376441032733023, 4.061215908230528)
    Age <- input_scale(age1, 2.7376441032733023, 4.061215908230528)
    Employment_length <- input_scale(abs(as.numeric(input$Employment_length - today())/365),0.04657534246575343,19.73972602739726)
    income1 <- input_skew(as.numeric(input$Income),30.0,72.30426792525691)
    Income <- input_scale(income1, 30.0, 72.30426792525691)
    Family_member_count <- as.numeric(input$Family_member_count)
    input_data <- data.frame(Own_email_N,Own_email_Y,Own_phone_N,Own_phone_Y,Own_work_phone_N,Own_work_phone_Y,Own_property_N, Own_property_Y, Own_car_N, Own_car_Y,Employment_status_Commercial_associate,Employment_status_Pensioner,
                             Employment_status_State_servant,Employment_status_Student,Employment_status_Working,Dwelling_Co_op_apartment,Dwelling_House_apartment,Dwelling_Municipal_apartment,Dwelling_Office_apartment,
                             Dwelling_Rented_apartment,Dwelling_With_parents,Marital_status_Civil_marriage,Marital_status_Married,Marital_status_Separated,Marital_status_Single_not_married  ,Marital_status_Widow, Gender_F,Gender_M,Income,Education_level,Age,Employment_length,Family_member_count)
    status <- model$predict(input_data)
    
    return(status)
  })
  
  # Print model output
  output$value <- renderPrint({
    if(status() == 0){
      print("Approved") 
    } else {
      print("Not Approved")
    }
    
  })
}

#define ui content
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

#Dashboard header carrying the title of the dashboard
header <- dashboardHeader(title = "Credit Card Approval App",titleWidth = 300)  
#Sidebar content of the dashboard
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),  
    menuItem("Prediction", tabName = "pred", icon = icon("search"))))
#Body content of the dashboard
body<-dashboardBody(tabItems(
                    tabItem('home',
                            #Background of our project
                            strong("a. Project Background:"),
                            p("When providing a credit card to a customer, banks had to rely on the applicant’s background and the history to understand the creditworthiness of the applicant. 
The process includes scrutinisation of application data with reference documents and this process was not always accurate and the bank had 
to face difficulties in approving the credit card. This application aims to help banking and financial institutions to identify and approve the creditworthy customers 
by using predictive models."),strong("b. Project Objectives:"),
                            tags$ul(
                              tags$li("To propose an effective and high prediction accuracy credit card application approval prediction model with implementation of different machine learning algorithms."),
                              tags$li("To identify the key features related to the approval of a credit card application."),
                              tags$li("To deploy the proposed prediction model with highest prediction accuracy measured with implementation of web-based application."))),
                    tabItem('pred',
                            #Filters for categorical variables
                            box(title = 'Categorical variables', 
                                status = 'primary', width = 12, 
                                splitLayout(
                                  tags$head(tags$style(HTML(".shiny-split-layout > div {overflow: visible;}"))),
                                  cellWidths = c('0%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%', '7%'),
                                  selectInput( 'Gender', 'Gender', c("M", "F")),
                                  div(),
                                  selectInput('Own_car', 'Own Car', c("Y", "N")),
                                  div(),
                                  selectInput('Own_property', 'Own Property', c("Y", "N")),
                                  div(),
                                  selectInput('Own_work_phone', 'Own Workphone', c("Y", "N")),
                                  div(),
                                  selectInput('Own_phone', 'Own Phone', c("Y", "N")),
                                  div(),
                                  selectInput('Own_email', 'Own Email', c("Y", "N")),
                                  div()),
                                br(),
                                splitLayout(
                                  tags$head(tags$style(HTML(".shiny-split-layout > div {overflow: visible;}"))),
                                  cellWidths = c('0%', '20%', '5%', '25%','5%', '17%','5%', '20%', '5%'),
                                  selectInput('Employment_status', 'Income Category', c("Working", 
                                              "Commercial associate", "Pensioner", "State servant","Student")),
                                  div(),
                                  selectInput('Education_level', 'Education Category', c("Academic degree", "Higher education", 
                                              "Incomplete higher", "Lower secondary","Secondary / secondary special")),
                                  div(),
                                  selectInput('Marital_status', 'Marital Status', c("Married", "Civil marriage", 
                                              "Separated", "Widow","Single / not married")),
                                  div(),
                                  selectInput('Dwelling', 'Accomodation', c("Co-op apartment", "House / apartment", 
                                                                                        "Municipal apartment", "Office apartment","Rented apartment", "With parents")))),
                            #Filters for numeric variables
                            box(title = 'Numerical variables',
                                status = 'primary', width = 12,
                                splitLayout(cellWidths = c('15%', '8%', '10%', '10%','15%', '8%'),
                                            numericInput( 'Income', 'Annual Income', 0),
                                            div(),
                                            numericInput( 'Family_member_count', 'Number of Family Member', 0),
                                            div(),
                                            dateInput("Age", "Birthday:", "1990-01-01", format = "yyyy-mm-dd", startview = "year"),
                                            div(),
                                            dateInput("Employment_length", "Employment:", "1990-01-01", format = "yyyy-mm-dd", startview = "year")),
                            br(),
                            #Box to display the prediction results
                            box(title = 'Prediction result',
                                status = 'success', 
                                solidHeader = TRUE, 
                                width = 20, height = 50,
                                div(h5('Application Status:')),
                                verbatimTextOutput("value", placeholder = TRUE),
                                actionButton('cal','Calculate', icon = icon('calculator')))))))
                            #Box to display information about the model

#completing the ui part with dashboardPage
ui <- dashboardPage(title = 'Credit Card Approval App', header, sidebar, body, skin='red')

#run/call the shiny app
shinyApp(ui, server)
