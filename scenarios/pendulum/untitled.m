% Circle equation: (x-h)^2 + (y-k)^2 = r^2
% Center: (h,k)   Radius: r
h = 0;
k = 0;
r = 1;
%% In x-coordinates, the circle "starts" at h-r & "ends" at h+r
%% x_res = resolution spacing between points
xmin = -pi/8;
xmax = pi/8;
x_res = 1e-3;
x = xmin:x_res:xmax;

%% There are 2 y-coordinates on the circle for most x-coordinates.
%% We need to duplicate every x-coordinate so we can match each x with
%% its pair of y-values.
%% Method chosen: repeat the x-coordinates as the circle "wraps around"
%%           e.g.: x = [0  0.1  0.2  ...  end  end  ... 0.2  0.1  0]
N = length(x);
y = zeros(1,N);
for i = 1:1:N
    square = sqrt(r^2 - x(i)^2 + 2*x(i)*h - h^2);   
    y(N+1-i) = k + square;
end
zmp = [x(:) y(:)]';


figure(1)
plot(x,y)
hold on
axis([-5 5 -5 5]);