clear;
D = [4.8,-2.7,2.2,1.1,0.8,-7.3];

syms a
f(a) = exp(-(log(1+(D(1) - a).^2)+log(1+(D(2) - a).^2)+log(1+(D(3) - a).^2)+log(1+(D(4) - a).^2)+log(1+(D(5) - a).^2)+log(1+(D(6) - a).^2)));
x = linspace(-5,5,100);
y = double(f(x));
% Maximum
max_a = x(y==max(y(:)))
mean_x = mean(D)

plot(x,y);
a = get(gca,'Children')
legend(a,'P(a|D,b=1)')
xlabel('x'); ylabel('P(a|D,b=1)');