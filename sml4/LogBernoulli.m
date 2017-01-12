function [Bern] = LogBernoulli(X,mu)
% Log likelihood of a Mixture of Bernoulli distributions
e = 10e-10; % Prevent log(1-mu)=0
N = size(X,1);
Bern = X.*log(repmat(mu,N,1) + e) + (1-X).*log(1-repmat(mu,N,1) + e);
Bern(Bern<-20) = 0; % get rid of the effect of e
Bern = sum(Bern,2);
end