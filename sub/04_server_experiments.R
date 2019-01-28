selected_resource = eventReactive(input$select_resource, {
  input$select_resource
})

# selected_organism = eventReactive(input$select_organism, {
#   print(input$select_organism)
#   if (is.null(input$select_organism)) {
#     c("human", "mouse")
#   } else {
#     input$select_organism
#   }
# })

selected_organism = eventReactive(input$select_organism, {
    input$select_organism
})

included_sample_ids = eventReactive(input$include_sample_ids, {
  input$include_sample_ids
})

output$anno_df = DT::renderDataTable({
  if (!is.null(selected_resource()) & !is.null(selected_organism())) {
    annotation_df_tmp = annotation_df %>%
      filter(resource %in% selected_resource() & organism %in% selected_organism()) %>%
      arrange(id, group) %>%
      select(-resource) %>%
      select(-accession, -sample) %>%
      select_if(~!all(is.na(.))) %>%
      rename(sample=sample_link, accession=accession_link)
      
    if (included_sample_ids() == "No") {
      annotation_df_tmp %>%
        select(-sample, -group) %>%
        distinct() %>%
        DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                      filter = "top", selection = list(target = "none"))
    } else {
      annotation_df_tmp %>%
        DT::datatable(., escape = F, option = list(scrollX = TRUE, autoWidth=T), 
                      filter = "top", selection = list(target = "none"))
    }
  }
})

output$download_meta = downloadHandler(
  filename = function() {
    "meta_data.csv"
  },
  content = function(file) {
    annotation_df %>%
      filter(resource %in% selected_resource() & organism %in% selected_organism()) %>%
      select_if(~!all(is.na(.))) %>%
      select(-sample_link, -accession_link) %>%
      select(-group, -sample) %>%
      distinct() %>%
      write_delim(., file)
  })