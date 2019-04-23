function [out] = delay2(in)
out = in(mod(1:length(in),length(in))+1);
out(1) = -out(1);