selected_resource_multi_expr = eventReactive(input$select_resource_multi_expr, {
  input$select_resource_multi_expr
})

selected_organism_multi_expr = eventReactive(input$select_organism_multi_expr, {
  input$select_organism_multi_expr
})

feature_input = reactive({
  switch(
    input$select_organism_multi_expr,
    "human" = annotation_df %>% 
      filter(organism == "human") %>%
      distinct(id) %>%
      inner_join(activities_df, by="id") %>%
      distinct(feature, class) %>%
      select(feature, class) %>%
      arrange(class, feature) %>%
      unstack(),
    "mouse" = annotation_df %>% 
      filter(organism == "mouse") %>%
      distinct(id) %>%
      inner_join(activities_df, by="id") %>%
      distinct(feature, class) %>%
      select(feature, class) %>%
      arrange(class, feature) %>%
      unstack()
  )
})

list_feature_ranges = reactive({
  if (!is.null(input$select_feature_picker)) {
    annotation_df %>%
      filter(resource %in% selected_resource_multi_expr()) %>%
      filter(organism == selected_organism_multi_expr()) %>%
      distinct(id) %>%
      inner_join(activities_df) %>%
      filter(feature == input$select_feature_picker) %>% 
      pull(activity) %>%
      range()
  }

})

output$select_feature = renderUI({
  pickerInput(inputId = "select_feature_picker", 
              label = "Select Pathway/TF:", 
              choices = feature_input(),
              options = list(`live-search` = TRUE))
})

output$feature_range = renderUI({
  if (!is.null(input$select_feature_picker) & !is.null(selected_resource_multi_expr())) {
    r = round(list_feature_ranges(),4)
    sliderInput("select_feature_range", label = "Choose activity range:", min = r[1], 
                max = r[2], value = r)
  }
})

output$highest_scores = DT::renderDataTable({
  if (!is.null(input$select_feature_picker) & !is.null(input$select_feature_range) & !is.null(selected_resource_multi_expr())) {
    annotation_df %>%
      select(-sample, -sample_link, -group, -accession, accession = accession_link) %>%
      distinct() %>%
      filter(resource %in% selected_resource_multi_expr()) %>%
      filter(organism == selected_organism_multi_expr()) %>%
      inner_join(activities_df) %>%
      filter(feature == input$select_feature_picker) %>% 
      select_if(~!all(is.na(.))) %>%
      filter(between(activity, input$select_feature_range[1] - 0.001, input$select_feature_range[2] + 0.001)) %>%
      arrange(-activity) %>%
      select(resource, id, accession, organism, class, feature, activity, everything()) %>%
      DT::datatable(., escape = F, selection = list(target = "none"),
                    filter = "top",
                    option = list(scrollX = TRUE, autoWidth=T)) %>%
      formatSignif("activity")
  }

})

