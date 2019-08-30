tabPanel(
  title = "Study multiple experiments (inverse)",
  icon = icon("line-chart"),
  sidebarPanel(
    h4("Study multiple experiments (inverse)"),
    p("Select a pathway/TF of interest and find perturbation experiments in which the activity of the corresponding pathway/TF lies in a given range."),
    p(tags$i(`class` = "far fa-lightbulb"), tags$em("Example:"), "For which human disease experiments the activity of NFkB is in between 5 and 7?"),
    hr(),
    checkboxGroupButtons(inputId = "select_resource_multi_expr_inverse", 
                      label = "Select a resource:", 
                      choices = c(`<i class="fas fa-capsules"></i> Drug perturbations` = "single drug perturbation", 
                                  `<i class="fas fa-dna"></i> Gene perturbations` = "single gene perturbation", 
                                  `<i class="fas fa-user-md"></i> Disease signatures` = "disease signatures"), 
                      justified = TRUE,
                      direction = "vertical",
                      selected = "disease signatures"),
    radioGroupButtons(inputId = "select_organism_multi_expr_inverse", 
                         label = "Select organism:", 
                         choices = c(`<i class="fas fa-shoe-prints"></i> Human` = "human", 
                                     `<i class="fas fa-paw"></i> Mouse` = "mouse"), 
                         justified = TRUE,
                         selected = "human"),
    uiOutput("select_feature_inverse"),
    uiOutput("feature_range") %>%
      helper(content = "activity_range")
    
  ),
  mainPanel(
    DT::dataTableOutput("highest_scores")
  )
)