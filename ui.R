## Shiny UI component for the Dashboard



dashboardPage(
  
  dashboardHeader(title="Exploring the WORLD HAPPINESS REPORT 0f 2022  with R & Shiny Dashboard", titleWidth = 650
                  
  ),
  
  
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
                menuItem("Dataset", tabName = "data", icon = icon("database")),
                menuItem("Visualization", tabName = "viz", icon=icon("chart-line")),
                
                # Conditional Panel for conditional widget appearance
                # Filter should appear only for the visualization menu and selected tabs within it
                conditionalPanel("input.sidebar == 'viz' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Select the Variable" , choices = c1)),
                conditionalPanel("input.sidebar == 'viz' && input.t2 == 'trends' ", selectInput(inputId = "var2" , label ="Select the Variable" , choices = c2)),
                conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var3" , label ="Select the X variable" , choices = c1, selected = "Happiness score")),
                conditionalPanel("input.sidebar == 'viz' && input.t2 == 'relation' ", selectInput(inputId = "var4" , label ="Select the Y variable" , choices = c1, selected = "Happiness score")),
                menuItem("Choropleth Map", tabName = "map", icon=icon("map"))
                
    )
  ),
  
  
  dashboardBody(
    style = "background-color: #F2F2F2;",
    
    tabItems(
      ## First tab item
      tabItem(tabName = "data", 
              tabBox(id="t1", width = 40, 
                     tabPanel("About", icon=icon("address-card"),
                              fluidRow(
                                column(
                                  width = 8,
                                  tags$a(
                                    href = "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQSHUlWmi_zhv_64CMT8rFDSRa-NVSAEm-znjARuKvOMjIuHS_C",
                                    target = "_self",
                                    tags$img(src = "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQSHUlWmi_zhv_64CMT8rFDSRa-NVSAEm-znjARuKvOMjIuHS_C", width = 600, height = 600),
                                    tags$br(),
                                    "Photo by Campbell Jensen on Unsplash"
                                  ),
                                  align = "center"
                                ),
                                column(width = 4,height=20, tags$br() ,
                                       tags$p("The World Happiness Record Dashboard is an interactive platform designed to provide users with insights into global happiness trends based on data from the World Happiness Report of the year 2022. The dashboard offers a user-friendly interface that allows individuals to explore and analyze happiness scores, factors influencing happiness, and regional variations.")
                                )
                              )
                              
                              
                     ), 
                     tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted"),style = "height: 9000px; width: 9000px;"),
                     tabPanel("Summary Stats", verbatimTextOutput("summary"), icon=icon("chart-pie"),style = "height: 9000px; width: 9000px;")
              )
              
      ),  
      
      # Second Tab Item
      tabItem(tabName = "viz", 
              tabBox(id="t2",  width=12, 
                     tabPanel("Happiness Trends by Countries", value="trends",
                              fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                       tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                                       
                              ),
                              withSpinner(plotlyOutput("bar",height = "600px"))
                     ),
                     tabPanel("Distribution", value="distro",
                              # selectInput("var", "Select the variable", choices=c("Rape", "Assault")),
                              withSpinner(plotlyOutput("histplot", height = "600px"))),
                     tabPanel("Correlation Matrix", id="corr" , withSpinner(plotlyOutput("cor",height = "600px"))),
                     tabPanel("Relationship among Variables", 
                              radioButtons(inputId ="fit" , label = "Select smooth method" , choices = c("loess", "lm"), selected = "lm" , inline = TRUE), 
                              withSpinner(plotlyOutput("scatter",height = "600px")), value="relation"),
                     side = "left"
              ),
              
      ),
      
      
      # Third Tab Item
      tabItem(
        tabName = "map",
        box(      selectInput("variable","Select Variable", choices = c2, selected="Happiness score", width = 250),
                  withSpinner(plotOutput("map_plot",height = "600px")), width = 12)
        
        
        
      )
      
    )
  )
)


