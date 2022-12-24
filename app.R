
library(shiny)
library(shinyalert)
library(shinydashboard)
library(shinyWidgets)
library(bs4Dash)
library(pastecs)
library(readxl)
library(openxlsx)
library(DT)
library(plotly)
library(tidyverse)
library(dplyr)
library(reshape2)
library(ggplot2)
library(data.table)
library(tolerance)
library(BH)
launchApp <- function() {
  shinyApp(ui = ui, server = server)
}


