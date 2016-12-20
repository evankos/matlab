%
% plots a function + std
%
syms w



ww=[1;1];
Phi=[1,0.3;
    1,0.44;
    1,0.46;
    1,0.6];
t=[1;0;1;0];


XX=[ww]
YY=[0]
for j=1:8
    ww
    R=zeros(4);
    Y=(1+exp(-(ww' * Phi'))').^-1;
    for i=1:4
        R(i,i)=Y(i)*(1-Y(i));
    end;
    ww = double(ww - (Phi' * R * Phi)^-1 * Phi' * (Y - t));
%     ww = double(ww - (Phi' * Phi)^-1 * (Phi' * Phi * ww - Phi' * t));
    XX=[XX ww];
    YY=[YY j];
end;

figure(111)
% axis([0 7 -2 2]);
hold on

plot(YY,XX(1,:),'r', 'LineWidth',1);
plot(YY,XX(2,:),'b', 'LineWidth',1);
a = get(gca,'Children')
legend(a,'w0','w1')
xlabel('iteration') % x-axis label
ylabel('weights') % x-axis label


syms x
eqn = 1/(1+exp(-(9.8-21.7*x))) == 0.5;
solx = solve(eqn,x)
x = 0.4516