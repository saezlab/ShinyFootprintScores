tabPanel(
  title = "Study multiple experiments",
  icon = icon("line-chart"),
  sidebarPanel(
    h4("Study multiple experiments"),
    p("Select a resource and an organism and explore pathway/TF activities across experiments with similiar objective/experimental design."),
    p(tags$i(`class` = "far fa-lightbulb"), tags$em("Example:"), "Show me pathway and TF activities of all Hepatitis C studies in human."),
    hr(),
    radioGroupButtons(inputId = "select_organism_multi_expr", 
                      label = "Select organism:", 
                      choices = c(`<i class="fas fa-shoe-prints"></i> Human` = "human", 
                                  `<i class="fas fa-paw"></i> Mouse` = "mouse"), 
                      justified = TRUE,
                      selected = "human"),
    radioGroupButtons(inputId = "select_resource_multi_expr", 
                      label = "Select a resource:", 
                      choices = c(`<i class="fas fa-capsules"></i> Drug perturbations` = "single drug perturbation", 
                                  `<i class="fas fa-dna"></i> Gene perturbations` = "single gene perturbation", 
                                  `<i class="fas fa-user-md"></i> Disease signatures` = "disease signatures"), 
                      justified = TRUE,
                      direction = "vertical",
                      selected = "disease signatures"),
    uiOutput("select_feature") %>%
      helper(content = "select_features"),
    conditionalPanel(
      condition = "input.select_resource_multi_expr == 'disease signatures'",
      uiOutput("select_disease_set") %>%
        helper(content = "disease_sets")
    )
    
  ),
  mainPanel(
    h4("Metadata"),
    DT::dataTableOutput("meta") %>% withSpinner(),
    hr(),
    h4("Pathway activities"),
    d3heatmapOutput("pathway_heatmaps") %>%
      withSpinner() %>%
      helper(content = "pathway_heatmaps"),
    hr(),
    h4("TF activities"),
    d3heatmapOutput("tf_heatmaps") %>% withSpinner(),
    hr(),
    h4("Raw pathway activtiy scores"),
    DT::dataTableOutput("pathway_table") %>% withSpinner(),
    hr(),
    h4("Raw TF activity scores"),
    DT::dataTableOutput("tf_table") %>% withSpinner()
  )
)