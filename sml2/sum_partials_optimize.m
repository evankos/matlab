function g=sum(D)

total=@(x) 0;
for i=1:length(D)
    f = @(x)(log(x(1).^2+(D(i) - x(2)).^2));
    total = @(x) (total(x) + f(x));
end;
g=@(x)(log((x(1)/pi).^length(D)) - total(x));

