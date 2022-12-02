#' Slope Edge Weights
#'
#' Computes weights for edges using .tif files fo displacement
#' and using a vector with time between each .tif file
#'
slope_edge <- function(dem, edges, grid, tsteps){
  # delta_time is a vector with time difference between each layer
  # edges is edge list
  # tsteps is number of layers

##DEM
  #Spatial Grid with elevation values extracted for each grid point using a mean with buffer radius
  sp_grid <- raster::extract(dem, grid, buffer = 150, fun = mean, sp = TRUE)

  #Data table
  spdt <- data.table(ID = row.names(sp_grid), sp_grid@data)
  names(sp_grid) <- "dem"

##Elevation Difference - Weight
  elev_diff <- array(NA, dim = c(nrow(edges),1))
  for (i in 1:nrow(edges)) {
    a <- edges[i,1]
    b <- edges[i,2]
    # Retrieve ELEV values for each node
    elev_a <- spdt[ID == a, dem]
    elev_b <- spdt[ID == b, dem]
    elev_diff[i] <- abs(elev_a - elev_b)
  }

##EDGE DISTANTCE
  edge_dist <- array(NA, dim = c(nrow(edges),1))
  grid_coord <- coordinates(sp_grid)
  for (i in 1:nrow(edges)) {
    a <- edges[i,1]
    b <- edges[i,2]
    edge_dist[i] <- pointDistance(grid_coord[a,],grid_coord[b,], longlat=FALSE)
  }

##Edge Slope
  node_slope <- elev_diff/edge_dist

##Return Results
  return(node_slope) #E x 1 matrix
}
