# UI
source("sub/global.R")
ui = function(request) {
  fluidPage(
    useShinyjs(),
    tags$head(includeScript("google-analytics.js")),
    navbarPage(
      id = "menu", 
      title = div(img(src="logo_saezlab.png", width="25", height="25"),
                  "Resource of footprint scores"),
      windowTitle = "Resource of footprint scores",
      collapsible=T,
      source("sub/01_ui_welcome.R")$value,
      source("sub/02_ui_single_experiment.R")$value,
      source("sub/03_ui_multiple_experiments.R")$value,
      source("sub/04_ui_multiple_experiments_inverse.R")$value,
      source("sub/05_ui_experiments.R")$value,
      footer = column(12, align="center", "Resource of footprint scores (2019)")
      ) # close navbarPage
    ) # close fluidPage
}