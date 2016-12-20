% some ideas to make a scatter plot in the logistic regression exercise
% you may use and adapt this code according to your needs

% just a random set as an example
data = load('a010_irlsdata.txt','-ASCII');
x = data(:,1:2); cl = data(:,3);

syms w x1 x2




ww=[0;0;0];
Phi=ones(1000,3);
t=cl;
SIGMA = [0.2,0; 0,0.2];
phi1(x1,x2)= mvnpdf([x1,x2],[0 0],SIGMA);
phi2(x1,x2)= mvnpdf([x1,x2],[1 1],SIGMA);
for i=1:1000
    Phi(i,2)=phi1(x(i,1),x(i,2));
    Phi(i,3)=phi2(x(i,1),x(i,2));
end;

untrained_Y = (1+exp(-(ww' * Phi'))').^-1; % 0.5

untrainedCrossEntropy = G(untrained_Y,t); % 693.1472

XX=[ww]
YY=[0]
for j=1:8
    ww
    R=zeros(1000);
    Y=(1+exp(-(ww' * Phi'))').^-1;
    for i=1:1000
        R(i,i)=Y(i)*(1-Y(i));
    end;
    ww = double(ww - (Phi' * R * Phi)^-1 * Phi' * (Y - t));
    XX=[XX ww];
    YY=[YY j];
end;
Y = (1+exp(-(ww' * Phi'))').^-1; % 0.5

crossEntropy = G(Y,t); % 346.5041

cl = Y;
% this seems to work
mycolormap = colormap('Jet');
d64 = [0:63]/63; %
c = interp1(d64, mycolormap,cl);
dotsize = 10;
scatter(x(:,1),x(:,2),dotsize,c,'fill');
xlabel('x_1');
ylabel('x_2');
title('Model classes on feature domain');
colorbar; % what do the colors mean?