## NetLandslide

Please cite this code as.....

## Contents: 
This package creates a geospatial network using poisson sampling and delaunay Triangulation. It takes information that you supply and outputs a multilayer network. This multilayer network can then be run into a community detection algorithm, specifically GenLouvain (CITE/LINK), with specifications that you provide to output communities. In this package, there is code to run the community detection algorithm, as well as code to quantify the results of the communities.

## Sample Code
This is for a multilayer network consisting of velocity and slope, which has been proven to effectively find the where of a landslide.

'''
multilayer_network(disp, dem, area, n, grid, l, time)
   #disp is a RasterStack consisting of *l* layers, where each layer is a displacement map
   #dem is your digital elevation map for the area
   #area is the extent in which you will be looking at
   #n is the mesh/run
   #grid is your grid consisting of nodes and edges
   #l is number of layers you have
   #time is an array consisting of the time between each layer
'''




