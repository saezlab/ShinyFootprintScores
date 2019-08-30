library(shiny)
library(shinyWidgets)
library(tidyverse)
library(cowplot)
library(plotly)
library(gtools)
library(RColorBrewer)
library(scales)
library(DT)
library(shinyjs)
library(d3heatmap)
library(shinyhelper)
library(shinycssloaders)
library(shinyalert)

# load data
annotation_df = readRDS("data/annotation_df.rds")
activities_df = readRDS("data/activities_df.rds")
diseasesets_df = readRDS("data/disease_gene_sets.rds")

# load color palette
rwth_colors_df = get(load("data/misc/rwth_colors.rda"))

# functions
rwth_color = function(colors) {
  if (!all(colors %in% rwth_colors_df$query)) {
    wrong_queries = tibble(query = colors) %>%
      anti_join(rwth_colors_df, by="query") %>%
      pull(query)
    warning(paste("The following queries are not available:",
                  paste(wrong_queries, collapse = ", ")))
  }
  tibble(query = colors) %>%
    inner_join(rwth_colors_df, by="query") %>%
    pull(hex)
}

