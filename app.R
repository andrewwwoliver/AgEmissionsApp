#app.R

# Source other elements
source("options.R")
source("hc_theme.R")
source("data.R")

# Source the modules
source("gas_module.R")
source("subsector_module.R")
source("module_summary.R")

# Source the UI and server components
source("ui.R")
source("server.R")

# Run the app
shinyApp(ui = ui, server = server)
