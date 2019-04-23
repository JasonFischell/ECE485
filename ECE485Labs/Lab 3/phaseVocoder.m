function x_hat = phaseVocoder(x,varargin)
% arguments are the input signal x[n], the time-scaling factor ?,
% the window length N, and the shift length M.
% h_hat = phaseVocoder(x,a,N,M);

% The function will return the time-scale modified signal x?[n]
% whose length is roughly 1/? times the length of x[n]
if (nargin ==1)
    a = 1/2;
    N = 1024;
    M = N/2;
elseif(nargin == 4)
    a = varargin{1};
    N = varargin{2};
    M = varargin{3};
else
    error('incorrect number of input arguments')
end
% ------------------------------------
% a) use your STFT analysis function to implement the filter bank and
% compute E and P
[~, E, P] = STFT(x,N,M);
% ------------------------------------
% b)
% new signal is roughly 1/a times the length of x(n) (original signal)
[rows, m_max] = size(E);
L = 1:(floor((m_max-2)/a) - ceil(1/a)-1);
t1 = 1+a*(L-1);
% k is the sample points
% E is the original data
% t is the set of query points/times for interpolation
E1 = (ceil(t1)-t1).*E(:,floor(t1)) + (1-ceil(t1) + t1).*E(:,ceil(t1));
% ------------------------------------
% c) constructing the delta-phase matrix D
k = (1:rows)'; % add to each row
D = mod((diff(P,1,2) - 2*pi*k*M/N), 2*pi);
t2 = 1+a*(L-1/2);
% d) Constructing the interpolated delta-phase matrix
D1 = (ceil(t2+1/2) - t2 - 1/2).*D(:,floor(t2+1/2)) + (1-ceil(t2+1/2)+t2+1/2).*D(:,ceil(t2+1/2));
P1 = zeros(rows,length(t2));
P1(:,1) = P(:,1);
% The line below was already defined above
for i=2:length(t2)
    P1(:,i) = P1(:,i-1) + D1(:,i) + 2.*pi.*k.*M./N;
end
% ------------------------------------
% e) reconstruct an estimate of the signal, adding back the part with
% conjugate symmetry
i = sqrt(-1); % I think I overwrote this. So just to make sure...
Xm_hat = sqrt(E1).*exp(1i*P1);
hXwf = [Xm_hat; flipud(Xm_hat)];
%hXwf = [Xwf; flipud(Xwf)];
hXwfi = real(ifft(hXwf));

% combine the different oservations of x[n] together to form the
% signal reconstruction
[~, cols] = size(hXwfi);
m_max = cols; % = length(hXwfi)
x_hat = zeros(1,m_max*M+N-M);
[~, m_max] = size(hXwfi);

nn = 0:N-1;
w = sqrt(2*M/N)*sin((pi/N)*(nn+1/2));
for n = 1:N
    for m = 0:m_max %cols/M = m_max
        if ((m+1) > m_max)
            break
        end
        x_hat(n+m*M) = x_hat(n+m*M) + w(n).*hXwfi(n,m+1);
    end
end
% x_hat is now the recostructed signal
end