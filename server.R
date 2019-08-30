# SERVER
server = function(input, output, session) {
  source("sub/02_server_single_experiment.R", local=T)
  source("sub/03_server_multiple_experiments.R", local=T)
  source("sub/04_server_multiple_experiments_inverse.R", local=T)
  source("sub/05_server_experiments.R", local=T)
  # hide the loading message
  hide("loading-content", TRUE, "fade")  
  observe_helpers()
}
