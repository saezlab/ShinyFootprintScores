creeds_ids_of_interest = eventReactive(c(input$select_feature_picker, input$select_disease_set_picker), {
  x = annotation_df %>%
    left_join(diseasesets_df, by=c("id", "disease")) %>%
    filter(organism == input$select_organism_multi_expr) %>%
    mutate(var = case_when(resource == "disease signatures" ~ disease,
                           resource == "single gene perturbation" ~ target,
                           resource == "single drug perturbation" ~ drug)) %>%
      filter(if (is.null(input$select_feature_picker)) TRUE else var %in% input$select_feature_picker) %>%
      filter(if (is.null(input$select_disease_set_picker)) TRUE else disease_set %in% input$select_disease_set_picker) %>%
    distinct(id) 
})

selected_organism_multi_expr = eventReactive(input$select_organism_multi_expr, {
  input$select_organism_multi_expr
})


observeEvent(input$select_resource_multi_expr, {
  updatePickerInput(session = session, inputId = "select_disease_set_picker",
                    choices = disease_set_input(),
                    selected = NULL)
  
  updatePickerInput(session = session, inputId = "select_feature_picker",
                    choices = feature_input(),
                    selected = NULL)
})

# 
feature_input = reactive({
  switch(
    input$select_organism_multi_expr,
    "human" = annotation_df %>%
      filter(organism == "human" & resource == input$select_resource_multi_expr) %>%
      mutate(var = case_when(resource == "disease signatures" ~ disease,
                             resource == "single gene perturbation" ~ target,
                             resource == "single drug perturbation" ~ drug)) %>%
      distinct(var, resource) %>%
      arrange(var, resource) %>%
      pull(var),
    "mouse" = annotation_df %>%
      filter(organism == "mouse" & resource == input$select_resource_multi_expr) %>%
      mutate(var = case_when(resource == "disease signatures" ~ disease,
                             resource == "single gene perturbation" ~ target,
                             resource == "single drug perturbation" ~ drug)) %>%
      distinct(var, resource) %>%
      arrange(var, resource) %>%
      pull(var)
  )
})

output$select_feature = renderUI({
  widget_title = switch(
    input$select_resource_multi_expr,
    "disease signatures" = "Select disease(s)",
    "single drug perturbation" = "Select drug(s)",
    "single gene perturbation" = "Select target gene(s)"
  )
  
  pickerInput(inputId = "select_feature_picker",
              label = widget_title,
              choices = feature_input(),
              options = list(`live-search` = TRUE ,
                             `actions-box` = TRUE),
              multiple = T)
})

disease_set_input = reactive({
  choice = switch(
    input$select_organism_multi_expr,
    "human" = annotation_df %>%
      filter(organism == "human") %>%
      inner_join(diseasesets_df, by=c("id", "disease")) %>%
      distinct(disease_set) %>%
      arrange(disease_set) %>%
      pull(),
    "mouse" = annotation_df %>%
      filter(organism == "mouse") %>%
      inner_join(diseasesets_df, by=c("id", "disease")) %>%
      distinct(disease_set) %>%
      arrange(disease_set) %>%
      pull()
  )
})

output$select_disease_set = renderUI({
  pickerInput(inputId = "select_disease_set_picker",
              label = "Select disease ontology(s)",
              choices = disease_set_input(),
              options = list(`live-search` = TRUE,
                             `actions-box` = TRUE),
              multiple = T)
})


# disable single disease picker when a disease ontology is selected
observe({
  if (!is.null(input$select_disease_set_picker)) {
    disable("select_feature_picker")
  } else {
    enable("select_feature_picker")
  }
})

# disable disease ontology picker when a single disease is selected
observe({
  if (!is.null(input$select_feature_picker)) {
    disable("select_disease_set_picker")
  } else {
    enable("select_disease_set_picker")
  }
})

observeEvent(c(input$select_feature_picker, input$select_disease_set_picker), {
  m = annotation_df %>%
    semi_join(creeds_ids_of_interest(), by="id") %>%
    distinct(id, organism, disease, target, drug, perturbation, info, 
           accession = accession_link)
  if (nrow(m) == 1) {
    info_text = str_c("For your query only one experiment exists (", 
                      creeds_ids_of_interest()$id, "). Check out the tab 'Query single experiment' to visualize pathway/TF activities of single experiments.")
    showNotification(info_text, type="warning", duration = 10)
  }
  
})


