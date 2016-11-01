function G=G(x,t,w)
a = x*w;                          %compute all activations
y = sigmoid(a);                   %compute outputs
% modification by Sep Thijssen, such that 0*log(0) will be interpred as 0.
G = -t.*log(y) - (1 - t).*log(1 - y);
G = sum(G(~isnan(G)));

