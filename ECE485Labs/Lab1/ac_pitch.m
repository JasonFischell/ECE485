function [freqs, n0] = ac_pitch(x,L,M,Fs,Fmin,Fmax,t,fig)
if ~exist('t','var')
    % if threshold is not defined, default to 20%
    t = 0.2;
end
if ~exist('fig','var')
    fig = 1;
end
wFun = @(n, L) (n>=0).*(n<=(L-1)).*(sin((pi.*n)./(L-1))).^2;
k = 1:((ceil((length(x)-(2.*L))./M)));
n0 = round(M.*(k-1)+1);
w = wFun(1:2*L, L);
xMat = zeros(k(end),2*L);
auto = zeros(k(end),4*L-1);
lags = zeros(k(end),4*L-1);
size(lags)
maxesForLag = zeros(1,k(end));
indForLag = zeros(1,k(end));
for a = k
    xMat(a,:) = x(n0(a):2*L+n0(a)-1);
    [auto(a, :), lags(a,:)] = xcorr(w.*xMat(a,:),'coeff');
    %A = conj(x(n0(a) + (0:(L-1))))*x(n0(a) + (0:(L-1))'+(0:L));
    %[maxesForLag(1,a), indForLag(1,a)] = max(A);
    %figure(fig); clf; fig = fig+1;
    %plot(lags(a,:),auto(a,:))
end
interesting = auto(:,ceil(length(auto)/2)+floor(Fs/Fmax):ceil(length(auto)/2)+ceil(Fs/Fmin));
maxVal = zeros(1,k(end));
maxInd = zeros(1,k(end));
problemInd = -1.*ones(1,a);
for a = k
    [maxVal(a), maxInd(a)] = max(interesting(a,:));
    maxInd(a) = maxInd(a) + ceil(length(auto)/2) + floor(Fs/Fmax);
    %figure(fig); clf; fig = fig+1;
    %plot(lags(a,ceil(length(auto)/2)+floor(Fs/Fmax):ceil(length(auto)/2)+ceil(Fs/Fmin)),interesting(a,:))
    if abs(maxVal(a)) < t
        problemInd(a) = a;
    end
end

%lags(a,maxInd(a))
lagAtMax = zeros(1,k(end));
freqs = zeros(1,k(end));
for a = k   % Iterates over each of the k windows
    lagAtMax(a) = lags(a,maxInd(a));    % Puts the lag of each max in a matrix
    testHalf = floor(lagAtMax(a)./2);   % Finds half lag (period) to check for frequency doubling
    toFind = lags(a,:) - testHalf;      % Subtract half lag from vector of lags -> one zero value where lag(n) = halflag
    toFind = (toFind == 0);             % Convert to binary, only one '1' at the index 'n' of lag where lag(n) = halflag
    ind = find(toFind);                 % Returns the one index n described above
    %if (ind >= ceil(length(auto)/2)+floor(Fs/Fmax) && (ind<=ceil(length(auto)/2)+ceil(Fs/Fmin)))       %If this index is within the permitted range between Fmin and Fmax
    if ((auto(ind) >= .8*maxVal(a)))% && (((Fs/testHalf)>Fmin)) && ((Fs/testHalf)<Fmax))      %If the autocorrelation at half period (ind) is greater than 80% of the autocorrelation at the full period
        lagAtMax(a) = testHalf;     % new Lag at max AC becomes the half lag
        maxVal(a);
        maxVal(a) = auto(ind);      % Value of the AC becomes the value at halfLag
        maxVal(a);
    end

    freqs(a) = (Fs./lagAtMax(a));
    %maxesForLag(1,a);
    %freqs(a) = Fs./maxesForLag(1,a);
    if sum(ismember(a,problemInd))
        freqs(a) = NaN;
    end
end

figure(fig); clf; fig = fig+1;
%plot(1:length(freqs),12*log2(freqs/440),'k-')

