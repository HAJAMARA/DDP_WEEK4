# runExample("01_hello")      # a histogram
# runExample("02_text")       # tables and data frames
# runExample("03_reactivity") # a reactive expression
# runExample("04_mpg")        # global variables
# runExample("05_sliders")    # slider bars
# runExample("06_tabsets")    # tabbed panels
# runExample("07_widgets")    # help text and submit buttons
# runExample("08_html")       # Shiny app built from HTML
# runExample("09_upload")     # file upload wizard
# runExample("10_download")   # file download wizard
# runExample("11_timer")      # an automated timer

assign(".lib.loc",
       "C:/Users/I0271961/OneDrive - Sanofi/Documents/FORMATION/SELF/Coursera_R_RShiny/_Coursera_Developing_Data_Products/Course_Project_HSA/SpecLim",
       envir = environment(.libPaths))

library(shiny)
library(shinyalert)
library(bs4Dash)
#library(shinydashboard)
library(shinyWidgets)
library(pastecs)
library(readxl)
library(DT)
library(plotly)
library(tidyverse)
library(dplyr)
library(reshape2)
library(ggplot2)
library(data.table)
library(tolerance)

launchApp <- function() {
  shinyApp(ui = ui, server = server)
}

