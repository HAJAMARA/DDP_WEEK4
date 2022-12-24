##############################################################           #
#####   2022-Specification limits                        #####           #
##############################################################           #
#                                                                        #
# DDP COURSERA PROJECT                                                   #
#                                                                        #
# Date          Version         Authors           Comment                #
# 07-DEC-2022    Creation V1.0   HSA               Valid HSA             #
# File description                                                       #
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/                                           #
#                                                                        #
##########################################################################
#image = "SpecLim_Logo.png",



ui = dashboardPage(
  # title = "SpecLim Calculator",
  # fullscreen = TRUE,
  
  header = dashboardHeader(
    title = dashboardBrand(
      title = "SpecLim Calculator",
      color = "purple",
      image = "SpecLim_logo.png"
    ),
    
    skin = "dark",
    status = "purple",
    border = FALSE,
    sidebarIcon = icon("bars"),
    controlbarIcon = icon("th")
    #, actionButton("Example", "Example Dataset")
  ),
  
  sidebar = dashboardSidebar(
    expandOnHover = TRUE,
    width = 300,
    skin ="light",
    sidebarMenu(
      menuItem(
        "File upload",
        tabName = "Data",
        icon = icon("file-upload"),
        fileInput(
          inputId = "file1",
          label = "Upload your xlsx file:",
          accept = c(".xlsx")
        )
    ),
      menuItem(
        "Settings",
        tabName = "Setings",
        icon = icon("cogs"),
        
        selectInput("Param", "Select a parameter", choices = ""),
        
        # "A priori Distribution",
        # tabName = "Distributions",
        
        column(
          width = 12,
          align = "left",
          radioButtons(
            inputId = "dist",
            label = "Distribution type:",
            choices = c(
              "Normal" = "norm",
              "Log-normal" = "lnorm",
              "Unknown" = "unk"
            )
          )),
        
        column(
          width = 12,
          align = "left",
          radioButtons(
            inputId = "side",
            label = "Limits type:",
            choices = c(
              "2-sided" = "int",
              "Upper" = "upp",
              "Lower" = "low"
            )
          )),
        
        sliderInput(
          inputId = "Dec",
          label = "Specify the number of decimals of the spec. lim.",
          min = 0,
          max = 4,
          value = 2
        )
        
      ),
      
      br(),
      actionButton("run_button", "Run Analysis", icon = icon("play"))
      
    )),
    
    
    
    body = dashboardBody(
      
      tabName = "Data",
      
      tabsetPanel(
        
        tabPanel(
          # width = 12,
          title = strong("Raw Data"),
          id = "RawDescStat",
          closable = TRUE,
          height = "500px",
          
          "This tab displays the raw data of the uploaded file and the main descriptive statistics",
          
          fluidRow(
            width = 4,
            
            box(
              width = 12,
              title = "Raw data",
              dataTableOutput("contents") # Output: Data file
            ),
            box(
              width = 12,
              title = "Raw data Desc. Stat.",
              dataTableOutput("summary")
            )
          )
        ),
        
        tabPanel(
          title = "Parameter Desc. Plots",
          # column(4,
                 box(
                   width = NULL,
                   title = "Boxplot",
                   plotlyOutput("BoxPlot")
                 ),
                 box( 
                   width = NULL,
                   title = "Histogram",
                   plotlyOutput("Histo")
                 ),
                 box( 
                   width = NULL,
                   title = "QQplot",
                   plotlyOutput("QQplot")
                 ),
                 box( 
                   width = NULL,
                   title = "Shapiro-Wilk Test",
                   dataTableOutput("Shapi")
                 )
          # )
        ),
        
        tabPanel(
          title = "Specification Limits",
          
          box(
            width = NULL,
            title = "Specification Limits: Scatter Plot",
            plotlyOutput("SPECSCATT")
          ),
          box(
            width = NULL,
            title = "Specification Limits: Histogram",
            plotlyOutput("SPECHIST")
          ),
          box(
            width = NULL,
            title = "Specification Limits",
            # tableOutput("SPECLIM")
            DT::dataTableOutput("SPECLIM")
          )
        )
      )
    ),
    
    # controlbar = bs4DashControlbar(
    #   skin = "light",
    #   pinned = TRUE,
    #   collapsed = FALSE,
    #   overlay = FALSE,
    #   controlbarMenu(
    #     id = "controlbarmenu",
        # controlbarItem(title = "Data distribution",
        #                column(
        #                  width = 12,
        #                  align = "left",
        #                  radioButtons(
        #                    inputId = "dist",
        #                    label = "Distribution type:",
        #                    c(
        #                      "Normal" = "norm",
        #                      "Log-normal" = "lnorm",
        #                      "Unknown" = "unk"
        #                    )
        #                  )
        #                )),
    #     controlbarItem(
    #       title = "Spec Limits Precision",
    #       sliderInput(
    #         inputId = "Dec",
    #         label = "Specify the number of decimals of the spec. lim.",
    #         min = 0,
    #         max = 4,
    #         value = 2
    #       )
    #     )
    #   )
    # ),
    
  footer = dashboardFooter(
    left = a(
      href = "https://github.com/HAJAMARA/DDP_WEEK4",
      target = "_blank", "My github"
    ),
    right = "Author: HSA, DEC 2022")
    
  )
  