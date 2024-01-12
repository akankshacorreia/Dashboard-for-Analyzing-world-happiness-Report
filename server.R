## Shiny Server component for dashboard

function(input, output, session){
  
  # Data table Output
  output$dataT <- renderDataTable(my_data)
  
  
  # Rendering the box header  
  output$head1 <- renderText(
    paste("5 Countries with high rate of happiness record with respect to", input$var2 )
  )
  
  # Rendering the box header 
  output$head2 <- renderText(
    paste("5 Countries with low rate of happiness record with respect to", input$var2)
  )
  
  
  # Rendering table with 5 counties with high happiness rate wrt its variables
  output$top5 <- renderTable({
    
    my_data %>% 
      select(State, input$var2) %>% 
      arrange(desc(get(input$var2))) %>% 
      head(5)
    
  })
  
  # Rendering table with 5 countries with low happiness rate wrt its variables
  output$low5 <- renderTable({
    
    my_data %>% 
      select(State, input$var2) %>% 
      arrange(get(input$var2)) %>% 
      head(5)
    
    
  })
  
  
  # For Structure output
  output$structure <- renderPrint({
    my_data %>% 
      str()
  })
  
  
  # For Summary Output
  output$summary <- renderPrint({
    my_data %>% 
      summary()
  })
  
  # For histogram - distribution charts
  output$histplot <- renderPlotly({
    p1 = my_data %>% 
      plot_ly() %>% 
      add_histogram(x=~get(input$var1)) %>% 
      layout(xaxis = list(title = paste(input$var1)))
    
    
    p2 = my_data %>%
      plot_ly() %>%
      add_boxplot(x=~get(input$var1)) %>% 
      layout(yaxis = list(showticklabels = F))
    
    # stacking the plots on top of each other
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Distribution chart - Histogram and Boxplot",
             yaxis = list(title="Frequency"))
  })
  
  
  ### Bar Charts - Country wise trend
  output$bar <- renderPlotly({
    my_data %>% 
      plot_ly() %>% 
      add_bars(x=~State, y=~get(input$var2) , color = ~get(input$var2),  # Use the variable for color scaling
               colors = c("#3498db", "#2ecc71", "#e74c3c", "#f39c12","pink",'red','blue')
               
      ) %>% 
      
      layout(title = paste("COUNTRYWISE HAPPINESS REPORT for", input$var2),
             xaxis = list(title = "COUNTRY"),
             yaxis = list(title = paste("Frequency") ) )
  })
  
  
  ### Scatter Charts 
  output$scatter <- renderPlotly({
    p = my_data %>% 
      ggplot(aes(x=get(input$var3), y=get(input$var4)), color = colors) +
      geom_point() +
      geom_smooth(method=get(input$fit)) +
      labs(title = paste("Relation b/w", input$var3 , "and" , input$var4),
           x = input$var3,
           y = input$var4) +
      theme(  plot.title = element_textbox_simple(size=10,
                                                  halign=0.5))
    
    
    # applied ggplot to make it interactive
    ggplotly(p)
    
  })
  
  
  
  ## Correlation plot
  output$cor <- renderPlotly({
    library(readxl)
    retry <- read_excel("C:/Users/akank/Desktop/retry.xlsx")
    
    my_df1 <- retry %>% 
      select(-Country)
     
    
    # Compute a correlation matrix
    corr <- round(cor(my_df1), 1)
    
    # Compute a matrix of correlation p-values
    p.mat <- cor_pmat(my_df1)
    
    corr.plot <- ggcorrplot(
      corr,
      hc.order = TRUE, 
      lab= TRUE,
      outline.col = "white",
      p.mat = p.mat
    )
    
    ggplotly(corr.plot)
    
  })
  
  
  # Choropleth map
  output$map_plot <- renderPlot({
    new_join %>% 
      ggplot(aes(x=long, y=lat,fill=get(input$variable) , group = group)) +
      geom_polygon(color="black", size=0.9) +
      scale_fill_gradient(low="pink", high="red", name = paste(input$variable, "Rank")) +
      theme_void() +
      labs(title = paste("Choropleth map of", input$variable , "with respect to its Happiness Record ")) +
      theme(
        plot.title = element_textbox_simple(face="bold", 
                                            size=18,
                                            halign=0.5),
        
        legend.position = c(0.2, 0.1),
        legend.direction = "horizontal",
        legend.key.size = unit(4, "lines"),
        legend.title = element_text(size = 16),
        
      ) +
      geom_text(aes(x=x, y=y, label=abb), size = 0, color="blue")
      
    
    
    
  })
  
  
  
}



