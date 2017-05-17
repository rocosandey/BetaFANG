#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
require(plotly)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    # read stock and index price from csv files
    FANG <- read.csv("FANG.csv")
    NDX <- read.csv("NDX.csv")
    
    # calculate returns
    n <- nrow(FANG)
    FANG_r <- (FANG[2:n,2:5]-FANG[1:n-1,2:5])/FANG[1:n-1,2:5]
    FANG_r$Date <- as.Date(FANG$Date[2:n],"%m/%d/%Y")
    NDX_r <- data.frame((NDX[2:n,2]-NDX[1:n-1,2])/NDX[1:n-1,2])
    NDX_r$Date <- as.Date(NDX$Date[2:n],"%m/%d/%Y")
    
    # select dates
    index_date <- reactive({
        with(NDX_r, (Date >= input$DateSlider[1] & Date <= input$DateSlider[2]))
    })
    
    # Fit linear regression to calculate Beta
    modFit <- reactive({
        idx <- index_date()
        lm(FANG_r[idx,as.numeric(input$stock)]~NDX_r[idx,1])
    })
    
    output$scatterplot <- renderPlotly({
        idx <- index_date()
        df <- data.frame(cbind(NDX_r[idx,1],FANG_r[idx,as.numeric(input$stock)]),row.names = NDX_r[idx,2])
        reg1 <- modFit()
        myY <- df$X1 * reg1$coefficients[[2]] + reg1$coefficients[[1]]
        p <- plot_ly() %>%
            add_markers(x=df$X1, y=df$X2, showlegend= FALSE) %>%
            add_lines(x = df$X1, y = myY, mode='line') %>%
            layout(xaxis = list(range = c(-0.06,0.06)), yaxis = list(range = c(-0.15,0.15)))
    })
    
    output$beta = renderText({
        regress <- modFit()
        regress$coefficients[[2]]})
  
})
