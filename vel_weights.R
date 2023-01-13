#' Velocity Edge Weights
#'
#' Computes weights for edges using .tif files fo displacement
#' and using a vector with time between each .tif file
#'
vel_edge <- function(maindir, delta_time, grid, edges, ...){
  # delta_time is a vector with time difference between each layer
  # edges is edge list
  # tsteps is number of layers

##Time Series Displacement
  file <- file.path(maindir,'TimeSeries')
  layers <- length(list.files(file))
  tsteps <<- layers - 1
  #Retrieve Displacement
  for (t in 1:layers) {
    #conversion of file
    disp <- crop(projectRaster(raster::stack(paste(file, '/T_', t,'.tif', sep='')), crs = CRS(utm)), DEM)
    #gaussian smoothing
    disp <- focal(disp, w=gaussian.kernel(sigma=2, n=3), fun=median, na.rm = TRUE, pad = TRUE)*3^2
    #Assign a name to the map in the local environment
    assign(paste('T',(t-1),sep=""), disp, envir = environment())
  }

##Velocity Grid
  for (t in 1:tsteps) {
    #Determine velocity using displacement values and a delta T table
    t0 <- get(paste('T',(t-1),sep=""), envir = environment())
    t1 <- get(paste('T',(t),sep=""), envir = environment()) #t for backward difference
    rel_vel <- (t1-t0)/delta_time[t,]
    #Extract velocity values for each grid point by taking the mean, with a buffer radius
    if(t == 1){
      sp_grid <- raster::extract(rel_vel, grid, buffer = 100, fun = mean, sp = TRUE)
    } else {
      sp_grid <- raster::extract(rel_vel, sp_grid, buffer = 100, fun = mean, sp = TRUE)
    }
  }
  names(sp_grid) <- paste('V', 1:(tsteps), sep ='')

##Velocity Edges
  #Transform to a data table
  spdt <- data.table(ID = row.names(sp_grid), sp_grid@data)

  #Average Velocity
  avg_vel <- array(NA, dim = c(nrow(edges),tsteps))
  for (i in 1:nrow(edges)) {
    a <- edges[i,1]
    b <- edges[i,2]
    avg_vel[i,] <- abs(as.matrix((spdt[spdt$ID == a, 2:(tsteps + 1)] + spdt[spdt$ID == b, 2:(tsteps + 1)])/2))
  }

#Return Results
  return(avg_vel) #E x T matrix
}
