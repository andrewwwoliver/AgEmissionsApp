#module_chart_functions.R

# Function to render line charts
render_line_chart <- function(chart_id, chart_data, chart_type, input, output) {
  column_name <- reactive({ names(chart_data())[1] })
  
  title <- reactive({
    switch(chart_type,
           "Total Emissions" = "National Greenhouse Gas Emissions by Source in Scotland",
           "Subsector Emissions" = "Agricultural Greenhouse Gas Emissions by Subsector in Scotland",
           "Gas Emissions" = "Agricultural Greenhouse Gas Emissions Breakdown in Scotland"
    )
  })
  
  yAxisTitle <- reactive({
    switch(chart_type,
           "Total Emissions" = "Emissions (MtCO₂e)",
           "Subsector Emissions" = "Emissions (MtCO₂e)",
           "Gas Emissions" = "Emissions (MtCO₂e)")
  })
  
  footer_text <- reactive({
    switch(chart_type,
           "Total Emissions" = '<div style="font-size: 16px;"><a href="https://www.gov.scot/publications/scottish-greenhouse-gas-statistics-2022/documents/">Source: Scottish Greenhouse Gas Statistics 2022</a></div>',
           "Subsector Emissions" = '<div style="font-size: 16px; font-weight: bold;">Source: Scottish agriculture greenhouse gas emissions and nitrogen use 2022-23.</div>',
           "Gas Emissions" = '<div style="font-size: 16px; font-weight: bold;">Source: Scottish agriculture greenhouse gas emissions and nitrogen use 2022-23.</div>')
  })
  
  lineChartServer(chart_id, chart_data, column_name, title, yAxisTitle, footer_text)
}

# Function to render area charts
render_area_chart <- function(chart_id, chart_data, chart_type, input, output) {
  column_name <- reactive({ names(chart_data())[1] })
  
  title <- reactive({
    switch(chart_type,
           "Total Emissions" = "National Greenhouse Gas Emissions by Source in Scotland",
           "Subsector Emissions" = "Agricultural Greenhouse Gas Emissions by Subsector in Scotland",
           "Gas Emissions" = "Agricultural Greenhouse Gas Emissions Breakdown in Scotland"
    )
  })
  
  yAxisTitle <- reactive({
    switch(chart_type,
           "Total Emissions" = "Emissions (MtCO₂e)",
           "Subsector Emissions" = "Emissions (MtCO₂e)",
           "Gas Emissions" = "Emissions (MtCO₂e)")
  })
  
  footer_text <- reactive({
    switch(chart_type,
           "Total Emissions" = '<div style="font-size: 16px;"><a href="https://www.gov.scot/publications/scottish-greenhouse-gas-statistics-2022/documents/">Source: Scottish Greenhouse Gas Statistics 2022</a></div>',
           "Subsector Emissions" = '<div style="font-size: 16px; font-weight: bold;">Source: Scottish agriculture greenhouse gas emissions and nitrogen use 2022-23.</div>',
           "Gas Emissions" = '<div style="font-size: 16px; font-weight: bold;">Source: Scottish agriculture greenhouse gas emissions and nitrogen use 2022-23.</div>')
  })
  
  areaChartServer(chart_id, chart_data, column_name, title, yAxisTitle, footer_text)
}

# Function to render bar charts
render_bar_chart <- function(chart_id, chart_data, chart_type, input, output) {
  column_name <- reactive({ names(chart_data())[1] })
  
  title <- reactive({
    switch(chart_type,
           "Total Emissions" = "National Greenhouse Gas Emissions Timelapse",
           "Subsector Emissions" = "Agricultural Greenhouse Gas Emissions Timelapse",
           "Gas Emissions" = "Agricultural Greenhouse Gas Emissions Breakdown Timelapse"
    )
  })
  
  yAxisTitle <- reactive({
    switch(chart_type,
           "Total Emissions" = "Emissions (MtCO₂e)",
           "Subsector Emissions" = "Emissions (MtCO₂e)",
           "Gas Emissions" = "Emissions (MtCO₂e)")
  })
  
  footer_text <- reactive({
    switch(chart_type,
           "Total Emissions" = '<div style="font-size: 16px;"><a href="https://www.gov.scot/publications/scottish-greenhouse-gas-statistics-2022/documents/">Source: Scottish Greenhouse Gas Statistics 2022</a></div>',
           "Subsector Emissions" = '<div style="font-size: 16px; font-weight: bold;">Source: Scottish agriculture greenhouse gas emissions and nitrogen use 2022-23.</div>',
           "Gas Emissions" = '<div style="font-size: 16px; font-weight: bold;">Source: Scottish agriculture greenhouse gas emissions and nitrogen use 2022-23.</div>')
  })
  
  barChartServer(chart_id, chart_data, column_name, title, yAxisTitle, footer_text)
}
