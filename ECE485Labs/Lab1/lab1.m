% Jason Fischell & Hannah Wilen
% Lab 1
% ECE 485 - Dr. Pfister
% Due: February 1, 2019
close all; 
fig = 1;

%% Exercise 1
%1a
% DD = dirac((-10^4:1:10^4));
% DD(10^4 + 1) = 1;
% [ac1a, Lags1a] = xcorr(DD);
% figure(fig); clf; fig = fig+1;
% stem(Lags1a, ac1a)
% title('Exercise 1a: Delta Dirac Autocorrelation')
% xlabel('Lag')
% ylabel('Magnitude of Autocorrelation')
% 
% % 1b
% n1b = -30:1:30;
% x1b = cos(2.*pi.*n1b./20);
% 
% [ac1b, Lags1b] = xcorr(x1b);
% figure(fig); clf; fig = fig+1;
% stem(Lags1b, ac1b./max(ac1b))
% title('Exercise 1b: Cosine Autocorrelation')
% xlabel('Lag')
% ylabel('Magnitude of Autocorrelation')
% 
% % 1c
% n50 = -50:50;
% n50(51) = eps;
% n250 = -250:250;
% n250(251) = eps; 
% 
% x1c = @(n) (2./(pi.*n)).*(sin((pi.*n)./2));
% 
% [ac1c50, Lags1c50] = xcorr(x1c(n50), 'coeff');
% figure(fig); clf; fig = fig+1;
% subplot(2,1,1)
% stem(n50, x1c(n50))
% axis([min(Lags1c50), max(Lags1c50), -.4, 1])
% title('Exercise 1c: -50:50 Cosine Signal')
% xlabel('n')
% ylabel('x[n]')
% subplot(2,1,2)
% stem(Lags1c50, ac1c50./max(ac1c50))
% title('Exercise 1c: -50:50 Cosine Autocorrelation')
% xlabel('Lag')
% ylabel('Magnitude of Autocorrelation')
% 
% [ac1c250, Lags1c250] = xcorr(x1c(n250));
% figure(fig); clf; fig = fig+1;
% subplot(2,1,1)
% stem(n250, x1c(n250))
% axis([min(Lags1c250), max(Lags1c250), -.4, 1])
% title('Exercise 1c: -250:250 Cosine Signal')
% xlabel('n')
% ylabel('x[n]')
% subplot(2,1,2)
% stem(Lags1c250, ac1c250./max(ac1c250))
% title('Exercise 1c: -250:250 Cosine Autocorrelation')
% xlabel('Lag')
% ylabel('Magnitude of Autocorrelation')
% 
% figure(fig); clf; fig = fig+1;
% stem(1:50, abs(x1c(1:50)))
% hold on
% plot(Lags1c50(101:151),abs(ac1c50(101:151)))
% hold off
% 
% %% Exercise 2
% % 2a
% x2a = @(n) (n>=0).*(n<=99).*cos(.2.*pi.*n);
% n2a = 0:99;
% 
% [ac2a, lags2a] = xcorr(x2a(n2a), 'coeff');
% figure(fig); clf; fig = fig+1;
% subplot(1,2,1)
% stem(n2a, x2a(n2a))
% title('Exercise 2a: Cosine Signal')
% xlabel('n')
% ylabel('x[n]')
% 
% subplot(1,2,2)
% stem(lags2a, ac2a)
% title('Exercise 2a: Cosine Autocorr')
% xlabel('Lags')
% ylabel('Normalized Autocorrelation')
% 
% % 2b
% n2b = 0:99;
% x2b = @(n) (n>=0).*(n<=99).*cos(pi.*n.*n./800);
% 
% [ac2b, lags2b] = xcorr(x2b(n2b), 'coeff');
% 
% figure(fig); clf; fig = fig+1;
% subplot(1,2,1)
% stem(n2b, x2b(n2b))
% title('Exercise 2b: Chirp Signal')
% xlabel('n')
% ylabel('x[n]')
% 
% subplot(1,2,2)
% stem(lags2b, ac2b)
% title('Exercise 2b: Chirp Autocorr')
% xlabel('Lags')
% ylabel('Normalized Autocorrelation')
% 
% % 2c - Talk about it
% 
% % 2d - Simulate Performance
% newCos = @(n) x2a(n)./(sqrt(sum(x2a(n).^2)));
% newChirp = @(n) x2b(n)./(sqrt(sum(x2b(n).^2)));
% 
% runs = 100;
% cosMaxInd = zeros(1,runs);
% chirpMaxInd = zeros(1,runs);
% cosCorrect = 0;
% chirpCorrect = 0; 
% delay = 2000;
% n2d = (0:9999)-delay;
% 
% for ii = 1:runs
%     z = randn([1,10000]);
%     ycos = 5.*newCos(n2d) + z;
%     [acCos, LagCos] = xcorr(ycos, x2a(n2a)); 
%     [valCos, indCos] = max(acCos);
%     cosMaxInd(ii) = indCos - delay - length(ycos);
%     if cosMaxInd(ii) == 0
%         cosCorrect = cosCorrect + 1;
%     end
%     
%     yChirp = 5.*newChirp(n2d)+z;
%     [acChirp, LagChirp] = xcorr(yChirp, x2b(n2b)); 
%     [valChirp, indChirp] = max(acChirp);
%     chirpMaxInd(ii) = indChirp - delay - length(yChirp);
%     if chirpMaxInd(ii) == 0
%         chirpCorrect = chirpCorrect + 1;
%     end
% end
% figure(fig); clf; fig = fig+1;
% stem(LagChirp(8000:end), acChirp(8000:end))
% 
% cosAvgErr = mean(abs(cosMaxInd));
% chirpAvgErr = mean(abs(chirpMaxInd));
% cosCorrect = 100.*cosCorrect./runs;
% chirpCorrect = 100.*chirpCorrect./runs;
% Ans2d = [cosAvgErr, chirpAvgErr; cosCorrect, chirpCorrect]
% 
% % 2E
% T = 10^-5;
% f = 1/T;
% yUltra = load('ultra_test.txt')';
% 
% [acUltra, LagUltra] = xcorr(yUltra, x2b(n2b)); 
% [valUltra, indUltra] = max(acUltra);
% %figure(fig); clf; fig = fig+1;
% %stem(LagUltra, acUltra)
% UltraError = indUltra - floor(length(LagUltra)/2);
% distance = .5*1000.*(UltraError./f)

