#app.R

# Source other elements
source("options.R")
source("module_summary.R")

# Source the UI and server components
source("ui.R")
source("server.R")

# Run the app
shinyApp(ui = ui, server = server)
