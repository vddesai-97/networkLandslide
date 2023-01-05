## NetLandslide

Please cite this code as.....

## Contents: 
This package creates a geospatial network using poisson sampling and delaunay Triangulation. It takes information that you supply (ex. rasters of DEMs and displacement time series) and outputs a multilayer network. This multilayer network can then be run into a community detection algorithm, specifically GenLouvain (CITE/LINK), with specifications that you provide to output communities. In this package, there is code to run the community detection algorithm as well.

This network contains three types of information:
<ul>
<li> nodes -- represents a patch of area
<li> edges -- connects nodes, or patches of areas, based on nearest neighbors
<li> weights -- connects information about the system to the edges 
</ul>

Community detection will then take this network and detect clusters of nodes (patches of areas) that are similar to each other, close together, and whose weights are above average.

## Steps to creating a multilayer network:
1. Using a DEM map as input, <i>gridbyDEM.R</i> returns a grid and edge list by using poisson disk sampling and then removing boundary effects.
<ul>
<li> grid contains points and the coordinates of those points
<li> edge list is an E x 2 matrix where each row contans an edge (where the total number of edges is E) and the columns contains the ID of pair of nodes
</ul>
2. Calculate the weights of each edge -- relative velocity and slope -- using <i>vel_weights.R</i> and <i>slope_weights.R</i>
3. Input the weights into <i>multilayer_network.R</i> that will output an edge list, E X (2+T), where each column (<i>2+t</i>) corresponds to a time layer.
4. Run the edgelist into <i>multilayerCommDet.m</i> which runs in Matlab. This outputs a N X T matrix where each column represents a time layer and each row corresponds to a node.


## Plot
![alt text](https://github.com/vddesai-97/netLandslide/blob/main/src/ExploratoryPlot.png "Exploratory Plot")




