tabPanel(
  title = "Welcome",
  icon = icon("home"),
  #titlePanel("Welcome to the CKD-Application"),
  sidebarPanel(
    includeMarkdown("inst/landingpage_sidebar.md")
  ),
  mainPanel(
    includeMarkdown("inst/landingpage.md")
  )
)