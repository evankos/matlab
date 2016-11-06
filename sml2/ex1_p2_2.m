load('samples.txt','-ascii')

mu_ml=[0 0]
for j=1:length(samples)
    mu_ml = mu_ml + samples(:,j).'
end;
mu_ml = mu_ml/1000

Sigma_ml = [0,0;0,0]
for j=1:length(samples)
    Sigma_ml = Sigma_ml + ((samples(:,j).'-mu_ml).' * (samples(:,j).'-mu_ml))
end;
Sigma_ml = Sigma_ml/1000