## NetLandslide

Please cite this code as.....

## Contents: 
This package creates a geospatial network using poisson sampling and delaunay Triangulation. It takes information that you supply (ex. rasters of DEMs and displacement time series) and outputs a multilayer network. This multilayer network can then be run into a community detection algorithm, specifically GenLouvain (CITE/LINK), with specifications that you provide to output communities. In this package, there is code to run the community detection algorithm as well.

This network contains three types of information:
<ul>
<li> node -- represents a patch of area
<li> edges -- connects nodes, or patches of areas, based on nearest neighbors
<li> weights -- connects information about the system to the edges 
</ul>

Community detection will then take this network and detect clusters of nodes (patches of areas) that are similar to each other, close together, and whose weights are above average.

## Plot
![alt text](https://github.com/vddesai-97/netLandslide/blob/main/src/ExploratoryPlot.png "Exploratory Plot")
## Inputs:
<ul>
<li> DEM 
<li> Time-series displacement maps with <i>T</i> layers
</ul>

The DEM and displacment maps need to be rasters and have the same extent and projection. I normally use <i>utm</i> coordinates since displacement is normally in meters.

## Steps to creating a multilayer network:
<ol>
<li> Using a DEM map as input, <i>gridbyDEM.R</i> returns a <i>grid_*</i> and <i>edges_*</i> list by using poisson disk sampling and then removing boundary effects.
<li> Calculate the weights of each edge -- relative velocity and slope -- using <i>vel_weights.R</i> and <i>slope_weights.R</i>
<li> Input the weights into <i>multilayer_network.R</i> that will output the network as an edge list, <i>edgemat</i>.
  <li> Run the edgelist into <i>multilayerCommDet.m</i> which runs in Matlab. This outputs <i>CA</i>, a N X T matrix where each column represents a time layer and each row corresponds to a node.
</ol>

## Outputs:
<ul>
<li> <i>grid_*</i> is a spatial grid with coordinates for each node <i>n</i> for a total of <i>N</i> nodes.
<li> <i>edges_*</i> is an E x 2 matrix, where each row is some edge <i>e</i> and [e,1] and [e,2] are the node IDs for that edge connection
<li> <i>avg_vel</i> is an E x T matrix where each column corresponds to a time layer <i>t</i>in the time-series displacement maps
<li> <i>node_slope</i> is an E X 1 matric where for each edge, the computed slope is calculated
<li> <i>edgemat</i> returnes an E X (2+T) matrix corresponding to the multilayer network, where [e,1] and [e,2] are the node IDS and [e, 2+t] is the edge weights for time layer <i>t</i>
<li> <i>CA</i> is a N X T matrix, where for each [n,t], the community ID is listed
</ul>




