function [nearestIndices,nearestpoints] = nearestPoints(points,point)

% 要查找相邻点的参考点
referencePoint = point;

% 计算当前点与其他点的欧氏距离
distances = sqrt(sum((points - referencePoint).^2, 2));

% 找到距离�?近的两个点的索引
[~, sortedIndices] = sort(distances);

% 跳过当前点本�?
nearestIndices = sortedIndices(2:3);

% �?近的两个点的坐标
nearestpoints = points(nearestIndices, :);

end