rand('state',0)
n=4096;
grid_x=64; % X dimension of lattice, it should be a divisor of n
grid=0; %1D grid
% grid=1; %2D grid quadratic
% grid=2; %2D grid triangular
J=1; %set to 1 or -1 if you dont want random J

p=n;
rand('state',0);
% w=sprandsym(n,p);
% w=(w>0)-(w<0); % this choice defines a frustrated system
% w=(w>0); % this choice defines a ferro-magnetic (easy) system
w=zeros(n,p); % use this instead of the above random generation to avoid memory problems if J isnt random.

% Creating the Neighbourhoods
for i=1:n
    row=w(i,:);
    neigh=Neigh(n,i,grid,grid_x);
    row(neigh)=0;
    w(i,:)=w(i,:)-row;
    if(J~=0)
        w(i,neigh)=J;
    end;
end;


w=w-diag(diag(w));




