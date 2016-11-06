load('samples.txt','-ascii')

mu_ml=[0 0]
for j=1:length(samples)
    mu_ml = mu_ml + 1/j * (samples(:,j).' - mu_ml)
end;