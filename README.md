## NetLandslide

Please cite this code as.....

## Contents: 
This package creates a geospatial network using poisson sampling and delaunay Triangulation. It takes information that you supply and outputs a multilayer network. This multilayer network can then be run into a community detection algorithm, specifically GenLouvain (CITE/LINK), with specifications that you provide to output communities. In this package, there is code to run the community detection algorithm as well.

## Steps:
1. Using a DEM, <i>gridbyDEM.R</i> that returns a grid and edge list by using poisson disk sampling and then removing boundary effects.
2. Calculate your edge weights with <i>vel_weights.R</i> and <i>slope_weights.R</i>
3. Input the weights into <i>multilayer_network.R</i> that will output an edge list, E X (2+T), where each column (<i>2+t</i>) corresponds to a time layer.
4. Run the edgelist into <i>multilayerCommDet.m</i> which runs in Matlab. This outputs a N X T matrix where each column represents a time layer and each row corresponds to a node.


## Plot
![alt text](https://github.com/vddesai-97/netLandslide/blob/main/src/ExploratoryPlot.png "Exploratory Plot")