# metadata
output$meta = DT::renderDT({
  if (!is.null(input$select_feature_picker) | !is.null(input$select_disease_set_picker)) {
    annotation_df %>%
      semi_join(creeds_ids_of_interest(), by="id") %>%
      select(id, organism, disease, target, drug, perturbation, info, 
             accession = accession_link) %>%
      distinct() %>%
      DT::datatable(., escape = F, selection = list(target = "none"),
                    filter = "top",
                    option = list(scrollX = TRUE, autoWidth=T))
    
  }
})

# heatmaps
# pathway
output$pathway_heatmaps = renderD3heatmap({
  if (!is.null(input$select_feature_picker) | !is.null(input$select_disease_set_picker)) {
    mat = annotation_df %>%
      semi_join(creeds_ids_of_interest(), by="id") %>%
      distinct(id, organism) %>%
      inner_join(activities_df, by="id") %>%
      filter(class == "pathway") %>%
      select(id, feature, activity) %>%
      spread(feature, activity) %>%
      column_to_rownames("id") %>%
      data.frame(check.names = F, stringsAsFactors = F)
    
    myBreaks = c(seq(min(mat), 0, length.out=ceiling(100/2) + 1), 
                 seq(max(mat)/100, max(mat), length.out=floor(100/2)))
    myPalette = colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(100)
    colorFunc = col_bin(myPalette, bins = rescale(myBreaks))
    
    if (nrow(mat) > 1) {
      d3heatmap(mat, color = colorFunc)
    }
  }
})

# tf
output$tf_heatmaps = renderD3heatmap({
  if (!is.null(input$select_feature_picker) | !is.null(input$select_disease_set_picker)) {
    mat = annotation_df %>%
      semi_join(creeds_ids_of_interest(), by="id") %>%
      distinct(id, organism) %>%
      inner_join(activities_df, by="id") %>%
      filter(class == "tf" & confidence %in% c("A", "B")) %>%
      select(id, feature, activity) %>%
      spread(feature, activity) %>%
      column_to_rownames("id") %>%
      data.frame(check.names = F, stringsAsFactors = F)
    
    myBreaks = c(seq(min(mat, na.rm = T), 0, length.out=ceiling(100/2) + 1), 
                 seq(max(mat, na.rm = T)/100, max(mat, na.rm = T), length.out=floor(100/2)))
    myPalette = colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(100)
    colorFunc = col_bin(myPalette, bins = rescale(myBreaks))
    
    if (nrow(mat) > 1) {
      d3heatmap(mat, color = colorFunc)
    } 
  }
})

# data
# pathway
output$pathway_table = renderDT({
  if (!is.null(input$select_feature_picker) | !is.null(input$select_disease_set_picker)) {
    annotation_df %>%
      semi_join(creeds_ids_of_interest(), by="id") %>%
      distinct(id, organism) %>%
      inner_join(activities_df, by="id") %>%
      filter(class == "pathway") %>%
      select(id, Pathway = feature, activity) %>%
      spread(id, activity) %>%
      mutate_if(is.numeric, signif) %>%
      DT::datatable(., escape = F, selection = list(target = "none"),
                    filter = "top",
                    extensions = "Buttons",
                    option = list(scrollX = TRUE,
                                  autoWidth=T,
                                  dom = "Bfrtip",
                                  pageLength = 14,
                                  buttons = c("copy", "csv", "excel")))
  }
})

# data
# tf
output$tf_table = renderDT({
  if (!is.null(input$select_feature_picker) | !is.null(input$select_disease_set_picker)) {
    annotation_df %>%
      semi_join(creeds_ids_of_interest(), by="id") %>%distinct(id, organism) %>%
      inner_join(activities_df, by="id") %>%
      filter(class == "tf") %>%
      select(id, TF = feature, activity, confidence) %>%
      spread(id, activity) %>%
      mutate_if(is.numeric, signif) %>%
      DT::datatable(., escape = F, selection = list(target = "none"),
                    filter = "top",
                    extensions = "Buttons",
                    option = list(scrollX = TRUE, 
                                  autoWidth=T,
                                  dom = 'Bfrtip',
                                  buttons = c("copy", "csv", "excel")))
  }
})

output$download_single_experiment = downloadHandler(
  filename = function() {
    paste0(selected_id(), "_pathway_tf_scores.csv")
  },
  content = function(file) {
    activity_df() %>%
      write_delim(., file)
  })

