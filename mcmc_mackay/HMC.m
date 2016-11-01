%matlab
clear all
figure(5)
clf

%load data
load x.ext
load t.ext

alpha=0.01;                  %set weight decay
L=500;                     %set number of Metropolis iterations
Lburn=100;                  %set number of burn-in iterations
Tau=10;
epsilon=0.2;
K=size(x,2);

%initialize weights
w=[-15; 1; 1];
M=G(x,t,w)+alpha*E_w(w);
g=gradG(x,t,w)+alpha*w;
w_all=w;
M_all=M;
accept_all=[];

for l=1:L-1,
	p= randn(K,1);
	H=p'*p/2+M;
	wnew=w;
	gnew=g;
	for tau=1:Tau,
		p=p-epsilon*gnew/2;
		wnew=wnew+epsilon*p;
		gnew=gradG(x,t,wnew)+alpha*wnew;
		p=p-epsilon*gnew/2;
	end;
	Mnew=G(x,t,wnew)+alpha*E_w(wnew);
	Hnew=p'*p/2+Mnew;
	dH=Hnew-H;
	if (dH <0)
		accept=1;
	else
		if (rand < exp(-dH))
			accept=1;
		else
			accept=0;
		end;
	end;
	if (accept)
		g=gnew;
		w=wnew;
		M=Mnew;
	end;
	w_all=[w_all w];
	M_all=[M_all M];
	accept_all=[accept_all accept];
end;

subplot(2,2,1)
plot(1:L,w_all')
xlabel('w versus iteration')
legend('w_1','w_2','w_3')

subplot(2,2,2)
plot(1:L,M_all')
xlabel('M versus iteration')


w_all=w_all(:,Lburn+1:L);
M_all=M_all(:,Lburn+1:L);

subplot(2,2,3)
plot(w_all(2,:),w_all(3,:),'.')
xlabel( '(w_2,w_3) sampled after burn in')

subplot(2,2,4)
i=1:10;
j=1:10;
for ii=1:length(i)
for jj=1:length(j)
    x_test=[1 i(ii) j(jj)];
    f(ii,jj)=mean(sigmoid(x_test*w_all));
end;
end;
contour(i,j,f')
hold on
for i=1:size(t,1),
    if (t(i)==1)
        plot(x(i,2),x(i,3),'r*')
    else
        plot(x(i,2),x(i,3),'b+')
    end;
    hold on
end;
hold off
xlabel('Bayesian solution' )
mean(accept_all)
mean(M_all)