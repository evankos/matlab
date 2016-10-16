%% Section 1 Exercise 1.1 setup
% Description of second code block
clear;
syms x y
f(x) = 1 + sin(6*(x-2));
Tx = linspace(0.05,.95,40);
Ty = double(f(Tx));
Tnoise = normrnd(0,0.3,[1 40]);

Vx = linspace(0,1,100);
Vy = double(f(Vx));
Vnoise = normrnd(0.0,0.3,[1 100]);
%% Section 2 Exercise 1.1 run
plot(Tx,Ty+Tnoise,'*',Vx,Vy);
%% Exercise 1.2 setup
Dn = {Tx,Ty+Tnoise};
Vn = {Vx,Vy+Vnoise};

T = zeros(1,10)
V = zeros(1,10)
M = zeros(1,10)
for j=1:10
    sum=0;
    for i=1:length(Tx)
        sum = sum+1/length(Tx)*2*(polyval(polyfit(Tx,Ty,j-1),Tx(i))-f(Tx(i)))^2
    end
    T(j) = double(sqrt(sum))
end

for j=1:10
    sum=0;
    for i=1:length(Tx)
        sum = sum+1/length(Tx)*2*(polyval(polyfit(Tx,Ty,j-1),Vx(i))-f(Vx(i)))^2
    end
    V(j) = double(sqrt(sum))
    M(j) = j-1
end

%plot(Tx,y0 ,'b',Tx,y1 ,'g',Tx,y3 ,'r',Tx,y9 ,'y',Tx,Ty+Tnoise,'*',Vx,Vy,'c')

plot(M,T ,'b',M,V ,'g')
a = get(gca,'Children')
legend(a,'Validation','Training')
%% Exercise 2

clear;
syms x y z
f(x,y) = 100*(y - x^2)^2 + (1 - x)^2

[X,Y] = meshgrid(-2:.1:2,-1:.1:3);

%mesh(X,Y,f(X,Y))

g(x,y) = gradient((f-z)^2, [x, y])

gs(x,y)= gradient(2*x - 400*x*(- x^2 + y) - 2 - 200*x^2 + 200*y, [x, y])
hessian(f,[x,y])

mesh(X,Y,f(X,Y))

eigen = eig(hessian(f,[x,y]))






