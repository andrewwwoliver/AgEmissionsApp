#Show where the sources come from

source("module_sidebar.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")

# Custom CSS to adjust the layout
custom_css <- "
.hidden-sidebar {
  display: none !important;
}
.full-width {
  width: 100% !important;
}
"

# Custom JavaScript to toggle the sidebar visibility and reset values
custom_js <- "
$(document).ready(function() {
  // Function to handle sidebar visibility and reset
  function toggleSidebar(tabValue) {
    if (tabValue === 'Bar Chart') {
      $('#sidebar_total, #sidebar_subsector, #sidebar_gas').hide();
      $('#main_total, #main_subsector, #main_gas').addClass('full-width').removeClass('col-sm-9');
      // Reset the sidebar inputs when Bar Chart is selected
      Shiny.setInputValue('reset_sidebar', Math.random());
    } else {
      $('#sidebar_total, #sidebar_subsector, #sidebar_gas').show();
      $('#main_total, #main_subsector, #main_gas').removeClass('full-width').addClass('col-sm-9');
    }
  }

  // Initial call to handle the default selected tab
  toggleSidebar($('#navbar .active').text());

  // Event listener for tab changes
  $('a[data-toggle=\"tab\"]').on('shown.bs.tab', function(e) {
    var tabText = $(e.target).text();
    toggleSidebar(tabText);
  });

  // Event listeners for header clicks
  $('#navbar a[data-value=\"total\"], #navbar a[data-value=\"subsector\"], #navbar a[data-value=\"gas\"]').on('click', function() {
    if ($('#navbar .active').text() === 'Bar Chart') {
      $('#sidebar_total, #sidebar_subsector, #sidebar_gas').hide();
      $('#main_total, #main_subsector, #main_gas').addClass('full-width').removeClass('col-sm-9');
    }
  });
});
"

# Generate the UI
ui <- fluidPage(
  theme = shinytheme("flatly"),  # Apply a shiny theme
  tags$head(
    tags$style(HTML(custom_css)),
    tags$script(HTML(custom_js))
  ),
  navbarPage(
    title = "Agricultural Emissions",
    id = "navbar",
   
 # Create tabs for each emissions type
    tabPanel("Total Emissions", value = "total", generate_sidebar_layout("total")),
    tabPanel("Subsector Emissions", value = "subsector", generate_sidebar_layout("subsector")),
    tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas"))
  )
)  