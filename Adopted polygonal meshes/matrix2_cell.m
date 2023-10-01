function a = matrix2_cell(elem)
N = size(elem,1);
a=cell(N,1);
%NT = size(elem,1);
% if ~iscell(elem) % transform to cell
%     elem = mat2cell(elem,ones(NT,1),length(elem(1,:)));
% end
for i = 1:N
    a{i} = elem(i,:);
end
end

