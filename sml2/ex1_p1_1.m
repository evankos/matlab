Sigma = [0.14,-0.3,0.0,0.2;
            -0.3,1.16,0.2,-0.8;
            0.0,0.2,1.0,1.0;
            0.2,-0.8,1.0,2.0];
Lambda = inv(Sigma);
Lambda_aa = Lambda(1:2,1:2).';
Lambda_ab = Lambda(3:4,1:2).';
mu_a = [1,0];
mu_b = [1,2];
x_b = [0,0];
% conditional Mean
result = mu_a.' - inv(Lambda_aa) * Lambda_ab * (x_b - mu_b).';