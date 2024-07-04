# Define the paths to your module files
code_files <- c(
  "app.R",
  "data.R",
  "hc_theme.R",
  "module_area_chart.R",
  "module_bar_chart.R",
  "module_chart_functions.R",
  "module_data_functions.R",
  "module_data_table.R",
  "module_information.R",
  "module_line_chart.R",
  "module_summary.R",
  "options.R",
  "panels.R",
  "server.R",
  "ui.R",
  "www/styles.css"
)

# Function to read and concatenate the contents of the files
combine_code_files <- function(files) {
  code <- sapply(files, function(file) {
    file_content <- tryCatch({
      paste(readLines(file), collapse = "\n")
    }, error = function(e) {
      message(paste("Error reading file:", file))
      return("")
    })
    paste("## File:", file, "\n", file_content)
  }, USE.NAMES = FALSE)
  paste(code, collapse = "\n\n")
}

# Combine the contents of the specified files
combined_code <- combine_code_files(code_files)

# Specify the output file
output_file <- "combined_code.txt"

# Write the combined contents to the output file
writeLines(combined_code, con = output_file)

# Notify the user
cat("The combined code has been written to", output_file)
