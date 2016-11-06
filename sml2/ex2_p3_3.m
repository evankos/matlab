clear;

load('flashes.txt','-ascii')

xo=[.1,1]
alphas=[]
betas=[]
options = optimset('MaxFunEvals',100000);
points = 20
for i=1:points
    y = sum_partials_optimize(flashes(1:i));
    [p,fminres] = fminsearch(y,xo,options);
    alphas = [alphas p(1)];
    betas = [betas p(2)];
end
x = linspace(1,points,points);
plot(x,alphas,'r',x,betas,'b');
a = get(gca,'Children')
legend(a,'alpha','beta')
xlabel('N'); ylabel('optimum');