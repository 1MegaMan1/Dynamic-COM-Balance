function ZMP_t = ZMP_targets(cost)
% Circle equation: (x-h)^2 + (y-k)^2 = r^2
% Center: (h,k)   Radius: r
h = 0;
k = 0;
r = cost.p;
%% In x-coordinates, the circle "starts" at h-r & "ends" at h+r
%% x_res = resolution spacing between points
xmin = -pi/8;
xmax = pi/8;
x_res = 1e-3;
x = xmin:x_res:xmax;
N = length(x);
y = zeros(1,N);
for i = 1:1:N
    square = sqrt(r^2 - x(i)^2 + 2*x(i)*h - h^2);   
    y(N+1-i) = k + square;
end

ZMP_t = [x(:) y(:)]';
