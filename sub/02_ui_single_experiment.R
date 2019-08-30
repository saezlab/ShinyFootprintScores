tabPanel(
  title = "Query single experiment",
  icon = icon("search"),
  sidebarPanel(
    h4("Analysis of a specific experiment"),
    p("Select CREEDS experiment or GEO accession ID and explore the corresponding TF and pathway activities. Browse the tab", em("Experiments"), "for associated metadata"),
    hr(),
    awesomeRadio(inputId = "select_query_type", 
                 label = "Query CREEDS or GEO ID", 
                 choices = c("CREEDS", "GEO"), selected = "CREEDS", 
                 inline = TRUE) %>% 
      helper(content = "creeds_geo_id"),
    uiOutput("select_query"),
    hr(),
    p("These widgets support exploration of TF activities."),
    checkboxGroupButtons(inputId = "select_conf", 
                         label = "Select TF confidence level:", 
                         choices = c("A", "B", "C", "D", "E"), 
                         selected = c("A", "B"),
                         checkIcon = list(yes = icon("ok", lib = "glyphicon"), 
                                          no = icon("remove", lib = "glyphicon"))) %>%
      helper(content = "confidence_levels"),
    conditionalPanel(
      condition = "input.select_query_type == 'CREEDS'",
      sliderInput(inputId = "select_top_n", label = p("Show top", em("n"), "hits"),
                  min = 1, max = 50, value = 10, step = 1) %>%
        helper(content = "show_top_n_hits")
    ),
    hr(),
    downloadButton("download_single_experiment", "Download experiment(s)") %>%
      helper(content = "download_experiments"),
    p(""),
    p(tags$i(`class`="fas fa-exclamation-triangle", `style`="color:red"), 
      span("File size: ~120 MB", style = "color:red")),
    downloadButton("download_entire_resource", "Download entire resource") %>%
      helper(content = "download_everything")
  ),
  mainPanel(
    h4("Metadata"),
    DT::dataTableOutput("meta_df") %>%
      helper(content = "meta"),
    hr(),
    h4("Pathway activity"),
    conditionalPanel(
      condition = "input.select_query_type == 'CREEDS'",
      plotOutput("progeny_scores_single_experiment_volcano")
    ),
    conditionalPanel(
      condition = "input.select_query_type == 'GEO'",
      d3heatmapOutput("progeny_scores_single_experiment_heatmap") %>%
        helper(content = "simple_heatmaps")
    ),
    hr(),
    h4("TF activity"),
    conditionalPanel(
      condition = "input.select_query_type == 'CREEDS'",
      plotOutput("dorothea_scores_single_experiment_volcano")
    ),
    conditionalPanel(
      condition = "input.select_query_type == 'GEO'",
      d3heatmapOutput("dorothea_scores_single_experiment_heatmap")
    ),
    hr(),
    h4("Raw activtiy scores"),
    DT::dataTableOutput("scores_df")
  )
)