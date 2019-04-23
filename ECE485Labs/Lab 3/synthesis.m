clear
close all
[y Fs] = audioread('singing8.wav');
N = 256;
M = 64;
[Xwf, E, P] = STFT(y,N,M);

% reconstruct an estimate of the signal, adding back the part with
% conjugate symmetry
Xm_hat = sqrt(E).*exp(1i*P);
hXwf = [Xm_hat; flipud(Xm_hat)];
%hXwf = [Xwf; flipud(Xwf)];
hXwfi = real(ifft(hXwf));


% part c) combine the different oservations of x[n] together to form the
% signal reconstruction
m_max = length(hXwfi);
xx = zeros(1,m_max*M+N-M);
[rows, cols] = size(hXwfi);

nn = 0:N-1;
w = sqrt(2*M/N)*sin((pi/N)*(nn+1/2));
for n = 1:N
    for m = 0:cols %cols/M = m_max
        if ((m+1) > cols)
            break
        end
        xx(n+m*M) = xx(n+m*M) + w(n).*hXwfi(n,m+1);
    end
end
