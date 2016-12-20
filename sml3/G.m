function G=G(y,t)                         %compute all activations
% modification by Sep Thijssen, such that 0*log(0) will be interpred as 0.
G = -t.*log(y) - (1 - t).*log(1 - y);
G = sum(G(~isnan(G)));

