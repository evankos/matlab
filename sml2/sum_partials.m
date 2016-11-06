function g=sum(D)
syms a b
total=[];
for i=1:length(D)
    total=[total -log(b.^2+(D(i) - a).^2)];
end;
g(a,b)=log((b/pi).^length(D))+sum(total);

