close all, clear
% Load and visualize raw data.
X = load('a011_mixdata.txt', '-ASCII');
N = size(X,1); D = size(X,2);
%
% % Histograms
% figure(1)
% subplot(2,2,1);hist(X(:,1));title('x_1')
% subplot(2,2,2);hist(X(:,2));title('x_2')
% subplot(2,2,3);hist(X(:,3));title('x_3')
% subplot(2,2,4);hist(X(:,4));title('x_4')
% % 3D
% figure(2)
% scatter3(X(:,3),X(:,4),X(:,1))
% hold on
% scatter3(X(:,3),X(:,4),X(:,2))
% title('Blood quantities x_1 and x_2')
% xlabel('x_3')
% ylabel('x_4')
% legend('x_1', 'x_2')
% % Boxplot
% figure(3)
% boxplot(X,'labels',{'x1', 'x2', 'x3', 'x4'})
% title('Boxplot represenations')



%% Initialization
K = 4;
pi = ones(1,K)*(1/K);
mu = repmat(mean(X),K,1) + (2*rand(K,D)-1);
sigma = zeros(D,D,K);
for s=1:K 
    sigma(:,:,s) = eye(D).*(4*rand(D)+2);
end
iter = 100;
log_p = zeros(1,iter);
x1 = X(:,1); x2 = X(:,2); % plot axis 
c = rand(K,3) < 0.5; % color
%% EM algorithm
for i=1:iter
    % E-STEP
    numerator = GaussianMixture(X,mu,sigma,pi,K);
    denominator = sum(numerator,2);
    gamma_z = numerator ./ repmat(denominator,1,K);
    % M-STEP
    N_k = sum(gamma_z);
    sigma(:,:,:) = 0; % clear variable for update
    for j=1:K
        mu(j,:) = 1/N_k(j) * sum(repmat(gamma_z(:,j),1,D).*X);
        diff = X - repmat(mu(j,:),N,1);
        for n=1:N
           sigma(:,:,j) = sigma(:,:,j) + gamma_z(n,j)*(diff(n,:)'*diff(n,:));
        end
        sigma(:,:,j) = sigma(:,:,j)/N_k(j);
        pi(j) = N_k(j)/N;
    end
    % EVALUATION (LOG-PROB)
    p = GaussianMixture(X,mu,sigma,pi,K);
    log_p(i) = sum(log(sum(p,2))); % Log likelihood

    % DEPICTION
    tmp = max(gamma_z')'; labels = gamma_z==repmat(tmp,1,K);

    figure(1)
    t = sprintf('Component asignments K= %i', K);
    title(t)
    xlabel('x_1')
    ylabel('x_2')
    for ii=1:K
        scatter(x1(labels(:,ii)==1),x2(labels(:,ii)==1),[],c(ii,:))
        t1 = sprintf('K= %i',ii);
        hold on
    end

    figure(2)
    title('Correlations')
    for jj=1:K
        corr = corrcov(sigma(1:2,1:2,jj)); % correlations {x1,x2} per cluster
        str = sprintf('Correlation coeff. (x1, x2). Component %i', jj);
            % prevent subplots from shrinking at every loop
            h = subplot(K,1,jj);
            ax=get(h,'position');
            set(h,'position',ax);
        title(str)
        imagesc(corr)
        h1 = colorbar;
        caxis([-1 1])
        hold on
    end

end
% MORE DEPICTION
figure(3)
log_p = log_p / min(log_p);
plot(1:iter,log_p)
title('Scaled Log-Likelihood')
xlabel('Num. of Iterations')
axis tight

% PREDICTION
users = [11.85, 2.2, 0.5, 4; 11.95,3.1,0.0,1.0; 12, 2.5,0.0,2; 12, 3, 1, 6.3];
pred = GaussianMixture(users,mu,sigma,pi,K);