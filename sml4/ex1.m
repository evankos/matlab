
% Exercise 1.2
theta=[1,1,1,1];
X=linspace(-1,1,101);
Gram=gram(X,X,theta);

% Exercise 1.3
% 101x101
% Use eig(A,'matrix') to get all eigenvalues and check that they are >=0
eps=-1e-13;
all(eig(Gram) >= eps)

% Exercise 1.4
MU = zeros(1,numel(Gram(1,:)));
y = mvnrnd(MU,Gram,5);
hold on
plot(X,y(1,:));
plot(X,y(2,:));
plot(X,y(3,:));
plot(X,y(4,:));
plot(X,y(5,:));

% Exercise 1.5
% we can see that by changing the theta parameters of the kernel we can change the variance but when we notice
% picture number 3 we understand that we can also influence the similarity between X samples that are close together
% this makes sense since in number 3 we are using 64 as theta(2) and that is multiplied by abs(x-x')^2
X=linspace(-1,1,101);
for theta = [1, 4, 0, 0; 9, 4, 0, 0; 1, 64, 0, 0; 1, 0.25, 0, 0; 1, 4, 10, 0; 1, 4, 0, 5]'
    Gram=gram(X,X,theta);
    MU = zeros(1,numel(Gram(1,:)));
    y = mvnrnd(MU,Gram,5);
    hold on
    plot(X,y(1,:));
    plot(X,y(2,:));
    plot(X,y(3,:));
    plot(X,y(4,:));
    plot(X,y(5,:));
    pause;
    clf('reset')
end

% Exercise 1.6
x=[-.5,.2,.3,-.1];
t=[.5,-1,3,-2.5];
theta=[1,1,1,1];
beta=1;
Gram=gram(x,x,theta);
C=zeros(numel(x));
for i = 1:numel(x)
    for j = 1:numel(x)
        C(i,j)=Gram(i,j)+1/beta*kronDel(i,j);
    end;
end;

% Exercise 1.7
% We need equation 6.66, 6.67
C_new=zeros(numel(x)+1);
x_new=0;
c=k(x_new,x_new,theta)+1/beta;
k_=zeros(1,numel(x));
for i =1:numel(k_)
    k_(i)=k(x(i),x_new,theta);
end;
C_new(1:numel(x),1:numel(x))=C;
C_new(numel(x)+1,1:numel(x))=k_;
C_new(1:numel(x),numel(x)+1)=k_;
C_new(numel(x)+1,numel(x)+1)=c;

Mu_new=k_*inv(C)*t'; % 0.0252
Sigma_new=c-k_*inv(C)*k_'; % 1.2357

% Exercise 1.8
% The mean does not go to 0 with x goign to infinite but that can be change if we make the kernel
% function only depend on the distance between x and x'. That can be done by selecting a theta
% with the last 2 parameters set to zero.










