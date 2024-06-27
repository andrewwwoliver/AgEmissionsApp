#module_data_table.R

library(DT)

# Function to render data tables using DT::renderDT
render_data_table <- function(table_id, chart_data, output) {
  output[[table_id]] <- DT::renderDT({
    data <- chart_data()
    data$Year <- as.character(data$Year)
    first_column_name <- names(data)[1]
    data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
    data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 2)))
    datatable(as_tibble(data), options = list(paging = FALSE, scrollX = TRUE, dom = 'Bfrtip', buttons = c('copy', 'csv', 'excel', 'pdf', 'print')), rownames = FALSE)
  })
}

# Function to handle data download
handle_data_download <- function(download_id, chart_type, chart_data, input, output, year_input) {
  output[[download_id]] <- downloadHandler(
    filename = function() { paste("Agricultural Emissions Data -", chart_type, min(input[[year_input]]), "to", max(input[[year_input]]), ".csv") },
    content = function(file) { 
      data <- chart_data()
      first_column_name <- names(data)[1]
      data <- pivot_wider(data, names_from = !!sym(first_column_name), values_from = Value)
      data <- data %>% mutate(across(where(is.numeric), ~ formatC(.x, format = "f", digits = 5)))
      write.csv(data, file, row.names = FALSE)
    }
  )
}
