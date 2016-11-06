mu = [0.8 0.8];
Sigma = [0.1,-0.1;-0.1,3/25];
x1 = -3:.05:3; x2 = -3:.08:3;
[X1,X2] = meshgrid(x1,x2);
F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));
surf(x1,x2,F);
caxis([min(F(:))-.5*range(F(:)),max(F(:))]);
axis([-3 3 -3 3 0 4])
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');