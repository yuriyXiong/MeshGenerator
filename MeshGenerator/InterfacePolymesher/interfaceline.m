function [node, elem, node1, elem1, node2, elem2,interfaceData] = interfaceline(g1,g2,h)
%% Y.Xiong created at 17.Nov.2022
%% You can get a mesh of interface.
% example1:
%  [node,elem,node1,elem1,node2,elem2,interface]=interfaceline([],[],0.2);

% example2:
%   g1 = rectangleDomain(-1,1,0,1);
%   g2 = rectangleDomain(-1,1,-1,0);
%   [node,elem,node1,elem1,node2,elem2,interface]=interfaceline(g1,g2,0.2);

% Notice: maybe the node2 has a problem, because there are coincident
%         points in the interface.


%% initmesh
% pentagon area
if isempty(g1)
    g1 = zeros(10,5);
    g1(1,:) = 2;  % 2 for line
    g1(2,:) = [1-sqrt(0.3), 1, 1, -1, -1]; % x-starting ponints
    g1(3,:) = circshift(g1(2,:),-1); % x: ending points
    g1(4,:) = [-1, -1, 1, 1, 1-sqrt(0.3)];%y-start
    g1(5,:) = circshift(g1(4,:),-1); % y-end
    g1(6,:) = 1;   % label of subdomain on the left
    g1(7,:) = 0;   % label of subdomain on the right
end
[p1,e1,t1] = initmesh(g1,'hmax',h,'Hgrad',1.1);
pp1 = p1';   tt1 = t1(1:3,:)';
[node1,elem1] = dualMesh(pp1,tt1);
    
% Triangle Area
if isempty(g2)
    g2 = zeros(10,3);
    g2(1,:) = 2; % 2 for line
    g2(2,:) = [-1,1-sqrt(0.3),-1]; % x-starting points
    g2(3,:) = circshift(g2(2,:),-1); % x-ending points
    g2(4,:) = [-1,-1,1-sqrt(0.3)]; % y-end
    g2(5,:) =  circshift(g2(4,:),-1);
    g2(6,:) = 1;   % label of subdomain on the left
    g2(7,:) = 0;   % label of subdomain on the right
end

[p2,e2,t2] = initmesh(g2,'hmax',h,'Hgrad',1.1);
pp2 = p2';   tt2 = t2(1:3,:)';
[node2,elem2] = dualMesh(pp2,tt2);



%% Merge subdivions
% get connection number of the second mesh
N1 = size(node1,1);  N2 = size(node2,1);
Idx2 = (1:N2)+N1;
v1 = unique(e1(1:2,:));  v2 = unique(e2(1:2,:));
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
bdnode = intersect(bdStruct1.bdNodeIdx,bdStruct2.bdNodeIdx);

interfaceData.nodeIdx = bdnode; % node index

node2 = [node2;node(bdnode,:)];





%% plot
options.facecolor = 'y';
options.plot = false;
options.refineTimes = 0;
subplot(1,2,1);
showmesh(node, elem1);
hold on
showmesh(node, elem2, options);
pause(1);
findedge(node,elem,interfaceData);
pause(1);
hold off

subplot(1,2,2);
showmesh(node,elem);

end


