%matlab 
clear all
figure(4)
clf

%load data
load x.ext
load t.ext

alpha=0.01;                  %set weight decay
sigma=.3;                  %define width of generating distribution Q is Normal
L=3000;                     %set number of Metropolis iterations
Lburn=1500;                  %set number of burn-in iterations
K=size(x,2);

%initialize weights
w=[10;-1;-1];
M=G(x,t,w)+alpha*E_w(w);

w_all=w;
M_all=M;
accept_all=[];

for l=1:L-1,
	w_new=sigma*randn(K,1)+w;      %generate new sampling point near w
	M_new=G(x,t,w_new)+alpha*E_w(w_new);
	delta=M_new-M;
	if (delta < 0)
		w=w_new;                   %accept w_new
		M=M_new;
		accept_all=[accept_all 1];
	else
		if (rand< exp(-delta))     %accept w_new with probability exp -delta
	    	w=w_new;
			M=M_new;
			accept_all=[accept_all 1];
		else
		    accept_all=[accept_all 0];
		end
	end;
	w_all=[w_all w];
	M_all=[M_all M];
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
mesh(i,j,f')
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


