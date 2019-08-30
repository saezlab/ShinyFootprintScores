feature_input_inverse = reactive({
  switch(
    input$select_organism_multi_expr_inverse,
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
  if (!is.null(input$select_feature_picker_inverse)) {
    annotation_df %>%
      filter(resource %in% input$select_resource_multi_expr_inverse) %>%
      filter(organism == input$select_organism_multi_expr_inverse) %>%
      distinct(id) %>%
      inner_join(activities_df, by="id") %>%
      filter(feature == input$select_feature_picker_inverse) %>% 
      pull(activity) %>%
      range()
  }

})

output$select_feature_inverse = renderUI({
  pickerInput(inputId = "select_feature_picker_inverse", 
              label = "Select Pathway/TF:", 
              choices = feature_input_inverse(),
              options = list(`live-search` = TRUE,
                             `actions-box` = TRUE))
})

output$feature_range = renderUI({
  if (!is.null(input$select_feature_picker_inverse) & !is.null(input$select_resource_multi_expr_inverse)) {
    r = round(list_feature_ranges(),4)
    sliderInput("select_feature_range", label = "Choose activity range:", min = r[1], 
                max = r[2], value = r)
  }
})

output$highest_scores = DT::renderDataTable({
  if (!is.null(input$select_feature_picker_inverse) & !is.null(input$select_feature_range) & !is.null(input$select_resource_multi_expr_inverse)) {
    annotation_df %>%
      select(-sample, -sample_link, -group, -accession, accession = accession_link) %>%
      distinct() %>%
      filter(resource %in% input$select_resource_multi_expr_inverse) %>%
      filter(organism == input$select_organism_multi_expr_inverse) %>%
      inner_join(activities_df, by=c("id", "resource")) %>%
      filter(feature == input$select_feature_picker_inverse) %>% 
      select_if(~!all(is.na(.))) %>%
      filter(between(activity, input$select_feature_range[1] - 0.001, input$select_feature_range[2] + 0.001)) %>%
      arrange(-activity) %>%
      select(resource, id, accession, organism, class, feature, activity, everything()) %>%
      DT::datatable(., escape = F, selection = list(target = "none"),
                    filter = "top",
                    extensions = "Buttons",
                    option = list(scrollX = TRUE, 
                                  autoWidth=T,
                                  dom = "Bfrtip",
                                  buttons = c("copy", "csv", "excel"))) %>%
      formatSignif("activity")
  }

})

