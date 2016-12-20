%
% plots a function + std
%
syms x

xx = 1;
xx_ = -1;
f(x) = sin(x);
grad(x) = diff(f(x));
hessian(x) = diff(grad(x));
NewtRaphs(x) = x - (grad(x)/hessian(x));
XX=[xx]
XX_=[xx_]
YY=[0]
for i=1:5
    xx = NewtRaphs(xx);
    xx_ = NewtRaphs(xx_);
    XX = [XX double(xx)];
    XX_ = [XX_ double(xx_)];
    YY = [YY i];
end;

figure(111)
axis([0 7 -2 2]);
hold on

plot(YY,XX,'r', 'LineWidth',1);
plot(YY,XX_,'b', 'LineWidth',1);
xlabel('iteration') % x-axis label
ylabel('Min x') % x-axis label
