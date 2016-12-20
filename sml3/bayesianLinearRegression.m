%
% plots a function + std
%
syms x w

phi(x) = [1;x];
Phi = [1,0.4;1,0.6];
I = [1,0;0,1];
SN_ = 2 * I + 10 * Phi' * Phi;
SN = SN_^-1;
mN = 10 * SN * Phi' * [0.05; -0.35];
M(x) = mN' * phi(x);
sigm2(x) = 1/10 + phi(x)'*SN*phi(x);


xx = [0:0.01:1];
% bogus data, function + std, just for illustration!!
% you should use your own data, functions + std!!!
Xn = [0.4;  0.6];
Tn = [0.05; -0.35];
mx = M(xx);
sx = sqrt(sigm2(xx));


%
%
%
figure(111)
axis([0 1 -1.5 1.5]);
hold on
% first the m(x)+/-s(x) areas (no line)
area(xx,(mx+sx), 'FaceColor', [1.0, 0.8, 0.8], 'BaseValue',-1.5);  % pinkish
area(xx,(mx-sx), 'FaceColor', [1.0, 1.0, 1.0], 'BaseValue',-1.5);  % white
% the lines for the predictive mean m(x) and variance s(x) around it
plot(xx,(mx+sx),'r', 'LineWidth',2);     % red
plot(xx,mx,'k');                         % black
plot(xx,(mx-sx),'r', 'LineWidth',2);     % red
% circle the datapoints
plot(Xn,Tn,'o','MarkerEdgeColor','k','LineWidth',2, 'MarkerSize',10);



disp('press any key');
pause;
%
% five made-up functions, again only for illustration for the second matlab plot!!!
% you should generate your own functions !!
for i=1:5
    %a = randn(2,1);
    w = mvnrnd(mN,SN);
    y = w(1)+w(2)*xx; % these are not the function that you need!
    plot(xx,y,'b','LineWidth',1.5);
end;
%
%
disp('press key to close figure');
pause;
%
close(111);