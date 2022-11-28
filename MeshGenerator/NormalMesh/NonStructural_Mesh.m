%% initial mesh
box = [0, 1, 0, 1];
h = 0.05;
[node,elem] = squaremesh(box,h);   % or using squarequadmesh
% You also can using distmesh to generate initial mesh
% fd=inline('drectangle(p,-1,1,-1,1)','p');
% box=[-1,-1;1,1];
% fix=[-1,-1;-1,1;1,-1;1,1];
% [node,elem,~,~]=distmesh2d(fd,@huniform,0.2,box,fix,1);

%% rand mesh
% diameter
NT = size(elem,1);
if ~iscell(elem) % transform to cell
    elem = mat2cell(elem,ones(NT,1),length(elem(1,:)));
end
diameter = cellfun(@(index) max(pdist(node(index,:))), elem);
% random perturbation
xrand = sin(2*pi*node(:,1)).*sin(2*pi*node(:,2));
yrand = xrand;
% width = 4;
% xrand = 2*width*(xrand-min(xrand))/(max(xrand)-min(xrand)) - width;
% yrand = 2*width*(yrand-min(yrand))/(max(yrand)-min(yrand)) - width;
% shift length
% tc = 0.1; hmax = max(diameter);
% xs = xrand*hmax/2;
% ys = yrand*hmax/2;

tc = 0.1;
xs = xrand; ys = yrand;
node = node + tc*[xs, ys];
showmesh(node,elem);

