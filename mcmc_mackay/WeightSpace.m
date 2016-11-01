%matlab 
clear all
figure(1)
clf

%load data
load x.ext
load t.ext
N=size(x,1);
K=size(x,2);

%plot data
plot(x(1:5,2),x(1:5,3),'r*')
hold on
plot(x(6:10,2),x(6:10,3),'b+')
hold off

%set weights. change here to realize different perceptrons
w=5*[-10.2;1;1]

%this line prints the cost G(w) of the solution
G(x,t,w)

for i=1:10,
    for j=1:10,
        f(i,j)=sigmoid(w(1)+w(2)*i+w(3)*j);
    end;
end;

subplot(1,2,1)
plot(x(1:5,2),x(1:5,3),'r*')
hold on
plot(x(6:10,2),x(6:10,3),'b+')
contour(1:10,1:10,f')
hold off

subplot(1,2,2)
mesh(1:10,1:10,f')
hold on
contour(1:10,1:10,f')
hold off
