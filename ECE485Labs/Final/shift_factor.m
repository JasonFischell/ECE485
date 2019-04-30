function diff = shift_factor(freq)
Fc = 440;
n = -30:35;
freqs = Fc.*(2.^(n/12));
[m, i] = min(abs(freqs-freq));
index = i(1);
pitch = freqs(index);
% F = f*(2^n/12);
% F = desired
% f = current
% 12*log2(F/f) = n

diff = 12.*log2(pitch/freq) - 1/12;
end