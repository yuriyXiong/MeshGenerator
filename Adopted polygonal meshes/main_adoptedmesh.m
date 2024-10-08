function [node,elem] = main_adoptedmesh(h)
% Example-1
% box = [x1,x2]*[y1,y2];
% rect = [2 x1 x2 y1 y1 1 0;
%         2 x2 x2 y1 y2 1 0;
%         2 x2 x1 y2 y2 1 0;
%         2 x1 x1 y2 y1 1 0]';


% triangle
% gL = [2    0     0    1     0.5   1     0;
%      2     0     0.5  0.5   0.5   1     0;
%      2    0.5    0.5  0.5   1     1     0;
%      2    0.5    0    1     1     1     0]';
% 
% [pp,~,tt] = initmesh(gL,'hmax',h); 
% pp = pp'; tt = tt(1:3,:)';
% 
% 
% node1 = pp;
% elem1 = matrix2_cell(tt);

% 
box1 = [0,0.5;0.5,1];
fd=inline('drectangle(p,0,0.5,0.5,1)','p');
fixed=[0,0.5;0.5,0.5;0.5,1;0,1];
[p,t,~,~]=distmesh2d(fd,@huniform,h,box1,fixed,1);

node1 = p;
elem1 = matrix2_cell(t);


[node2, elem2] = PolyMesher(@RectangleDomain,200,fix(sqrt(2)/(3*h^2)));% Vronoi plygon

% node = [node1;node2];

[node,elem] = combinetwomesh(node1,elem1,node2,elem2,1);


box3 = [0.5, 1, 0.5, 1];
[node3,elem3] = squaremesh(box3, h);

[node,elem] = combinetwomesh(node, elem, node3, elem3, 2);

box4 = [0.5, 1, 0, 0.5];
[node4,elem4] = nonConvexMesh(box4,fix(1/(2*h)));

[node,elem] = combinetwomesh(node, elem, node4, elem4, 3);

% end
showmesh(node,elem);




