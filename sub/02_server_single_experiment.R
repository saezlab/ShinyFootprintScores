selected_query_type = eventReactive(input$select_query_type, {
  input$select_query_type
})

selected_id = eventReactive(input$select_id, {
  input$select_id
})

selected_conf = eventReactive(input$select_conf, {
  input$select_conf
})

selected_top_n = eventReactive(input$select_top_n, {
  input$select_top_n
})

activity_df = reactive({
  if (!is.null(selected_id())) {
    annotation_df %>%
      filter(id == selected_id() | accession == selected_id()) %>%
      distinct(id, accession) %>%
      inner_join(activities_df) %>%
      filter(confidence %in% selected_conf() | is.na(confidence))
  }
})
  
query_input = reactive({
  switch(
    input$select_query_type,
    "CREEDS" = annotation_df %>% 
      distinct(id, resource) %>%
      unstack(),
    "GEO" = annotation_df %>% 
      distinct(accession, resource) %>% 
      unstack()
    )
  })

output$select_query <- renderUI({
    pickerInput(inputId = "select_id", 
                label = "Select ID:", 
                choices = query_input(),
                options = list(`live-search` = TRUE))
})

output$meta_df = DT::renderDataTable({
  print(selected_id())
  annotation_df %>%
    filter(id == selected_id() | accession == selected_id()) %>%
    select(-accession, -sample, -sample_link, -group) %>%
    select_if(~!all(is.na(.))) %>%
    rename(accession=accession_link) %>%
    distinct() %>%
    select(accession, id, resource, organism, everything()) %>%
    DT::datatable(., escape = F, selection = list(target = "none"),
                  class = "compact",
                  option = list(scrollX = TRUE, autoWidth=T,
                                pageLength = 2,
                                lengthMenu = c(2, 5, 15, 20)))
})

output$progeny_scores_single_experiment = renderPlot({
  if (length(unique(activity_df()$id)) == 1) {
    activity_df() %>%
      filter(class == "pathway") %>%
      arrange(activity) %>%
      mutate(feature = as_factor(feature),
             effect = factor(sign(activity)),
             abs_activity = abs(activity)) %>%
      ggplot(aes(x=feature, y=activity, color=effect)) +
      geom_segment(aes(x=feature, xend=feature, y=0, yend=activity), color="grey") +
      geom_point(size=4) +
      coord_flip() +
      theme_light() +
      theme(
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        title = element_text(size=16),
        axis.text = element_text(size=14),
        legend.text = element_text(size=14),
        legend.position = "none",
        aspect.ratio = c(1),
        axis.title.y = element_blank()
      ) +
      labs(y="Activity (z-score)") +
      scale_color_manual(values = rwth_color(c("magenta", "green")))
  } else if (length(unique(activity_df()$id)) > 1){
    mat = activity_df() %>%
      filter(class == "pathway") %>%
      select(id,feature, activity) %>%
      spread(feature, activity) %>%
      data.frame(row.names=1)
    
    myBreaks = c(seq(min(mat), 0, length.out=ceiling(100/2) + 1), 
                 seq(max(mat)/100, max(mat), length.out=floor(100/2)))
    myPalette = colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(100)
    colorFunc = col_bin(myPalette, bins = rescale(myBreaks))
    d3heatmap(mat,  colors=colorFunc)
  }
})

output$dorothea_scores_single_experiment = renderPlot({
  if (length(unique(activity_df()$id)) == 1) {
    activity_df() %>%
      filter(class == "tf") %>%
      mutate(effect = factor(sign(activity))) %>%
      group_by(effect) %>%
      top_n(selected_top_n(), abs(activity)) %>%
      ungroup() %>%
      ggplot(aes(x=fct_reorder(feature, activity), y=activity, color=effect)) +
      geom_segment(aes(x=fct_reorder(feature, activity), 
                       xend=fct_reorder(feature, activity), 
                       y=0, 
                       yend=activity), color="grey") +
      geom_point(size=4) +
      coord_flip() +
      theme_light() +
      theme(
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        axis.ticks.y = element_blank(),
        title = element_text(size=16),
        axis.text = element_text(size=14),
        legend.text = element_text(size=14),
        legend.position = "none",
        aspect.ratio = c(1),
        axis.title.y = element_blank()
      ) +
      labs(y="Activity (z-score)") +
      scale_color_manual(values = rwth_color(c("magenta", "green")))
  } else if (length(unique(activity_df()$id)) > 1){
    mat = activity_df() %>%
      filter(class == "tf") %>%
      select(id,feature, activity) %>%
      spread(feature, activity) %>%
      data.frame(row.names=1)
  
    myBreaks = c(seq(min(mat), 0, length.out=ceiling(100/2) + 1), 
                 seq(max(mat)/100, max(mat), length.out=floor(100/2)))
    myPalette = colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(100)
    colorFunc = col_bin(myPalette, bins = rescale(myBreaks))
    d3heatmap(mat,  colors=colorFunc)
    }
})

output$scores_df = DT::renderDataTable({
  activity_df() %>%
    select(-resource) %>%
    mutate(feature = as_factor(feature),
           class = as_factor(class),
           confidence = as_factor(confidence)) %>%
    DT::datatable(., escape = F, selection = list(target = "none"),
                  filter = "top",
                  option = list(scrollX = TRUE, autoWidth=T)) %>%
    formatSignif(which(map_lgl(select(activity_df(), -resource), is.numeric)))
})

output$download_single_experiment = downloadHandler(
  filename = function() {
    paste0(selected_id(), "_pathway_tf_scores.csv")
  },
  content = function(file) {
    activity_df() %>%
      write_delim(., file)
  })

output$download_entire_resource = downloadHandler(
  filename = function() {
    "entire_resource.csv"
  },
  content = function(file) {
    activities_df %>%
      select(-resource) %>%
      write_delim(., file)
  })

