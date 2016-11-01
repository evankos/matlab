function g=gradG(x,t,w)
y=sigmoid(x*w);  
e=t-y; 
g=-x'*e;

