library(highcharter)

theme <- hc_theme(
  colors = c("#0065bd",
             "#002d54",
             "#5eb135",
             "#017878",
             "#f47738",
             "#e5007e"
  ), 
  chart = list(
    backgroundColor = NULL
  ),
  title = list(
    style = list(
      color = "black",
      fontFamily = "Roboto",
      fontSize= "20px"
    )
  ),
  subtitle = list(
    style = list(
      color = "black",
      fontFamily = "Roboto"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = "Roboto",
      fontSize= "20px",
      color = "black"
    )
  ),
  itemHoverStyle = list(
    color = "black",
    fontFamily = "Roboto",
    fontSize= "30px"
  ),
  

  
  tooltip = list(
    style=list(
      color = "black",
      fontFamily = "Roboto",
      fontSize= "18px",
      fontWeight = "bold")
  ))
