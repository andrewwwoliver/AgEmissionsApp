# hc_theme.R

library(highcharter)

# Define the Highcharts theme
thm <- hc_theme(
  chart = list(
    style = list(
      fontFamily = "Arial, sans-serif",
      fontSize = "16px",
      color = "black"
    )
  ),
  title = list(
    style = list(
      fontFamily = "Arial, sans-serif",
      fontSize = "16px",
      color = "black"
    )
  ),
  subtitle = list(
    style = list(
      fontFamily = "Arial, sans-serif",
      fontSize = "16px",
      color = "black"
    )
  ),
  xAxis = list(
    labels = list(
      style = list(
        fontFamily = "Arial, sans-serif",
        fontSize = "16px",
        color = "black"
      )
    ),
    title = list(
      style = list(
        fontFamily = "Arial, sans-serif",
        fontSize = "16px",
        color = "black"
      )
    )
  ),
  yAxis = list(
    labels = list(
      style = list(
        fontFamily = "Arial, sans-serif",
        fontSize = "16px",
        color = "black"
      )
    ),
    title = list(
      style = list(
        fontFamily = "Arial, sans-serif",
        fontSize = "16px",
        color = "black"
      )
    )
  ),
  tooltip = list(
    style = list(
      fontFamily = "Arial, sans-serif",
      fontSize = "16px",
      color = "black"
    ),
    headerFormat = "<b>{point.key}</b><br/>",  
    pointFormat = "{series.name}: {point.y:.2f} MtCO₂e"
  ),
  legend = list(
    itemStyle = list(
      fontFamily = "Arial, sans-serif",
      fontSize = "16px",
      color = "black"
    )
  ),
  plotOptions = list(
    series = list(
      stickyTracking = FALSE,
      itemStyle = list(
        fontFamily = "Arial, sans-serif",
        fontSize = "16px",
        color = "black"
      ),
      dataLabels = list(
        style = list(
          fontFamily = "Arial, sans-serif",
          fontSize = "16px",  # Increase the font size for data labels
          color = "black"
        )
      ),
      marker = list(
        enabled = TRUE,
        states = list(
          hover = list(
            enabled = TRUE
          )
        )
      )
    )
  ),
  colors = c("#002d54", "#2b9c93", "#6a2063", "#e5682a", "#0b4c0b", "#5d9f3c", "#592c20", "#ca72a2")
)

# Apply the Highcharts theme globally
options(highcharter.theme = thm)
