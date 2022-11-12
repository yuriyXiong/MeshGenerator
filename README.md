# InterfaceMesh: generate mesh with a line-type interface
##  excample 
[node, elem, interface] = PolyMesher_interfaceline(@RectangleDomain, 50, 100);

% 50,100 denotes number of element and iterations, respectively.

showmesh(node, elem);

findnode(node);

findelem(node, elem);

findedge(node, elem, interface);


