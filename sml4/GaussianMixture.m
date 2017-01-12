function [GaussMix] = GaussianMixture(X,mu,sigma,pi,K)
% Calculates the Gaussian mixture distribution of every datapoint in X.
    for k=1:K
        GaussMix(:,k) = pi(k)*mvnpdf(X,mu(k,:),sigma(:,:,k));
    end
    
end 