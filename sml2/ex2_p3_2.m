clear;

load('flashes.txt','-ascii')


% Create the functions given some flashes
y_1 = sum_partials(flashes(1:1));
y_2 = sum_partials(flashes(1:2));
y_3 = sum_partials(flashes(1:3));
y_20 = sum_partials(flashes(1:20))

% Create the meshgrid evaluate and plot
a = -10:.3:10; b = 0:.3:5;
[A,B] = meshgrid(a,b);
y = double(y_20(A,B));
mesh(A,B,y)
xlabel('a'); ylabel('b'); zlabel('Log-LikeliHood');