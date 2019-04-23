% 1. generate random complex and show ifft of certina type is real
close all
x = randn(1,256);
X = fftshift(fft(x));
xx = conj(fliplr(X(2:end)))-X(2:end);
figure()
subplot(3,1,1)
plot(-length(X)/2:length(X)/2-1,real(X),'k-')
title('Real(X[k])')
xlabel('k')
ylabel('Real(X[k])')
subplot(3,1,2)
plot(-length(X)/2:length(X)/2-1,imag(X),'b-')
title('Imag(X[k])')
xlabel('k')
ylabel('Imag(X[k])')
subplot(3,1,3)
plot(-length(xx)/2:length(xx)/2-1,xx,'r-')
title('X[-k]* - X[k]')
xlabel('k')
ylabel('X[-k]* - X[k]')


Y = (randn(1,256)+1i*randn(1,256))/sqrt(2);
Z = Y+conj([Y(1) fliplr(Y(2:end))]);
z = ifft(Z);
figure()
subplot(2,2,1);
plot(-length(Z)/2:length(Z)/2-1,real(Z),'k-')
title('Real(Z)')
subplot(2,2,2);
plot(-length(Z)/2:length(Z)/2-1,imag(Z),'k-')
title('Imag(Z)')
subplot(2,2,3);
plot(-length(Z)/2:length(Z)/2-1,real(z),'k-')
title('Real(z)')
subplot(2,2,4);
plot(-length(Z)/2:length(Z)/2-1,imag(z),'k-')
title('Imag(z)')
