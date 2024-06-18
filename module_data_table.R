##module_data_table.R
library(DT)

# Function to render data tables using DT::renderDT
render_data_table <- function(table_id, chart_data, output) {
  output[[table_id]] <- DT::renderDT({
    data <- chart_data()  # Get the reactive chart data
    data$Year <- as.character(data$Year)  # Convert Year to character
    first_column_name <- names(data)[1]  # Get the first column name
    # Pivot data to wide format
    data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
    # Format numeric columns
    data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
    datatable(
      as_tibble(data),  # Convert to tibble
      options = list(
        paging = FALSE,  # Disable paging
        scrollX = TRUE,  # Enable horizontal scrolling
        dom = 'Bfrtip',  # Add buttons for export options
        buttons = c('copy', 'csv', 'excel', 'pdf', 'print')  # Buttons for exporting data
      ),
      rownames = FALSE
    )
  })
}


# Function to handle data download
handle_data_download <- function(download_id, chart_type, chart_data, input, output, year_input) {
  output[[download_id]] <- downloadHandler(
    filename = function() {
      year_range <- input[[year_input]]
      paste("Agricultural Emissions Data -", chart_type, min(year_range), "to", max(year_range), ".csv", sep = " ")
    },
    content = function(file) { 
      data <- chart_data()  # Get the reactive chart data
      first_column_name <- names(data)[1]  # Get the first column name
      # Pivot data to wide format
      data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
      # Format numeric columns
      data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 5)))
      write.csv(data, file, row.names = FALSE)  # Write data to CSV
    }
  )
}


