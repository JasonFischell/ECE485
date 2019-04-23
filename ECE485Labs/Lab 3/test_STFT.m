clear
close all
[y ~] = audioread('singing8.wav');
N = 256;
M = 64;
[Xwf, E, P] = STFT(y,N,M);

figure
imagesc(log10(E))
colorbar
