# UI
source("sub/global.R")
ui = function(request) {
  fluidPage(
    useShinyjs(),
    #tags$head(includeScript("google-analytics.js")),
    navbarPage(
      id = "menu", 
      title = div(img(src="logo_saezlab.png", width="25", height="25"),
                  "Resource of signaling activities"),
      windowTitle = "Resource of signaling activities",
      collapsible=T,
      source("sub/01_ui_welcome.R")$value,
      source("sub/02_ui_single_experiment.R")$value,
      source("sub/03_ui_multiple_experiments.R")$value,
      source("sub/04_ui_experiments.R")$value,
      # source("sub/05_ui_piano.R")$value,
      # source("sub/06_ui_dorothea.R")$value,
      # source("sub/07_ui_dvd.R")$value,
      footer = column(12, align="center", "Resource of signaling activities (2019)")
      ) # close navbarPage
    ) # close fluidPage
}