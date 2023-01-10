#' Code to generate grid based on poisson disk sampling
#'
#' 'generate_poissondisk' returns a grid
#'
#' This will generate a grid of N points based on the area of interest.
#' Implements a newwer version of Bridson's Poisson Disk Sampling fast algorithm.
generate_poissondisk <- function(mindist, k, e, raster_dem, ...){
  #Width and height of the area of interest
  #mindist is the minimum distance (or radius) between samples
  #k is the limit of samples to choose before rejection
  #e is the distance at which to extend

##Define the minimum coordinates, height, and width for the area
  #Bounds of the geophysical map
  box <- extent(raster_dem) + c(-e,e,-e,e) #extending the boundary to remove hte boundary effects from within the AOI
  height <- abs(box[4]-box[3]) #ymax-ymin
  width <- abs(box[2]-box[1])  #xmax - xmin

##Step 0 - Initialize a d-dimensional background grid
  cellsize <- mindist/sqrt(2) #bounded so that each cell will contain at most one sample
  cols <- floor(width/cellsize) #number of columns
  rows <- floor(height/cellsize) #number of rows
  grid <- base::vector('list', length = rows*cols) #background grid
  ordered <- list() #for plotting points

##Step 1 - Select the intial sample, randomly chosen from the domain; Insert into the grid
##and intialize an array of sample indices (or active list)
  #random point that is within the area of interest
  active = list()
  x0 <- dplyr::slice(data.frame(coordinates(raster_dem)),n=1) #coordinates
  #Displace the position by xmin and ymin
  x0 <- c(abs(x0$x - box[1]), abs(x0$y - box[3]))
  i <- floor(x0[1]/cellsize) + 1 #column index
  j <- floor(x0[2]/cellsize) + 1 #row index
  #insert into grid
  grid[[(i+j*cols)-cols]] <- x0
  #initialize active list
  active <- c(active, list(x0))

##Step 2 - While there are active points, pick random points and check k sampling points around it in a
##spherical annulus. If a point is near other points, check the distance and if it's adequately far,
##add it to the active list. If no such points are found, emit the random point from the active list
  #loop until no more active points
  while(length(active) > 0) {
    #choose a random index from the active list
    rand_index <- floor(stats::runif(1, 1, length(active)))
    pos <- active[[rand_index]]
    found <- FALSE #intialize that no points have been found yet

    #generate up to k points
    for(n in 1:k) {

      #choose a random point between r and 2r around the active point
      a <- stats::runif(1, 0, 2*pi)
      m <- stats::runif(1, mindist, 2*mindist)
      x = m*cos(a) + pos[1]
      y = m*sin(a) + pos[2]
      sample <- c(x=x,y=y)
      scol <- floor(sample[1]/cellsize) + 1
      srow <- floor(sample[2]/cellsize) + 1
      #Spatial point for checking to see if it is within the area
      #Need to add xmin and ymin to the points to check if it is within the actual grid
      sample_sp <- SpatialPoints(data.frame(x+box[1], y + box[3]), CRS(utm))

      #Check to see if the sample point is within the appropiate distance
      #If no sample points are found, remove the active point
      #If a sample point is found, add it to the active list
      if(scol > 1 & srow > 1 & scol < cols & srow < rows) { #& !is.na(over(sample_sp, grid_soil))[[1]] ##no longer needed because creating points outside AOI
        keep <- TRUE
        for(i in -1:1){
          for (j in -1:1) {
            ind <- ((scol + i) + (srow + j)*cols)-cols
            nbr <- grid[[ind]]
            #If there is a neighbor
            if(!is.null(nbr)){
              #get the distance
              d <- sqrt((sample[1]-nbr[1])^2 + (sample[2]-nbr[2])^2)
                #could use pointDistance(sample, nbr, FALSE) but may take longer, unsure
              #If distance is too close, then we remove the point
              if(d < mindist){
                keep <- FALSE
              }
            }
          }
        }
        #If the distance is acceptable, then add to the grid and active list
        if(keep){
          found <- TRUE
          grid[[(scol + srow*cols)-cols]] <- sample
          active <- c(active, list(sample))
          ordered <- c(ordered, list(sample))
          break()
        }
      }
    }
    #Remove the active point if no sample points were found
    if(!found){
      active[[rand_index]] <- NULL
    }
  }

  as.data.frame(Reduce(rbind, ordered))

}
