#'Create a multilayer, undirected, weighted network
#'
#'
multilayer_network <- function(edges, weights,...){

  ##NETWORK
  net <- graph_from_edgelist(as.matrix(edges), directed = FALSE)
  #Remove loops
  net <<- simplify(net, remove.multiple = F, remove.loops = T)

  ##Weights
  #Edge Matrix
  weights <- signif(weights, 3)
  edgemat <- cbind(edges, weights)
  #Save
  return(edgemat)

}
