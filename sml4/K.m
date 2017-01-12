function k=k(x,x1,T)
k=T(1)*exp(-T(2)/2*norm(x-x1).^2)+T(3)+T(4)*x'*x1;
