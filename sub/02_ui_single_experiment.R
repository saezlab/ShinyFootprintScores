tabPanel(
  title = "Query single experiment",
  icon = icon("search"),
  sidebarPanel(
    h4("Analysis of a specific experiment"),
    p("Select experiment or accession ID and explore the corresponding TF and pathway activities. Browse the tab", em("Experiments"), "for associated meta data"),
    hr(),
    awesomeRadio(inputId = "select_query_type", 
                 label = "Query CREEDS' or GEO's ID", 
                 choices = c("CREEDS", "GEO"), selected = "CREEDS", 
                 inline = TRUE),
    uiOutput("select_query"),
    hr(),
    p("These widgets support exploration of TF activities."),
    checkboxGroupButtons(inputId = "select_conf", 
                         label = "Select TF confidence level:", 
                         choices = c("A", "B", "C", "D", "E"), 
                         selected = c("A", "B"),
                         checkIcon = list(yes = icon("ok", lib = "glyphicon"), 
                                          no = icon("remove", lib = "glyphicon"))),
    conditionalPanel(
      condition = "input.select_query_type == 'CREEDS'",
      sliderInput(inputId = "select_top_n", label = p("Show top", em("n"), "hits"),
                  min = 1, max = 50, value = 10, step = 1)
    ),
    hr(),
    downloadButton("download_single_experiment", "Download experiment(s)"),
    p(""),
    p(tags$i(`class`="fas fa-exclamation-triangle", `style`="color:red"), 
      span("Very large file (~120 MB)", style = "color:red")),
    downloadButton("download_entire_resource", "Download entire resource")

  ),
  mainPanel(
    DT::dataTableOutput("meta_df"),
    hr(),
    h5("Pathway activity"),
    plotOutput("progeny_scores_single_experiment"),
    h5("TF activity"),
    plotOutput("dorothea_scores_single_experiment"),
    hr(),
    DT::dataTableOutput("scores_df")
  )
)