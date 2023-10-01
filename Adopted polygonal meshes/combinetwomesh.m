function [node,elem] = combinetwomesh(node1,elem1,node2,elem2,interfacetype)
%UNTITLED combine two meshes 

bd1 = setboundary(node1,elem1);
% bdnode1 = node1(bdnode1Idx(:),:);
% nbd1 = size(bdnode1Idx,1);

bd2 = setboundary(node2,elem2);


%% Merge subdivions     find repeated points, and modify elem2
% get connection number of the second mesh
N1 = size(node1,1);  N2 = size(node2,1);
Idx2 = (1:N2)+N1;
v1 = unique(bd1.bdNodeIdx);  v2 = unique(bd2.bdNodeIdx);
for i = (v1(:))'  % only loop for the nodes on the boundaries of both domains
    kk = 0;
    for j = (v2(:))'
        kk = kk + 1;
        distance = norm(node1(i,:) - node2(j,:));
        if distance < 1e-8  &&  Idx2(j)>=i
            Idx2(j) = i;
        end
    end
end
is2 = (Idx2>N1); % find only in elem2
Idx2(is2) = (1:sum(is2))+N1; % connection number
% update node2 and elem2
node2 = node2(is2,:);
elem2 = cellfun(@(index) Idx2(index), elem2, 'UniformOutput',false);

node = [node1; node2];

%% Dealing with hanging points

switch interfacetype
    case 1
        interfaceIf = (abs(node(:,2)-0.5)<1e-8)&(-1e-8<node(:,1))& (node(:,1)<0.5+1e-8) ;
    case 2
        interfaceIf = (abs(node(:,1)-0.5)<1e-8)&(node(:,2)-0.5>-1e-8);
    case 3
        interfaceIf = (abs(node(:,1)-0.5)<1e-8)&(-1e-8<node(:,2))& (node(:,2)<0.5+1e-8) |...
                      (abs(node(:,2)-0.5)<1e-8)&(node(:,1)-0.5>-1e-8) ;
    otherwise
        disp('没有选择界面类型，程序终止');
end
interfacenode = node(interfaceIf,:); % = node(interfaceIdx,:);
interfacenodeIdx = find(interfaceIf);

elem = vertcat(elem1,elem2);
nelem = size(elem,1);

nifnode = size(interfacenode,1);

for i = 1:nifnode
    for j = 1:nelem
        isOnBoundary = inpolygon(round(interfacenode(i,1),6), round(interfacenode(i,2),6),...
                       round(node(elem{j}, 1),6), round(node(elem{j}, 2),6));
        % set accuracy is 1e-6
        if isOnBoundary
            if ~any(elem{j} == interfacenodeIdx(i))  % then it must be hang point
%%
                comIdx = intersect(elem{j},interfacenodeIdx);
                              
                [nearestIndices,~] = nearestPoints([node(comIdx,:);interfacenode(i,:)],interfacenode(i,:));
                A = comIdx(nearestIndices);
                A1 = A(1);
                A2 = A(2);
                IdxA1 = find(elem{j} == A1);
                IdxA2 = find(elem{j} == A2);

                % 判断是否有A1 和 A2
                hasAdjacentA1AndA2 = ~isempty(IdxA1) & ~isempty(IdxA2);

                % 要插入的数字
                numberToInsert = interfacenodeIdx(i);
%%
                % 判断是否需要插入数字 interfacenodeIdx(i)
                if hasAdjacentA1AndA2
                    % 找到 A1 和 A2 的位置
                    if (IdxA1(1) == 1 && IdxA2(end) == numel(elem{j})) || (IdxA2(1) == 1 && IdxA1(end) == numel(elem{j}))
                        % A1 在首，A2 在尾，或者 A2 在首，A1 在尾，将 interfacenodeIdx(i) 添加到数组末尾
                        elem{j} = [elem{j}, numberToInsert];
                    else
                        % 在 A1 和 A2 之间插入 interfacenodeIdx(i)
                         insertIndex = min([IdxA1, IdxA2]) + 1;
                         elem{j} = [elem{j}(1:insertIndex-1), numberToInsert, elem{j}(insertIndex:end)];
                    end
                end
            end
        end
    end
end

end