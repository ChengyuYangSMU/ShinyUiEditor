library(shiny)
library(plotly)
library(DT)
library(gridlayout)

ui <- grid_page(
  layout = c(
    "header header header",
    "sidebar plot1 plot2",
    "sidebar table table"
  ),
  row_sizes = c("80px", "1fr", "1fr"),
  col_sizes = c("250px", "1fr", "1fr"),
  gap_size = "1rem",
  
  grid_card_text(area = "header", content = "Faithful Geyser Explorer", alignment = "center"),
  
  grid_card(
    area = "sidebar",
    card_header("Settings"),
    card_body(
      selectInput("var", "Variable", choices = c("waiting", "eruptions")),
      sliderInput("bins", "Bins", 10, 100, 30),
      numericInput("rows", "Rows", 10, min = 1, max = nrow(faithful))
    )
  ),
  
  grid_card_plot(area = "plot1", outputId = "basePlot"),
  grid_card(area = "plot2", card_body(plotlyOutput("interactivePlot"))),
  grid_card(area = "table", card_body(DTOutput("dataTable")))
)

server <- function(input, output) {
  output$basePlot <- renderPlot({
    x <- faithful[[input$var]]
    hist(x, breaks = input$bins, col = "steelblue", border = "white",
         main = paste("Histogram of", input$var))
  })
  output$interactivePlot <- renderPlotly({
    plot_ly(x = faithful[[input$var]], type = "histogram", nbinsx = input$bins)
  })
  output$dataTable <- renderDT({
    head(faithful, input$rows)
  })
}

shinyApp(ui, server)