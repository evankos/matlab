%matlab
clear all
figure(3)
clf

%load data
load x.ext
load t.ext
K=size(x,2);

alpha=0.01;

%select data points 
%for instance data point 1 
% x1=[x(1,:)];
% t1=[t(1,:)];

%for instance data points 1 and 6
x1=[x(1,:); x(6,:) ];
t1=[t(1,:); t(6,:) ];

%or data points 1, 2 and 6
% x1=[x(1,:); x(6,:); x(2,:) ];
% t1=[t(1,:); t(6,:); t(2,:) ];

%or all data points
% x1=x;
% t1=t;

subplot(2,2,1)
%plot data
for i=1:size(t1,1),
	if (t1(i)==1)
		plot(x1(i,2),x1(i,3),'r*')
	else
		plot(x1(i,2),x1(i,3),'b+')
	end;
	hold on
end;
hold off
axis([1 10 1 10])
xlabel('data set')

%plot likelihood
subplot(2,2,2)
i=-4:0.5:10;
j=-10:0.5:6;
for ii=1:length(i)
for jj=1:length(j)
	w=[-10;i(ii);j(jj)];
	f(ii,jj)=exp(-G(x1,t1,w));
end;
end;
mesh(i,j,f')
xlabel('likelihood of w_2 and w_3')

%plot posterior
subplot(2,2,3)
for ii=1:length(i)
for jj=1:length(j)
	w=[-10;i(ii);j(jj)];
	f(ii,jj)=exp(-G(x1,t1,w)-alpha*E_w(w));
end;
end;
mesh(i,j,f')
xlabel('posterior of w_2 and w_3')

subplot(2,2,4)
contour(i,j,f')
xlabel('posterior of w_2 and w_3')
