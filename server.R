#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

server <- function(input, output, session) {
  
  #### Load functions ---------------------------------------------------------------------------------------------------
  source("helpers/functions.R")
  # source("helpers/DatabaseLoading.R")
  # source("helpers/DescriptiveStat.R")
  # source("helpers/Histo.R")
  # source("helpers/NormalityTest.R")
  # source("helpers/TolInt.R")
  # source("helpers/Plots.R")
  
  #### LOAD DATABASE ----------------------------------------------------------------------------------------------------
  # Define a reactive variable to store the data from the uploaded file
  data <- reactive({
    # Use the require and readxl packages to read the uploaded file
    # require(readxl)
    require(openxlsx)
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    df <- read.xlsx(inFile$datapath)
    return(df)
  })

  # Output the content of the uploaded Excel file
  output$contents <- DT::renderDataTable({
    data()
  })

  # Selection of the parameters
  observeEvent(data(),{
    choices <- c(names(data()))
    updateSelectInput(session, inputId = 'Param', label = 'Parameter',
                      choices = names(select(data(), -Batch)), selected = names(select(data(), -Batch)))
  })
  
  Param <- eventReactive(input$run_button,input$Param)


  # Descriptive Statistics
  DescStatresults <- reactive({
    if (is.null(data()))
      return(NULL)
    resDescriptiveStat <- DescriptiveStat(select(data(), -Batch))
    return(resDescriptiveStat)
  })
  
  output$summary <-DT::renderDataTable({
    DescStatresults()
  })
  
  # d:reshaped data frame from original dataframe df
  d <- reactive({
    d <- reshape2::melt(data(), id.vars=c("Batch"))
    return(d)
  })
  # logd:log-transformed values of d
  logd <- reactive({
    logd <- mutate_if(d(), is.numeric, log)
    return(logd)
  })
  
  DF <- reactive({
    if(input$dist == "norm"){DF <- d()}
    else if(input$dist == "lnorm"){DF <- logd()} 
    else if(input$dist == "unk"){DF <- d()} 
  })
  
  # BoxPlots with outliers
  BoxPlot <- eventReactive(input$run_button,{
    Boxplot(DF()[DF()$variable == Param(),], Param())
  })
  
  output$BoxPlot <- renderPlotly({
    if (is.null(data())) {
      return()
    }
    BoxPlot()
    })

  # Histograms with density plot
  Histo <-  eventReactive(input$run_button,{
    Hist(DF()[DF()$variable == Param(),], Param())
  })
  
  output$Histo <- renderPlotly({
    if (is.null(data())) {
      return()
    }
    Histo()
  })
  
  # QQplot
  QQplot <- eventReactive(input$run_button,{
    Qqplot(DF()[DF()$variable == Param(),], Param())
  })
  
  output$QQplot <- renderPlotly({
    if (is.null(data())) {
      return()
    }
    QQplot()
  })
  
  # Shapiro-Wilk test
  Shapi <- eventReactive(input$run_button,{
    Shapiro(DF()[DF()$variable == Param(), ], Param)
  })
  
  output$Shapi <- DT::renderDataTable({
    if (is.null(data())) {
      return()
    }
    Shapi()
  })
  
  # Type of the limits (side)
  SIDE <- reactive({
    if(input$side == "int"){SIDE <- 2}
    else if(input$side == "low"){SIDE <-1} 
    else if(input$side == "upp"){SIDE <-1} 
  })
  
  # Number of the decimal of the spec. limits 
  NBDEC <- reactive({
    nbdec <- input$Dec
    return(nbdec)
  })
  
  # Specification limits & plots  in case of N >= 20 batches
  SPEC <- eventReactive(input$run_button,{
    
    if((input$dist == "unk") || (input$dist == "norm")){
      if(Shapi()$results[7] >= 0.01) {
        Tolint <- Tolinterval(DF()[DF()$variable == Param(), ]$value, 0.05, 0.95, SIDE(), Param(), NBDEC())
        if((input$side == "int")){
          ScatterPLim <- ScatterPlotLim2sided(DF()[DF()$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLim2sided(DF()[DF()$variable == Param(), ], Param(), Tolint)
        }
        else if((input$side == "upp")){
          Tolint$lower <- NULL
          Tolint$rlower <- NULL
          ScatterPLim <- ScatterPlotLimupper(DF()[DF()$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLimupper(DF()[DF()$variable == Param(), ], Param(), Tolint)
        }
        else if((input$side == "low")){
          Tolint$upper <- NULL
          Tolint$rupper <- NULL
          ScatterPLim <- ScatterPlotLimlower(DF()[DF()$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLimlower(DF()[DF()$variable == Param(), ], Param(), Tolint)
        }
      }
      else if(Shapi()$results[7] < 0.01){
        LOGDF <- mutate_if(DF(), is.numeric, log)
        shapi <- Shapiro(LOGDF[LOGDF$variable == Param(), ], Param())
        
        if(shapi$results[7] >= 0.01){
          Tolint <- LogTolinterval(LOGDF[LOGDF$variable == Param(), ]$value, 0.05, 0.95,  SIDE(), Param(), NBDEC())
          
          if((input$side == "int")){
            ScatterPLim <- ScatterPlotLim2sided(DF()[DF()$variable == Param(), ], Param(), Tolint)
            HistLim <- HistLim2sided(DF()[DF()$variable == Param(), ], Param(), Tolint)
          }
          else if((input$side == "upp")){
            Tolint$lower <- NULL
            Tolint$rlower <- NULL
            ScatterPLim <- ScatterPlotLimupper(DF()[DF()$variable == Param(), ], Param(), Tolint)
            HistLim <- HistLimupper(DF()[DF()$variable == Param(), ], Param(), Tolint)
          }
          else if((input$side == "low")){
            Tolint$upper <- NULL
            Tolint$rupper <- NULL
            ScatterPLim <- ScatterPlotLimlower(DF()[DF()$variable == Param(), ], Param(), Tolint())
            HistLim <- HistLimlower(DF()[DF()$variable == Param(), ], Param(), Tolint())
          } 
        }
        else if(shapi$results[7] < 0.01) {
          Tolint <- ParamCapalim(DF()[DF()$variable == Param(), ]$value, 0.05, 0.95,  SIDE(), Param(), NBDEC())
          
          if((input$side == "int")){
            ScatterPLim <- ScatterPlotLim2sided(DF()[DF()$variable == Param(), ], Param(), Tolint)
            HistLim <- HistLim2sided(DF()[DF()$variable == Param(), ], Param(), Tolint)
          }
          else if((input$side == "upp")){
            Tolint$lower <- NULL
            Tolint$rlower <- NULL
            ScatterPLim <- ScatterPlotLimupper(DF()[DF()$variable == Param(), ], Param(), Tolint)
            HistLim <- HistLimupper(DF()[DF()$variable == Param(), ], Param(), Tolint)
          }
          else if((input$side == "low")){
            Tolint$upper <- NULL
            Tolint$rupper <- NULL
            ScatterPLim <- ScatterPlotLimlower(DF()[DF()$variable == Param(), ], Param(), Tolint)
            HistLim <- HistLimlower(DF()[DF()$variable == Param(), ], Param(), Tolint)
          }
        }
      }
    }
    else if(input$dist == "lnorm"){
      
      if(Shapi()$results[7] >= 0.01) {
        Tolint <- LogTolinterval(DF()[DF()$variable == Param(), ]$value, 0.05, 0.95,  SIDE(), Param(), NBDEC())
        EXPDF <- mutate_if(DF(), is.numeric, exp)
        if((input$side == "int")){
          ScatterPLim <- ScatterPlotLim2sided(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLim2sided(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
        }
        else if((input$side == "upp")){
          Tolint$lower <- NULL
          Tolint$rlower <- NULL
          ScatterPLim <- ScatterPlotLimupper(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLimupper(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
        } 
        else if((input$side == "low")){
          Tolint$upper <- NULL
          Tolint$rupper <- NULL
          ScatterPLim <- ScatterPlotLimlower(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLimlower(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
        }
      }
      else if(shapi$results[7] < 0.01) {
        Tolint <- LogParamCapalim(DF()[DF()$variable == Param(), ]$value, 0.05, 0.95,  SIDE(), Param(), NBDEC())
        EXPDF <- mutate_if(DF(), is.numeric, exp)
        if((input$side == "int")){
          ScatterPLim <- ScatterPlotLim2sided(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLim2sided(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
        }
        else if((input$side == "upp")){
          Tolint$lower <- NULL
          Tolint$rlower <- NULL
          ScatterPLim <- ScatterPlotLimupper(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLimupper(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
        }
        else if((input$side == "low")){
          Tolint$upper <- NULL
          Tolint$rupper <- NULL
          ScatterPLim <- ScatterPlotLimlower(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
          HistLim <- HistLimlower(EXPDF[EXPDF$variable == Param(), ], Param(), Tolint)
        }
      }
    }

    return(list(lim=Tolint, scatter=ScatterPLim, histog=HistLim))
  })
  
  output$SPECLIM <- DT::renderDataTable({
    if (is.null(data())) {
      return()
    }
    SPEC()$lim
  })
  
  output$SPECSCATT <- renderPlotly({
    if (is.null(data())) {
      return()
    }
    SPEC()$scatter
  })
  
  output$SPECHIST <- renderPlotly({
    if (is.null(data())) {
      return()
    }
    SPEC()$histog
  })
 

}
