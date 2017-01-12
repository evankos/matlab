function G=gram(x,x1,theta)
G=zeros(numel(x));
for i = 1:numel(x)
    for j = 1:numel(x1)
        G(i,j)=k(x(i),x(j),theta);
    end;
end;