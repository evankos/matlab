clear;

a = -1.8533
b = 1.1872

flashes=[];
theta = 0
for i=1:200
    %sample theta from uniform for x in [-5 5] theta = +-1.3993
    theta = -1.3993 + (2 * 1.3993).*rand(1,1)
    %translate theta to x
    x = b * tan(theta) + a;
    flashes = [flashes x];
end;
save('flashes.txt','flashes','-ascii')