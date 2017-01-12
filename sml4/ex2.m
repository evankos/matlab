

% Exercise 2.1
mu = [0 0];
Sigma = 2/5*eye(2);
x1 = -2:.1:2; x2 = -2:.1:2;
[X1,X2] = meshgrid(x1,x2);
Y_ = 3*mvnpdf([X1(:) X2(:)],mu,Sigma);


Y = reshape(Y_,length(x2),length(x1));
surf(x1,x2,Y);
% caxis([min(Y(:))-.5*range(Y(:)),max(Y(:))]);
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
pause;
clf('reset')

% Exercise 2.2
M=20;
D=3;
K=1;
w1=-.5+rand(M+1,D);

w2=-.5+rand(K,M+1);

X=[X1(:) X2(:) ones(numel(X2(:)),1)];
% data = load('a017_NNpdfGaussMix.txt', '-ASCII');
% X = data(:,1:2); Y = data(:,3);
% tri = delaunay(X(:, 1), X(:, 2));
% trimesh(tri, X(:, 1), X(:, 2), Y);
% xlabel('x1'); ylabel('x2'); zlabel('Trained output');
% pause


% X=[X(:, 1) X(:, 2) ones(numel(X2(:)),1)];
% Y_=Y;





a=w1*X';
z=tanh(a);
% z=[z;ones(1,numel(X2(:)))];

y_=w2*z;
y_=tanh(y_);


y= reshape(y_,length(x2),length(x1));
surf(x1,x2,y);
% caxis([min(y(:))-.5*range(y(:)),max(y(:))]);
xlabel('x1'); ylabel('x2'); zlabel('Untrained output');
pause;
clf('reset')

% Exercise 2.3
eta=.001;
nbrOfEpochs=500;


for m=1:nbrOfEpochs
    n = randperm(1681);

    % Iterate through all examples
    for r_i=1:numel(X(:,1))
        % Input data from current example set
        i=n(r_i);
        I = X(i,:).';
        D = Y_(i,:).';

        % Propagate the signals through network
        H = tanh(w1*I);
        O = w2*H;

        % Output layer error
        delta_i = (D-O);

        % Calculate error for each node in layer_(n-1)
        delta_j = (1-H.^2).*(w2.'*delta_i);

        % Adjust weights in matrices sequentially
        w2 = w2 + eta.*delta_i*(H.');
        w1 = w1 + eta.*delta_j*(I.');

    end
    a=w1*X';

    z=tanh(a);
    y_=w2*z;

    y_=y_;
    y= reshape(y_,length(x2),length(x1));
    surf(x1,x2,y);
%     caxis([min(y(:))-.5*range(y(:)),max(y(:))]);
    xlabel('x1'); ylabel('x2'); zlabel('Trained output');
    drawnow;
end

% Exercise 2.5




