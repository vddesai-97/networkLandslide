#' Create a grid
#'
#' Uses poisson sampling and delaunay triangulation
#' to detemine nodes and edges for the given area.
#' Removes boundary condition as well.
#' Outputs grid and edge list

gridbyDEM <- function(j, area,t,n,... ){
  #j is the minimum distance of seperation between nodes
  #area is name of the DEM file to based the grid off of
  #t is how many layers (or time steps) are we looking at
  #n is the grid number

  ##Poisson Disk
  #distance at which to extend from the original boundary
  e = 500
  #Create grid of points
  grid <- generate_poissondisk(j,k=20, e)
  #Displace the points from (0,0) to xmin and ymin of the area
  box <- extent(DEM) + c(-e,e,-e,e) #amount displaced in the poisson function
  grid$x <- grid$x + box[1]
  grid$y <- grid$y + box[3]

  ##Create SpatialPoints
  #First transform to spatial points
  coordinates(grid) <- ~x+y
  #Assign proper CRS
  proj4string(grid) <- CRS(utm)
  #Properly name the rows of the grid
  row.names(grid) <- 1:length(grid)


  ##Spatial Data Frame for the grid
  aoi_grid <- raster::extract(DEM, grid, buffer = 20, fun = mean, sp = TRUE)


  ##Delauney Triangulation
  coord <- as.data.frame(coordinates(aoi_grid)) #get positions of nodes
  colnames(coord) <- c('x','y')
  deltri <- deldir::deldir(coord$x, coord$y) #perform the algorithm
  edges <- deltri$delsgs[,5:6] #retrieve the edge list based off CRAN package

  ##Removal of Boundary Nodes and Edges
  #Determine the points that are inside the area
  pnts_keep <- sp.na.omit(aoi_grid)
  pnts_removal <- over(aoi_grid, pnts_keep)
  #Retrieve the ID of the points outside of the AOI
  id_rm <- which(is.na(pnts_removal[,1]))
  #Downsize the grid to those points inside the AOI and remove corrsponding edges
  for (i in 1:length(id_rm)) {
    aoi_grid <- aoi_grid[row.names(aoi_grid) != id_rm[i],]
    edges <- subset(edges, edges$ind1 != id_rm[i])
    edges <- subset(edges, edges$ind2 != id_rm[i])
  }
  #Rename the rows of edges and grid since they should be ordered
  row.names(edges) <- 1:nrow(edges)
  row.names(aoi_grid) <- 1:length(aoi_grid)
  #Keep track of the ids of the nodes that were kept
  id_keep <- data.table('ID' = which(!is.na(pnts_removal[,1])))
  #Rename the nodes in the edgelist
  for (i in 1:nrow(edges)) {
    a <- edges[i,1]
    b <- edges[i,2]
    edges[i,1] <- which(id_keep$ID == a)
    edges[i,2] <- which(id_keep$ID == b)
  }

  #Assign labels to the aoi_grid
  assign(paste('grid_',n,sep=""), aoi_grid,envir = .GlobalEnv)
  assign(paste('edges_',n,sep=""), edges,envir = .GlobalEnv)

}
