library(shiny)

shinyUI(pageWithSidebar(

  headerPanel("Mortage Calculator"),
  mainPanel(
    tabsetPanel(
      tabPanel("Summary",
               h3('Loan Settings'),
               fluidRow(
                 column(3,
                        h5('Loan Amount'),
                        textOutput("loanAmount")),
                 column(3,
                        h5('Interest Rate'),
                        textOutput("interestRate")),
                 column(3,
                        h5('Monthly Payment'),
                        textOutput("payment")))
      ),
      tabPanel("Plot",
               plotOutput("payoffHistogram"))
    )
  ),

  sidebarPanel(
    h2('Loan Settings'),
    sliderInput("loanAmount",
                "Loan Amount",
                min = 0,
                max = 50000,
                value = 10000),
    
    sliderInput("interestRate",
                "Interest Rate",
                min = 0,
                max = 10,
                value = 3),
    
    sliderInput("payment",
                "Monthly Payment",
                min = 100,
                max = 800,
                value = 400,
                step= 25)
  )
  ))