# Function to render data tables
render_data_table <- function(table_id, chart_data, output) {
  output[[table_id]] <- renderDataTable({
    data <- chart_data()  # Get the reactive chart data
    data$Year <- as.character(data$Year)  # Convert Year to character
    first_column_name <- names(data)[1]  # Get the first column name
    # Pivot data to wide format
    data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
    # Format numeric columns
    data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
    as_tibble(data)  # Convert to tibble
  })
}

# Function to handle data download
handle_data_download <- function(download_id, chart_type, chart_data, input, output) {
  output[[download_id]] <- downloadHandler(
    filename = function() {
      paste("Agricultural Emissions Data -", chart_type, min(input[[paste0("year_", download_id)]]), "to", max(input[[paste0("year_", download_id)]]), ".csv", sep = " ")
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
