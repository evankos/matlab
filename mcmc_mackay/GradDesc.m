%matlab
clear all
figure(2)
clf

%load data
load x.ext
load t.ext
K=size(x,2);

L=5000;                              %set number of learn iterations
alpha=0.1;                          %set weight decay
eta=0.01;                           %set learning rate

%initialize weights
w=zeros(K,1);
w=[-1; 0; 0];

M_all=G(x,t,w)+alpha*E_w(w);
w_all=w;
%cost before training
G(x,t,w)

for l=1:L-1,
	y=sigmoid(x*w);           %compute outputs for all patterns
	e=t-y;                    %compute errors for all patterns
	g=-x'*e;                  %compute gradient vector
	w=w-eta*(g+alpha*w);      %make step, using learning rate eta
                              %and weight decay alpha
	M_all=[M_all G(x,t,w)+alpha*E_w(w)];
	w_all=[w_all w];
end;
subplot(2,2,1)
plot(1:L,M_all)
xlabel('M(w) vs. iteration')

%plot weights
subplot(2,2,2)
plot(1:L,w_all(1,:),1:L,w_all(2,:),1:L,w_all(3,:))
xlabel('w vs. iteration')
legend('w_1','w_2','w_3')
subplot(2,2,3)
plot(w_all(2,:),w_all(3,:))
xlabel('w(2) vs. w(3)')
axis([0 1.5 0 1.5])

%plot final perceptron solution
subplot(2,2,4)
for i=1:10,
for j=1:10,
	f(i,j)=sigmoid(w(1)+w(2)*i+w(3)*j);
end;
end;
mesh(1:10,1:10,f')
hold on
contour(1:10,1:10,f')
plot(x(1:5,2),x(1:5,3),'r*')
plot(x(6:10,2),x(6:10,3),'b+')
xlabel('perceptron with final weights')
%cost after training
G(x,t,w)
w