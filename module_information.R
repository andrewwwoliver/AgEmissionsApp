# module_information.R

informationUI <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      class = "container",
      tags$div(style = "font-size: 24px; font-weight: bold;", "Publications:"),  # Bigger and bold title
      tags$div(
        style = "margin-top: 20px;",
        tags$div(style = "font-size: 18px; font-weight: bold;", "Scottish Greenhouse Gas Statistics"),
        p(HTML('Official estimates of greenhouse gas emissions are available in the <a href="https://www.gov.scot/publications/scottish-greenhouse-gas-statistics-2022/documents/" target="_blank">Scottish Greenhouse Gas Statistics 2022</a> publication.')),
        tags$div(style = "font-size: 18px; font-weight: bold;", "Greenhouse Gas Inventory Reports"),
        p(a(href = "https://www.gov.scot/publications/estimated-dairy-emissions-mitigation-smart-inventory/", "Greenhouse gas inventory: estimated dairy emissions and their mitigation", target = "_blank")),
        tags$div(style = "font-size: 18px; font-weight: bold;", "Climate change evidence reports"),
        p(a(href = "https://www.gov.scot/publications/resas-climate-change-evidence-dairy-farmer-led-group/", "Dairy Farmer-led Group: climate change evidence", target = "_blank")),
        p(a(href = "https://www.gov.scot/publications/resas-climate-change-evidence-arable-farmer-led-group/", "Arable Farmer-led Group: climate change evidence", target = "_blank")),
        p(a(href = "https://www.gov.scot/publications/resas-climate-change-evidence-huc-farmer-led-group/", "Hill, Upland and Crofting Farmer-led Group: climate change evidence", target = "_blank")),
        p(a(href = "https://www.gov.scot/publications/pig-sector-flg-climate-change-greenhouse-gas-evidence/", "Pig Sector Farmer-Led Climate Change Group: climate change and greenhouse gas evidence", target = "_blank")),
        tags$div(style = "font-size: 18px; font-weight: bold;", "Greenhouse Gas Inventory Reports"),
        p(a(href = "https://www.gov.scot/publications/estimated-dairy-emissions-mitigation-smart-inventory/", "Greenhouse gas inventory: estimated dairy emissions and their mitigation", target = "_blank")),
        p(a(href = "https://www.gov.scot/publications/estimated-arable-emissions-mitigation-smart-inventory/", "Greenhouse gas inventory: estimated arable emissions and their mitigation", target = "_blank")),
        p(a(href = "https://www.gov.scot/publications/disaggregating-headline-smart-inventory-figures/", "Greenhouse gas emissions - agricultural: disaggregating headline figures", target = "_blank"))
      ),
      tags$div(style = "font-size: 24px; font-weight: bold; margin-top: 40px;", "Glossary:"),  # Bigger and bold title
      tags$div(
        style = "margin-top: 20px;",
        tags$div(style = "font-size: 18px; font-weight: bold;", "Carbon dioxide (CO2):"),
        p("Carbon dioxide is one of the main gases responsible for climate change. It is mostly emitted through the oxidation of carbon in fossil fuels, e.g. burning coal."),
        tags$div(style = "font-size: 18px; font-weight: bold;", "Greenhouse gas:"),
        p("A greenhouse gas is a gas which absorbs infrared radiation emitted from the surface of the Earth, helping to retain a portion of that energy in the atmosphere as heat."),
        tags$div(style = "font-size: 18px; font-weight: bold;", "LULUCF:"),
        p("Estimates of emissions and removals from land use, land use change and forestry (LULUCF) depend critically on assumptions made on the rate of loss or gain of carbon in Scotland’s carbon rich soils. In Scotland, LULUCF activities, taken as a whole, acts as a slight source in recent years although acted as a net sink between 2009-2017, absorbing more greenhouse gas emissions than it releases."),
        tags$div(style = "font-size: 18px; font-weight: bold;", "Methane (CH4):"),
        p("Methane is a greenhouse gas that is around 28 times more potent in the atmosphere than CO2 over a 100-year time horizon. Main sources include agriculture and landfill."),
        tags$div(style = "font-size: 18px; font-weight: bold;", "Metric tonne of carbon dioxide equivalent (MtCO₂e):"),
        p("Provides an estimate of total GHG emissions taking into account the different effects that different gases have on climate change, known as their global warming potential (GWP)."),
        tags$div(style = "font-size: 18px; font-weight: bold;", "Nitrous oxide (N2O):"),
        p("Nitrous oxide is a greenhouse gas that is around 265 times more potent in the atmosphere than CO2 over a 100-year time horizon. The main source is agricultural soil.")
      )
    )
  )
}
