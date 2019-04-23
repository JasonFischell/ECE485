function [num,den]  = iirNotchLFO(LFO, f_min, f_max, Q)
Fs = 44100;
f = 0.5*(f_max-f_min)*double(LFO)+(f_min+f_max)/2; % Shift/Scale Triangle wave
BW = pi*f/(Fs*Q);
Wo = f*pi/Fs;
gain = 1/(1+sqrt(1/2).*tan(BW/2));
num  = (1-gain)*[1 0 -1]';
den  = [-2*gain*cos(Wo) (2*gain-1)]';
end