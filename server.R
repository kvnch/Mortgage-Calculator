library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  moneyText = function(amount) {
    paste('$',sprintf('%1.2f', amount), sep='')
  }
  
  rateText = function(rate) {
    paste(sprintf('%1.3f', rate), '%', sep='')
  }
  
  schedule <- reactive({
    amortizationSchedule(input$loanAmount, input$interestRate,
                         input$payment)
  })

  output$schedule <- renderTable({ schedule() })
  output$payoffHistogram <- renderPlot({
    ggplot(schedule(), aes(x=period, y=endingPrincipalBalance)) +
      geom_bar(stat="identity") +
      labs(list(title = "Loan Remaining Balance over time",
                x = "Number of payment period", y = "Remaining Balance (Dollars)"))
  })
  
  amortizationSchedule = function(principal, rate, payment) {
    remainingLoanAmount = principal
    periodicInterestRate = rate/100/365*30
    period = 0
    schedule = data.frame()
    
    while(remainingLoanAmount > 0) {
      period = period + 1
      beginningPrincipalBalance = remainingLoanAmount
      interestPayment = round(periodicInterestRate * remainingLoanAmount, 2)
      
      validate(
        need(try(interestPayment < input$payment),
             "Monthly Payment is not large enough to pay for all accrued interest")
      )
      
      principalPayment = payment - interestPayment
      
      if(payment > interestPayment + beginningPrincipalBalance) {
        principalPayment = beginningPrincipalBalance
      }
      
      endingPrincipalBalance = beginningPrincipalBalance - principalPayment
      totalPayment = principalPayment + interestPayment
      schedule <- rbind(schedule,
                        data.frame(period = period,
                                   beginningPrincipalBalance = beginningPrincipalBalance,
                                   interestPayment = interestPayment,
                                   principalPayment = principalPayment,
                                   totalPayment = totalPayment,
                                   endingPrincipalBalance = endingPrincipalBalance))
      remainingLoanAmount = endingPrincipalBalance
    }
    
    schedule
  }
})
