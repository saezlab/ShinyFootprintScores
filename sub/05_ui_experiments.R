tabPanel(
  title = "Experiments",
  icon = icon("database"),
  #titlePanel("Annotated Experiments"),
  sidebarPanel(
    h4("Metadata"),
    p("This is the metadata associated with the experimental studies of this 
      resource (provided by", a("CREEDS", href = "http://amp.pharm.mssm.edu/CREEDS/", target="_blank"), "). Browse this table by selecting your resource and organism(s) of 
      interest and the column specific search fields. If required also sample 
      annotations can be displayed."),
    hr(),
    radioGroupButtons(inputId = "select_resource", 
                         label = "Select a resource:", 
                         choices = c(`<i class="fas fa-capsules"></i> Drug perturbations` = "single drug perturbation", 
                                     `<i class="fas fa-dna"></i> Gene perturbations` = "single gene perturbation", 
                                     `<i class="fas fa-user-md"></i> Disease signatures` = "disease signatures"), 
                         justified = TRUE,
                         direction = "vertical",
                         selected = "single drug perturbation"),
    checkboxGroupButtons(inputId = "select_organism", 
                      label = "Select organism:", 
                      choices = c(`<i class="fas fa-shoe-prints"></i> Human` = "human", 
                                  `<i class="fas fa-paw"></i> Mouse` = "mouse"), 
                      justified = TRUE,
                      selected = "human"),
    radioGroupButtons(inputId = "include_sample_ids", 
                      label = "Show sample IDs?", 
                      choices = c("Yes", "No"),
                      selected = "No",
                      checkIcon = list(yes = icon("ok", lib = "glyphicon"), 
                                       no = icon("remove", lib = "glyphicon"))) %>%
      helper(content = "showing_sample_ids"),
    hr(),
    downloadButton("download_meta", "Download all metadata") %>%
      helper(content = "download_meta")
  ),
  mainPanel(
    DT::dataTableOutput("anno_df")
  )
  
  
)
