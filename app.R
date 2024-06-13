# Source other elements
source("module_sidebar.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_data_functions.R")
source("module_chart_functions.R")

# Source the UI and server components
source("ui.R")
source("server.R")


# Run the app
shinyApp(ui, server)
