mu = [0.7677;0.7982];
Sigma = [2.0,0.8;0.8,4.0];
samples=[];
for i=1:1000
    Sample = MultivariateGaussian_sample(mu,Sigma);
    samples = [samples Sample.']
end;
save('samples.txt','samples','-ascii')
% load('samples.txt','-ascii')