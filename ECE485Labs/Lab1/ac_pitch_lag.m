function [freqs, n0] = ac_pitch_lag(x,L,M,Fs,Fmin,Fmax,t,fig)
if ~exist('t','var')
    % if threshold is not defined, default to 20%
    t = 0.2;
end
if ~exist('fig','var')
    fig = 1;
end
k = 1:((ceil((length(x)-(2.*L))./M)));
xLong = [zeros(1,length(x)),x',zeros(1,length(x))];
xShifter = @(n) xLong(n+length(x));
n0 = round(M.*(k-1)+1);
j = floor(Fs./Fmax):ceil(Fs./Fmin);
A = zeros(1,length(j));
maxInd = zeros(1,length(k));
lMax = Fs/Fmin;
lMin = Fs/Fmax;
maxVal = -1.*ones(1,k(end));
maxPeriod = -1.*ones(1,k(end));
for a = k
    for b = j
        A = xShifter(ceil((0:((2*lMax)-1)+n0(a))))*conj(xShifter(ceil((0:((2*lMax)-1)+n0(a))-b)))';
        if (A>maxVal(a))
            maxVal(a) = A;
            maxPeriod(a) = b;
            halfA = xShifter(ceil((0:((2*lMax)-1)+n0(a))))*conj(xShifter(ceil((0:((2*lMax)-1)+n0(a))-(b/2))))';
            if (.8*A < halfA) && (ceil(b/2)>lMin)
                maxVal(a) = halfA;
                maxPeriod(a) = b/2;
            end      
        end
    end
end
        %length(x(n0(a):(n0(a)+(2*L)-1)))
%         range = (n0(a):(n0(a)+(2*L)-1));
%         if ((range(1)-j(end))>0)
%             x(range)
%             x(range - b)
%             %A(b) = dot(x(range),conj(x(range - b)));
%         end
        %maxInd(a) = n0(a) + maxInd(a)

%freqs = 1;
freqs = Fs./maxPeriod;
 
figure(fig); clf; fig = fig+1;
plot(n0./Fs,freqs,'k*')
xlabel('Time in Signal (s)')
ylabel('Frequency (Hz)')
axis([n0(1)./Fs, (n0(end)+1)./Fs,Fmin, Fmax])
hold on
%plot(1:length(freqs),12*log2(freqs/440),'k-')

