function findedge(node,elem,varargin)
%Findedge highlights edges

% varargin: input interfaceData to draw a line on interface
% Y.Xiong at 12.Nov.22

hold on

NT = size(elem,1);
if ~iscell(elem) % transform to cell
    elem = mat2cell(elem,ones(NT,1),length(elem(1,:)));
end

% -------- edge matrix -------
shiftfun = @(verts) [verts(2:end),verts(1)];
T1 = cellfun(shiftfun, elem, 'UniformOutput', false);
v0 = horzcat(elem{:})'; % the starting points of edges
v1 = horzcat(T1{:})'; % the ending points of edges
totalEdge = sort([v0,v1],2);
[i,j,s] = find(sparse(totalEdge(:,2),totalEdge(:,1),1));
edge = [j,i];
% bdEdge = edge(s==1,:);

% ------- range ---------
range = find(s==1); % boundary edges


% ------ edge index ------
if isempty(varargin)
    midEdge = (node(edge(range,1),:)+node(edge(range,2),:))/2;
    plot(midEdge(:,1),midEdge(:,2),'s','LineWidth',1,'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.6 0.5 0.8],'MarkerSize',20);
    text(midEdge(:,1)-0.025,midEdge(:,2),int2str(range), ...
    'FontSize',12,'FontWeight','bold','Color','k');
else
    interfaceNodeIdx = varargin{1}.nodeIdx;
    h = line([node(interfaceNodeIdx,1)'; node(circshift(interfaceNodeIdx,-1),1)'],...
             [node(interfaceNodeIdx,2)'; node(circshift(interfaceNodeIdx,-1),2)'],...
             'LineWidth',2,'Color','r');
     set(h,'Linewidth',3);
        
end
