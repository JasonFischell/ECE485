function [Xwf, E, P] = STFT(x,N,M)
if (mod(N,2)~=0)
    error('N must be even')
end
if (mod(M,2)~=0)
    error('M must be even')
end


% the original signal is x
L = length(x);
% assume that N is even and M divideds N. There are instructions about zero
% padding but the buffer command does that itself.
y = buffer(x,N,N-M, 'nodelay');


% create the window
n = 0:N-1;
w = sqrt(2*M/N)*sin((pi/N)*(n+1/2));
w = w';
% We want this to be applied down every column, so we have to invert the
% vector w
Xw = bsxfun(@times, y,w); % this applies down the columns

% fft treats columns as vectors and returns fft down each column
Xmk = fft(Xw); % default is columns (dim = 1)
% note--use Xwf in calcs because Xmk contains redundant information
% because audio is real so the FFT has conjugate symmetry

Xwf = Xmk((1:(N/2)),:); % we assume that N is even
E = abs(Xwf).^2;
P = angle(Xwf);
end