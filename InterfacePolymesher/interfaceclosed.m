function [node,elem,node1,elem1,node22,elem2,interfaceData] = interfaceclosed(g1,g2,h)
%interfacePolyMesher Generate interface-fitted polygonal mesh for interface problems
%%  Example-1
%    [node,elem] = interfacePolyMesher(g1,g2)
%    g1: the decomposed geometry matrix for the exterior domain
%    g2: the decomposed geometry matrix for the interior domain
%    
%    options: plot is true or false
%             refineTimes is the number of refinements
%
% Note: only need to provide edges in counterclockwise order  
%% Example-2
% g1 = rectangleDomain(-1,1,-1,1);
% g2 = rectangleDomain(-0.5,0.5,-0.5,0.5);
% [node,elem,node1,elem1,node2,elem2,interfaceData] = interfaceclosed(g1,g2,0.5);

% Copyright (C)  Terence Yu
% Y.Xiong modified at 21.Nov.2022.


%% Decomposed geometry matrix
if isempty(g1)
    % rectangle: [a b c d]
    a = -2; b = 2; c = -2; d = 2;
    g1 = zeros(10,4);
    g1(1,:) = 2;  % 2 for line
    g1(2,:) = [b, b, a, a];       % x: starting points
    g1(3,:) = circshift(g1(2,:),-1); % x: ending points
    g1(4,:) = [c, d, d, c];       % y: starting points
    g1(5,:) = circshift(g1(4,:),-1); % y: ending points
    g1(6,:) = 1;   % label of subdomain on the left
    g1(7,:) = 0;   % label of subdomain on the right
else

end
if  isempty(g2)
    % unit circle
    g2 = zeros(10,4);
    g2(1,:) = 1;  % 1 for circle
    g2(2,:) = [-1, 0, 1, 0];         % x: starting points
    g2(3,:) = circshift(g2(2,:),-1); % x: ending points
    g2(4,:) = [0, -1, 0, 1];         % y: starting points
    g2(5,:) = circshift(g2(4,:),-1); % y: ending points
    g2(6,:) = 0;  % label of subdomain on the left
    g2(7,:) = 1;  % label of subdomain on the right
    g2(8,:) = 0;  % center x
    g2(9,:) = 0;  % center y
    g2(10,:) = 1; % radius
end

%% Mesh of Domain 1
[nr1,nc1] = size(g1); [nr2,nc2] = size(g2);
nrow = max(nr1,nr2);  ncol = nc1 + nc2;
g = zeros(nrow, ncol);
g(1:nr1,1:nc1) = g1;
g(1:nr2,nc1+1:ncol) = g2;
[p,e1,t] = initmesh(g,'hmax',h,'Hgrad',1.1);

pp1 = p';   tt1 = t(1:3,:)';
[node1,elem1] = dualMesh(pp1,tt1);
bd1 = setboundary(node1,elem1);

%% Mesh of Domain 2
g2(6,:) = 1;  g2(7,:) = 0;  % modify the orientation
g = g2;
[p,e2,t] = initmesh(g,'hmax',h,'Hgrad',1.1);

pp2 = p';   tt2 = t(1:3,:)';
[node2,elem2] = dualMesh(pp2,tt2);
node22 = node2;
bd2 = setboundary(node2,elem2);

%% Merge subdivions
% get connection number of the second mesh
N1 = size(node1,1);  N2 = size(node2,1);
Idx2 = (1:N2)+N1;
v1 = unique(bd1.bdNodeIdx);  v2 = unique(bd2.bdNodeIdx);
for i = (v1(:))'  % only loop for the nodes on the boundaries of both domains
    for j = (v2(:))'
        distance = norm(node1(i,:) - node2(j,:));
        if distance < 1e-8  &&  Idx2(j)>=i
            Idx2(j) = i;
        end
    end
end
is2 = (Idx2>N1);
Idx2(is2) = (1:sum(is2))+N1; % connection number
% update node2 and elem2
node2 = node2(is2,:);
elem2 = cellfun(@(index) Idx2(index), elem2, 'UniformOutput',false);
% merge
node = [node1; node2];
elem = vertcat(elem1,elem2);


%% interfacedata
bdStruct1 = setboundary(node,elem1);
bdStruct2 = setboundary(node,elem2);
bdnodeIdx = intersect(bdStruct1.bdNodeIdx,bdStruct2.bdNodeIdx);
bdnode = node(bdnodeIdx,:);
interfaceData.nodeIdx = bdnodeIdx; % node index
interfaceData.node = bdnode;


%% plot the triangle and polygon
options.facecolor = 'y';

figure, 
subplot(1,2,1),
showmesh(pp1,tt1); hold on
pause(1);
showmesh(pp2,tt2,options); hold off
pause(1);
subplot(1,2,2),
showmesh(node1,elem1); hold on  
pause(1);
showmesh(node,elem2,options); hold off
