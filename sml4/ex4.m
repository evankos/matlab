clear; close all
% Load the dataset
N = 800; D = 28*28; X = uint8(zeros(N,D));
fid = fopen ('a012_images.dat', 'r');
for i = 1:N
X(i,:) = fread(fid, [D], 'uint8');
end;
status = fclose(fid);
fid1 = fopen ('a012_labels.dat', 'r');
Z = fread(fid1, N, 'uint8');

%{
% Visualization
BW_map = [1 1 1; 0 0 0];
figure(1)
for m=1:N
    I = reshape(X(m,:),sqrt(D),sqrt(D));
    image(I)
    colormap(BW_map)
    %pause
end

%}

%% Initialization
K = 3;
X = double(X);
pi = ones(1,K)*(1/K);
mu = 0.5*rand(K,D)+0.25;
    % true values
    %mu(1,:) = mean(X(Z==2,:)); 
    %mu(2,:) = mean(X(Z==3,:));
    %mu(3,:) = mean(X(Z==4,:));
iter = 40;
log_p = zeros(1,iter); 
%% EM algorithm
for i=1:iter
    % E-STEP
    for n=1:K
        product = ones(N,1);
        for p=1:D
            bernoulli_per_pixel=  pi(n) * mu(n,p).^X(:,p).*(1 - mu(n,p)).^(1-X(:,p));
            product = product .* bernoulli_per_pixel;
            if mod(p,5)==0
                product = normc(product);
            end
        end
        numerator(:,n) = product;
    end
        
    denominator = sum(numerator,2);
    gamma_z = numerator ./ repmat(denominator,1,K);
    % M-STEP
    N_k = sum(gamma_z);
    p = zeros(N,1);
    for j=1:K
        mu(j,:) = 1/N_k(j) * sum(repmat(gamma_z(:,j),1,D).*X); 
        pi(j) = N_k(j)/N;
        bernoulli = LogBernoulli(X,mu(j,:));
        p = p + gamma_z(:,j) .* bernoulli; % Log likelihood (Part 1)  
    end
% EVALUATION (LOG-PROB)
log_p(i) = sum(p); % Log likelihood (Part 2)

% DEPICTION
figure(2)
tmp = mu;
for k=1:K
    MAX = max(tmp(k,:));
    map = uint8((double(tmp(k,:)) ./ MAX) .* 255);
    map = reshape(map,sqrt(D),sqrt(D));
    str = sprintf('Class image %i. Iteration %i',k,i);
        % prevent subplots from shrinking at every loop
        h = subplot(K,1,k);
        ax=get(h,'position');
        set(h,'position',ax); 
    image(map)
    colormap(gray(255));
    title(str)
    hold on
end

end
% MORE DEPICTION
figure(3)
log_p = log_p / min(log_p);
plot(1:iter,log_p)
axis tight


% PREDICTION
for n=1:K
     classes(:,n) = LogBernoulli(X,mu(n,:));
end
[MAX Ind] = min(classes');
Ind = Ind' + 1;

performance = sum(Ind==Z)/N;

