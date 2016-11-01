function s=sigmoid(x)
if x > 0
	s=1./(1+exp(-x));
else
	s=exp(x)./(exp(x)+1);
end

