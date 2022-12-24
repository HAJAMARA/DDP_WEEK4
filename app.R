
library(shiny)
library(shinyalert)
library(bs4Dash)
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
library(BH)

launchApp <- function() {
  shinyApp(ui = ui, server = server)
}

