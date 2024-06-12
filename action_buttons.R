# Event handler for "Select All" button
observeEvent(input$select_all_button, {
  updateCheckboxGroupInput(session, "variables", selected = variables())
})

