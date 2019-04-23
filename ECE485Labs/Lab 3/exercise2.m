clear
close all
[y Fs] = audioread('notawhisper.wav');
N = 512;
M = 256;
[Xwf, E, P] = STFT(y,N,M);
P=2*pi*rand(size(P));

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

[yy Fs2] = audioread('whisper.wav');
Fstop = .01.*Fs;
Fpass = .04.*Fs;
Astop = 60;
Apass = 0.5;

d = designfilt('highpassiir','StopbandFrequency',Fstop ,...
  'PassbandFrequency',Fpass,'StopbandAttenuation',Astop, ...
  'PassbandRipple',Apass,'SampleRate',Fs,'DesignMethod','butter');
filtered = filter(d,xx);

figure
pwelch(xx, ones(1,256));
hold on
pwelch(yy, ones(1,256));
pwelch(filtered,  ones(1,256));
legend('fake whisper', 'real whisper', 'processed whisper')

soundsc(xx,Fs)
disp('playing fake whisper')
pause

soundsc(yy,Fs2)
disp('playing real whisper')
pause

soundsc(filtered,Fs2)
disp('playing processed whisper')




