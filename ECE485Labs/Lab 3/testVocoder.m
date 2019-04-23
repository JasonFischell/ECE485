clear
close all
[x, Fs] = audioread('singing44.wav');

% default case is a = 1/2, N = 1024, M = N/2
%x_hat = phaseVocoder(x);
%soundsc(x,Fs)
%disp('playing original')
%pause
% soundsc(x_hat,Fs)
% disp('playing reconstructed')
% audiowrite('exercise3.wav',x_hat,Fs)
% pause
% 
% % Generally, increasing N and decreasing M provides better sound. 
% % Here is an example of a constant M and increasing N for doubling the time
% a = 1/2;
% N = 256;
% M=64;
% x_hat2 = phaseVocoder(x,a,N,M);
% soundsc(x_hat2,Fs)
% disp('playing low N')
% pause
% 
% a = 1/2;
% N = 2048;
% M=64;
% x_hat2 = phaseVocoder(x,a,N,M);
% soundsc(x_hat2,Fs)
% disp('playing high N')
% 
% % decreasing M tends to improve sound quality (fewer clicks, less metalic), but it takes longer to run
% a = 1/2;
% N = 2048;
% M=N/2;
% x_hat2 = phaseVocoder(x,a,N,M);
% soundsc(x_hat2,Fs)
% disp('playing large N')
% pause 
% 
% a = 1/2;
% N = 2048;
% M=64;
% x_hat2 = phaseVocoder(x,a,N,M);
% soundsc(x_hat2,Fs)
% disp('playing small M')
% 
% % smaller a results in a longer signal:
% a = 1/2;
% N = 2048;
% M=64;
% x_hat2 = phaseVocoder(x,a,N,M);
% soundsc(x_hat2,Fs)
% disp('playing small a=0.5 -> longer')
% pause 
% 
% 
% a = 2;
% N = 2048;
% M=64;
% x_hat2 = phaseVocoder(x,a,N,M);
% soundsc(x_hat2,Fs)
% disp('playing larger a=2 -> shorter')

%----------------------------------------------------------------------
% Exercise 4
a = 17/18;
N = 1024;
M = 128;
x_hat = phaseVocoder(x,a,N,M);
% this preserves the timescale and uses an antialiasing filter of the order
% 2*100*max(p,q = 17,18) = 2*18*100 = 3600
% the result is the pitch is shifted up by a factor of 18/17 = 2^(1/12)
x_hat_resampled = resample(x_hat,17,18,100);
%soundsc(x_hat_resampled, Fs);
%disp('first reconstruction')
audiowrite('exercise4.wav', x_hat_resampled, Fs);
pause

% This one sounds just a bit higher than the original
p = 50;
q = 63;
a = p/q;
N = 2048;
M = 64;
x_hat = phaseVocoder(x,a,N,M);
% this preserves the timescale and uses an antialiasing filter of the order
% 2*100*max(p,q = 17,18) = 2*18*100 = 3600
% the result is the pitch is shifted up by a factor of 18/17 = 2^(1/12)
x_hat_resampled = resample(x_hat,p,q,100);
soundsc(x_hat_resampled, Fs);
disp('clearer with better N (larger) and M (smaller)')
