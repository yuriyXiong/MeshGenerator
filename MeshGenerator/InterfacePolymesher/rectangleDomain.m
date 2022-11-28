function g= rectangleDomain(xmin,xmax,ymin,ymax)
% generate a rectangle Domain
g = zeros(10,4);
g(1,:) = 2;  % 2 for line
g(2,:) = [xmax, xmax, xmin, xmin];       % x: starting points
g(3,:) = circshift(g(2,:),-1); % x: ending points
g(4,:) = [ymin, ymax, ymax, ymin];       % y: starting points
g(5,:) = circshift(g(4,:),-1); % y: ending points
g(6,:) = 1;   % label of subdomain on the left
g(7,:) = 0;   % label of subdomain on the right

end

