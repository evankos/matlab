%matlab
clear all
figure(6)
clf
%program to compare Metropolis and HMC methods on elongated two
%dimensional Gaussian.


A=[250.25 -249.75;-249.75 250.25]; %specify Gaussian

% ALGORITHM_TYPE='metro'; 		% can have value 'hmc' for Hybrid
ALGORITHM_TYPE='hmc';
								% Monte Carlo or 'metro' for Metropolis

%Standard settings for both methods
L=100;                     	% number of Metropolis iterations
Tau=10;						% number of Hamilton dynamics steps
epsilon=0.02;				% size of Hamilton dynamics steps
sigma=0.2;					% width of Gaussian for Metropolis method

x=[-1;-1]; % initialize x
E=0.5*x'*A*x; % initialize E
g=A*x; % initialize grad E
x_all=[];
E_all=[];
accept_all=[];


switch ALGORITHM_TYPE
case 'hmc'
	for l=1:L,
		% choose new p from normal distribution
		p= randn(2,1);
		H=p'*p/2+E;
	
		% choose new x
		xnew=x;
		gnew=g;
		for tau=1:Tau,
			p=p-epsilon*gnew/2;
			xnew=xnew+epsilon*p;
			gnew=A*xnew; 
			p=p-epsilon*gnew/2;
		end;
		Enew=0.5*xnew'*A*xnew;
		Hnew=p'*p/2+Enew;
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
			x=xnew;
			E=Enew;
		end;
		x_all=[x_all x];
		E_all=[E_all E];
		accept_all=[accept_all accept];
	end;
case 'metro'
	for l=1:L,
		% choose new x
		xnew=x+sigma*randn(2,1);
		Enew=0.5*xnew'*A*xnew;
		dE=Enew-E;
		if (dE <0)
			accept=1;
		else
			if (rand < exp(-dE))
				accept=1;
			else
				accept=0;
			end;
		end;
		if (accept)
			x=xnew;
			E=Enew;
		end;
		x_all=[x_all x];
		E_all=[E_all E];
		accept_all=[accept_all accept];
	end;
end;
disp(['number of accepted points ' int2str(sum(accept_all))])

x=-1.5:0.01:1.5;
[X,Y]=meshgrid(x);
E=0.5*A(1,1)*X.^2+A(1,2)*X.*Y+0.5*A(2,2)*Y.^2;
contour(X,Y,E,[0.5 0.5])
hold on
plot(x_all(1,:),x_all(2,:),'.')
xlabel('x_1')
ylabel('x_2')
hold off
mean(accept_all)
mean(E_all)
