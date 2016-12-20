% some ideas to make a scatter plot in the logistic regression exercise
% you may use and adapt this code according to your needs

% just a random set as an example
data = load('a010_irlsdata.txt','-ASCII');
x = data(:,1:2); cl = data(:,3);



%this seems to work
mycolormap = colormap('Jet');
d64 = [0:63]/63; %
c = interp1(d64, mycolormap,cl);
dotsize = 10;
scatter(x(:,1),x(:,2),dotsize,c,'fill');
xlabel('x_1');
ylabel('x_2');
title('Target classes on feature domain');
colorbar; % what do the colors mean?





%
% syms w
%
%
%
% ww=[0;0;0];
% Phi=ones(1000,3);
% t=cl;
% for i=1:1000
%     Phi(i,2)=x(i,1);
%     Phi(i,3)=x(i,2);
% end;
%
% untrained_Y = (1+exp(-(ww' * Phi'))').^-1; % 0.5
%
% untrainedCrossEntropy = G(untrained_Y,t); % 693.1472
%
% XX=[ww]
% YY=[0]
% for j=1:8
%     ww
%     R=zeros(1000);
%     Y=(1+exp(-(ww' * Phi'))').^-1;
%     for i=1:1000
%         R(i,i)=Y(i)*(1-Y(i));
%     end;
%     ww = double(ww - (Phi' * R * Phi)^-1 * Phi' * (Y - t));
%     XX=[XX ww];
%     YY=[YY j];
% end;
% Y = (1+exp(-(ww' * Phi'))').^-1; % 0.5
%
% crossEntropy = G(Y,t); % 692.9694
%
% cl = Y;
% % this seems to work
% mycolormap = colormap('Jet');
% d64 = [0:63]/63; %
% c = interp1(d64, mycolormap,cl);
% dotsize = 10;
% scatter(x(:,1),x(:,2),dotsize,c,'fill');
% xlabel('x_1');
% ylabel('x_2');
% title('Model classes on feature domain');
% colorbar; % what do the colors mean?

