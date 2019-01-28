tabPanel(
  title = "Study multiple experiments",
  icon = icon("line-chart"),
  sidebarPanel(
    h4("Study multiple experiments"),
    p("Select resource(s) and an organism and explore in which experiments your pathway/TF of interest lies in a given range."),
    p(tags$i(`class` = "far fa-lightbulb"), tags$em("Example:"), "For which human disease experiments the activity of NFkB is in between 5 and 7?"),
    hr(),
    checkboxGroupButtons(inputId = "select_resource_multi_expr", 
                      label = "Select a resource:", 
                      choices = c(`<i class="fas fa-capsules"></i> Drug perturbations` = "single drug perturbation", 
                                  `<i class="fas fa-dna"></i> Gene perturbations` = "single gene perturbation", 
                                  `<i class="fas fa-user-md"></i> Disease signatures` = "disease signatures"), 
                      justified = TRUE,
                      direction = "vertical",
                      selected = "disease signatures"),
    radioGroupButtons(inputId = "select_organism_multi_expr", 
                         label = "Select organism:", 
                         choices = c(`<i class="fas fa-shoe-prints"></i> Human` = "human", 
                                     `<i class="fas fa-paw"></i> Mouse` = "mouse"), 
                         justified = TRUE,
                         selected = "human"),
    uiOutput("select_feature"),
    uiOutput("feature_range")
    
  ),
  mainPanel(
    DT::dataTableOutput("highest_scores")
  )
)