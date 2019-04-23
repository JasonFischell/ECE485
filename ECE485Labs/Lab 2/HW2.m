% Jason Fischell
% ECE 485 - HW2
% Dr. Pfister
close all

%% 1. DTFT of Sampled Sin
% a
F = 0.25;                               % Set F
x = @(t) sin(2.*pi.*F.*t + (pi./4));    % Create Function
t = -10:.01:10;                         % Effectively continous range of times
figure(); clf
plot(t,x(t))                            % Plot
xlabel('t')
ylabel('x_a(t)')
title('x_a(t) in (effectively) Continuous Time')

% b
n = -10:10;                             % Discrete range of times
figure(); clf
stem(n, x(n))                           % Plot
xlabel('n')
ylabel('x_a[n]')
title('x_a[n] in Discrete Time')

% c
yn = sin(2*pi*0.25*(0:99)+pi/4);       % Given function
w = -3.14:0.01:3.14;                   % Range of frequencies
Yw = zeros(1,length(w));
% Add for loop code here to compute the DTFT Yw(k) for w=w(k)
for a = 1:length(w)
    for b = 1:length(yn)
        Yw(a) = Yw(a) + (yn(b).*exp(-1j.*w(a).*(b-1)));         % Code to approximate DTFT
    end
end
figure(); clf
subplot(2,1,1);                        % Plot Magnitude of DTFT
plot(w,abs(Yw));
xlabel('Angular Frequency \omega');
ylabel('Magnitude of Y(\omega)');
title('Magnitude Analysis of y[n] DTFT')
subplot(2,1,2);                        % Plot Phase of DTFT
plot(w,angle(Yw));
xlabel('Angular Frequency \omega');
ylabel('Phase of Y(\omega)');
title('Phase Analysis of y[n] DTFT')


%% 2 - Convolution
x = [1 2 3 5 2 4];                     % First sequence
h = [4 0 -2 3 1];                      % Second sequence
% a                                    PLOT
figure(); clf
stem(-3:2,x,'k')                        
hold on
stem(-1:3,h,'b')
hold off
title('Discrete Signals x[n] and h[n]')
xlabel('n')
ylabel('x[n], h[n]')
legend('x[n]','h[n]','location','best')
axis([-3.5 3.5 -2 5])

% b
xh = conv(x,h);                             % Convolve
xhVal = conv([0,0,0,1,0,0],[0,1,0,0,0]);    % Convolve deltas to determine 0 position
xhVal = find(xhVal);                        % Determine 0 position
hx = conv(h,x);                             % Convolve
hxVal = conv([0,1,0,0,0],[0,0,0,1,0,0]);    % Convolve deltas to determine 0 position
hxVal = find(hxVal);                        % Determine 0 position
figure(); clf
stem((1-xhVal):length(xh)-xhVal,xh,'kx')    % Plot two convolutions to confirm convolution is commutative
hold on
stem((1-hxVal):length(hx)-hxVal,hx,'bo')
hold off
title('Convolutions of x[n] and h[n]')
xlabel('n')
ylabel('Convolution')
legend('x[n]*h[n]', 'h[n]*x[n]','location','best')
axis([-4.5 5.5 0 20])


% c - Prove that convolution in time domain is multiplication in frequency
% domain
DTFTConv = fft(xh,11);  
DTFTConv = fftshift(DTFTConv);
DTFTMult = fft(x, length(DTFTConv)).*fft(h,length(DTFTConv));
DTFTMult = fftshift(DTFTMult);
figure(); clf
subplot(2,1,1)
plot(linspace(-pi,pi,11),abs(DTFTConv))
title('Magnitude of DTFT from fft(x*h)')
xlabel('Frequency \omega')
ylabel('Magnitude')
subplot(2,1,2)
plot(linspace(-pi,pi,11),abs(DTFTMult))
title('Magnitude of DTFT from Product of fft(x)fft(h)')
xlabel('Frequency \omega')
ylabel('Magnitude')





%% 3. Filtered Speech
Fs = 44100;
r = audiorecorder(Fs, 16, 1);
disp('Recording: press return to stop');
record(r); % speak into microphone...
pause;
stop(r);
x = getaudiodata(r);
disp('Playing unfiltered');
soundsc(x,Fs);
pause;
LPF = ones(1,80)./80;
y = conv(x,LPF);
disp('Playing LPF Filter');
soundsc(y,Fs);
pause;
HPF = ((-1).^(1:80))/80;
y2 = conv(x,HPF);
disp('Playing Nyquist Pass Filter');
soundsc(y2,Fs);

LPFfft = fft(LPF,81);
LPFfft = fftshift(LPFfft);

HPFfft = fft(HPF,81);
HPFfft = fftshift(HPFfft);

figure(); clf
subplot(2,1,1)
plot(linspace(-pi,pi,length(LPFfft)),abs(LPFfft))
title('Frequency Domain of LPF')
xlabel('Frequency \omega')
ylabel('Magnitude')
axis([-3.2,3.2,0,1])
subplot(2,1,2)
plot(linspace(-pi,pi,length(HPFfft)),abs(HPFfft))
title('Frequency Domain of HPF')
xlabel('Frequency \omega')
ylabel('Magnitude')
axis([-3.2,3.2,0,1])