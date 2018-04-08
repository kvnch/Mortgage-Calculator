library(shiny)

shinyUI(pageWithSidebar(

  headerPanel("Mortage Calculator"),
  mainPanel(
    tabsetPanel(
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
    
    sliderInput("payment",
                "Monthly Payment",
                min = 100,
                max = 800,
                value = 400,
                step= 25),
    
    sliderInput("interestRate",
                "Interest Rate",
                min = 0,
                max = 10,
                value = 3)
  )
  ))