function weights = PolCurFit(Dn,d)
%weights = polyfit(cell2mat(Dn(1)),cell2mat(Dn(2)),d);
x = cell2mat(Dn(1));
y = cell2mat(Dn(2));
WeightSyms = sym('w', [1 d]);
pol = poly2sym(sym('w', [1 d]));

for i=1:length(y)
    fss{i}=@(x) 1/2*(subs(pol,x(i)) - y(i))^2;
    for j=1:d
        dfss{i,j}=@(x) diff(fss{i},WeightSyms(j)) == 0;
    end
end
[A, B] = equationsToMatrix(dfss{:,:}, WeightSyms)
weights = linsolve(A,B)
end