%% Problem 4 - Pitch Tracking
%% 
% Practical Method 1: Windowing
Test = 0; 
Chirp = 0;
Recording = 0;
UseRecorded = 1;
AutoCorr = 1;


if Test 
    Fs = 22050;
    Fmin = 100;
    Fmax = 1200;
    L = 2.*ceil(Fs./Fmin);
    M = L/2; 
    xTest = @(n) cos(2.*pi.*n.*(Fmin+Fmax)/(2.*Fs)).^3;
    n = 1:10000;
    x = xTest(n);
    t = 0;
end

if Chirp 
    Fs = 22050;
    Fmin = 100;
    Fmax = 200;
    L = 2.*ceil(Fs./Fmin);
    M = L/2; 
    Q = (Fmax-Fmin).*L;
    xChirp = @(n) (cos((2.*pi*n./Fs).*(Fmin + (((Fmax-Fmin).*n)./(Q.*2)))).^3).*(n<=Q).*(n>0);
    n = 1:2*Fs;
    x = xChirp(n);
    t = 0.2;
end

if UseRecorded
    [x,Fs] = audioread('singing44.wav');
    Recording = 1;
end

if Recording
    if ~UseRecorded
        r = StandardAudioRecorder(1,0);
        Fs = r.SampleRate;
        x = getaudiodata(r)';
    end
    Fmin = 50;
    Fmax = 2000;
    L = 2.*ceil(Fs./Fmin);
    M = L/2; 
    t = 0.5;
end

Fstop = 100;
Fpass = 50;
Astop = 60;
Apass = 0.5;

figReset = fig;
if AutoCorr
    %tic
    [freqs, n0] = ac_pitch(x,L,M,Fs,Fmin,Fmax,t,fig); 
   % toc
end
if ~AutoCorr
    [freqs, n0] = ac_pitch_lag(x,L,M,Fs,Fmin,Fmax,t,fig); 
end
freqsOrig = freqs;

time = n0./Fs;
figure(fig); clf; fig = fig+1;
plot(n0./Fs,freqs,'k-',n0./Fs, freqsOrig, 'b-')
xlabel('Time in Signal (s)')
ylabel('Frequency (Hz)')
axis([n0(1)./Fs, (n0(end)+1)./Fs,Fmin, Fmax])
hold on
if Recording
    plot(n0, 329.63.*ones(1,length(freqs)), 'r-')
    plot(n0, 246.94.*ones(1,length(freqs)), 'g-')
    plot(n0, 196.*ones(1,length(freqs)), 'm-')
    plot(n0, 146.83.*ones(1,length(freqs)), 'c-')
    plot(n0, 110.*ones(1,length(freqs)), 'y-')
    plot(n0, 82.41.*ones(1,length(freqs)), 'b-')
    legend('Threshold Data','E_4 = 329.63 Hz','B_3 = 246.94 Hz ','G_3 = 196.00 Hz','D_3 = 146.83 Hz','A_2 = 110.00 Hz','E_2 = 82.41 Hz','location','best')
    title('Thresholded Data vs. Guitar String Frequencies')
end
if Test
    plot(time,((Fs.*(2.*pi.*(Fmin+Fmax)/(2.*Fs)))./(2.*pi)).*ones(1,length(freqs)),'b-')
    legend('Raw Data (t=0)','Instantaneous Freq')
    title('Raw Data vs. Constant Instantaneous Frequency')
end
if Chirp
    plot(time,((Fs.*(((2.*pi./Fs).*(Fmin + (((Fmax-Fmin).*(n0))./(Q))))))./(2.*pi)),'b-')
    legend('Raw Data (t=0.2)','Instantaneous Freq')
    title('Raw Data vs. Constant Instantaneous Frequency')
end
hold off

fig = fig+figReset;