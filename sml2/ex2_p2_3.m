clear;

load('flashes.txt','-ascii')

mu_ml=0
y=[]
for j=1:length(flashes)
    mu_ml = mu_ml + 1/j * (flashes(j) - mu_ml)
    y = [y mu_ml]
end;

x = linspace(1,length(flashes),length(flashes));

plot(x,y);
a = get(gca,'Children')
legend(a,'Mean')
xlabel('N'); ylabel('Mean');