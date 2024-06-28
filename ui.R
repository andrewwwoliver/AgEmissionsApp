# ui.R

# Source UI modules
source("panels.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")
source("module_summary.R")
source("module_information.R")  # Add this line
source("hc_theme.R")
library(shinyjs)

# Function to create the footer panel
create_footer <- function() {
  div(
    class = "footer",
    span("Last Updated: ", format(Sys.Date(), "%d/%m/%Y")),
    img(src = "sg.png", alt = "SG Logo", style = "height: 30px; margin-left: 10px;")
  )
}

# Generate the UI
ui <- fluidPage(
  useShinyjs(),  # Initialize shinyjs
  theme = shinytheme("flatly"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    includeHTML("google-analytics.html"),  # Include Google Analytics HTML
    tags$script(HTML("
      $(document).ready(function() {
        $('#toggleSidebar').on('click', function() {
          var isVisible = $('#sidebar_total, #sidebar_subsector, #sidebar_gas').is(':visible');
          $('#sidebar_total, #sidebar_subsector, #sidebar_gas').toggle();
          if (isVisible) {
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-9').addClass('col-sm-12');
          } else {
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-12').addClass('col-sm-9');
          }
          setTimeout(function() {
            $(window).trigger('resize');
            Highcharts.charts.forEach(function(chart) {
              if (chart) {
                chart.reflow();
              }
            });
          }, 300); // Delay to ensure the toggle animation is complete
        });

        Shiny.addCustomMessageHandler('sidebarState', function(message) {
          if (message === 'close') {
            $('#sidebar_total, #sidebar_subsector, #sidebar_gas').hide();
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-9').addClass('col-sm-12');
          } else {
            $('#sidebar_total, #sidebar_subsector, #sidebar_gas').show();
            $('#mainpanel_total, #mainpanel_subsector, #mainpanel_gas').removeClass('col-sm-12').addClass('col-sm-9');
          }
          setTimeout(function() {
            $(window).trigger('resize');
            Highcharts.charts.forEach(function(chart) {
              if (chart) {
                chart.reflow();
              }
            });
          }, 300); // Delay to ensure the toggle animation is complete
        });
      });
    "))
  ),
  div(class = "container-fluid full-height",
      div(class = "content",
          navbarPage(
            title = div(
              div("Scottish Agricultural Emissions Dashboard", style = "display: inline-block; margin-right: 20px;"),
              actionLink("toggleSidebar", icon("bars"), class = "nav-link", style = "display: inline-block; vertical-align: middle;"),
              tags$li(class = "nav-item", img(src = "RESAS Logo.png", class = "header-logo"))
            ),
            id = "navbar",
            tabPanel("Agriculture Emissions", value = "subsector", generate_sidebar_layout("subsector", "Subsector Emissions")),
            tabPanel("Industry Emissions", value = "total", generate_sidebar_layout("total", "Total Emissions")),
            tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas", "Gas Emissions")),
            tabPanel("Further Information", value = "info", informationUI("info"))  # Add this line
          )
      ),
      create_footer()
  )
)
