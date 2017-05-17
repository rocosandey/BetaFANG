#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Beta calculation of FANG stocks versus NASDAQ Index"),
  
  h5("This tool allows you to calculate the sensitivity (Beta) of a single name stock price relatively to the NASDAQ Index."),
  h5("DEFINITION : Beta is a measure of the volatility, or systematic risk, of a security or a portfolio in comparison to the market as a whole.
A beta of 1 indicates that the security's price moves with the market. A beta of less than 1 means that the security is theoretically less volatile than the market. A beta of greater than 1 indicates that the security's price is theoretically more volatile than the market
."),
  h5("The Beta of a stock is obtained by linear regression with Retunrs of the stock as output and returns of the index as predictor (here NASDAQ) "),
  h5("USAGE: please start by picking a FANG stock name in the dropdown box. Select the time period you would like to analyze by using the date slider. The scatter plot will show the returns of the index (X axis) compared to the return of the selected stock (Y axis). The line is showing the result of the linear regression with Beta = slope and Alpha = Intercept"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        selectInput("stock", "Choose a stock:",
                    list(`Facebook` = 1,
                         `Amazon` = 2,
                         `Google` = 3,
                         `Netflix` = 4)),
    
        sliderInput("DateSlider",
                    "Dates:",
                    min = as.Date("2015-01-02","%Y-%m-%d"),
                    max = as.Date("2017-05-15","%Y-%m-%d"),
                    value=c(as.Date("2016-01-01"),as.Date("2017-05-15")),
                    timeFormat = "%Y-%m-%d"), width = 8),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("scatterplot"),
       h3("Beta vs NASDAQ: "),
       textOutput("beta")
    )
  )
))
