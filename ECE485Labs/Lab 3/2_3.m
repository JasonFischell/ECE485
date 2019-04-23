clear
close all
[y ~] = audioread('singing8.wav');
N = 256;
M = 64;
[Xwf, E, P] = STFT(y,N,M);


Xm_hat = sqrt(E).*exp(1i*P);

hXwf = [Xm_hat, fliplr(Xm_hat(1:end-1))];

k = 1:length(hXwf);
hWwfi = 1./N.*sum(hXwf.*exp(2.*pi.*k./N));