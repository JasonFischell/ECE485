function [pitch] = estimate_pitch(x)
Fs = 44100;
Fmin = 100;
Fmax = 2000;
L = 2.*Fs/Fmin;
M = L./2; 

freqs = ac_pitch_1(x', L, M, Fs, Fmin, Fmax);
pitch = mean(freqs(:,1));

end