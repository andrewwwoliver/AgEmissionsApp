#server.R

# Source the necessary modules for server logic
source("module_summary.R")
source("gas_module.R")
source("subsector_module.R")

# Set up server
server <- function(input, output, session) {
  # Set up modules
  gasServer("gas")
  subsectorServer("subsector")
}
