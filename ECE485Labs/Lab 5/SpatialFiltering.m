% ECE 485 Lab 5
% Spring, 2019
% Jason Fischell and Greg Goldman
clear
close all


T = [682, 621, 573, 543];
[target, Fs] = audioread('target.wav');
mics = cell(4,1);

mics{1} = audioread('mic_1_4.wav');
mics{2} = audioread('mic_2_4.wav');
mics{3} = audioread('mic_3_4.wav');
mics{4} = audioread('mic_4_4.wav');

%% Part a)

idxs = 1:(length(mics{1})-max(T));

for k  = 1:2
    y2 = mics{k}(idxs + T(k));
end

for k  = 1:3
    y3 = mics{k}(idxs + T(k));
end

for k  = 1:4
    y4 = mics{k}(idxs + T(k));
end

soundsc(target, Fs)
disp('playing original')
pause

soundsc(mics{1}, Fs)
disp('playing mic 1')
pause

soundsc(y2, Fs)
disp('playing average of 1 and 2')
pause

soundsc(y3, Fs)
disp('playing average of 1, 2, and 3')
pause

soundsc(y4, Fs)
disp('playing average of 1, 2, 3, and 4')
disp('done part a')
pause


f = figure;
pwelch(target)
hold on
pwelch(mics{1})
pwelch(y2)
pwelch(y3)
pwelch(y4)
axp = f.Children;
axp.Children(1).Color = [0 0 1];
axp.Children(2).Color = [1 0 0];
axp.Children(3).Color = [0 1 0];
axp.Children(4).Color = [0 1 1];
axp.Children(5).Color = [0 0 0];
legend('target','1 mic', '2 mics avg', '3 mics avg', '4 mics avg')
title('Power Spectral Densities for Simple Averaging')




%% part b:-------------------------------------------
T1 = -717;
T2 = -517;
L1 = 1;
L2 = length(target) + T1;

U2 = zeros(L2-L1+1,2*(T2-T1+1));
for k = L1:L2
U2(k, :) = [mics{1}(k - (T1:T2))', mics{2}(k - (T1:T2))'];
end
h_hat2 = ((U2'*U2)^-1)*U2'*target(1:L2);
v_2 = U2*h_hat2;


U3 = zeros(L2-L1+1,3*(T2-T1+1));
for k = L1:L2
U3(k, :) = [mics{1}(k - (T1:T2))', mics{2}(k - (T1:T2))', mics{3}(k - (T1:T2))'];
end
h_hat3 = ((U3'*U3)^-1)*U3'*target(1:L2);
v_3 = U3*h_hat3;


U4 = zeros(L2-L1+1,4*(T2-T1+1));
for k = L1:L2
U4(k, :) = [mics{1}(k - (T1:T2))', mics{2}(k - (T1:T2))', mics{3}(k - (T1:T2))', mics{4}(k - (T1:T2))'];
end
h_hat4 = ((U4'*U4)^-1)*U4'*target(1:L2);
v_4 = U4*h_hat4;

disp('LLS regression solution to find filter coefs:')
soundsc(target,Fs)
disp('playing original')
pause

soundsc(v_2, Fs);
disp('playing 1,2')
pause

soundsc(v_3, Fs);
disp('playing 1,2,3')
pause

soundsc(v_4, Fs);
disp('playing 1,2,3,4')


h1_2 = h_hat2(1:201);
h2_2 = h_hat2(202:402);
[H1_2,w1_2] = freqz(h1_2,1);
[H2_2,w2_2] = freqz(h2_2,1);

figure
plot(w1_2/pi,20*log10(abs(H1_2)))
title('2 mic filters')
hold on
plot(w2_2/pi,20*log10(abs(H2_2)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
grid on
legend('mic1 filter', 'mic2 filter')

figure
subplot(2,1,1)
plot(w1_2/pi,20*log10(abs(H1_2)))
title('mic 1')
ylabel('Magnitude (dB)')
a1 = gca;
grid on
subplot(2,1,2)
plot(w2_2/pi,20*log10(abs(H2_2)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
linkaxes([gca, a1], 'xy');
grid on
title('mic 2')

%---------------------------------------------------

h1_3 = h_hat3(1:201);
h2_3 = h_hat3(202:402);
h3_3 = h_hat3(403:603);
[H1_3,w1_3] = freqz(h1_3,1);
[H2_3,w2_3] = freqz(h2_3,1);
[H3_3,w3_3] = freqz(h3_3,1);
figure
plot(w1_3/pi,20*log10(abs(H1_3)))
hold on
plot(w2_3/pi,20*log10(abs(H2_3)))
plot(w3_3/pi,20*log10(abs(H3_3)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
legend('h1', 'h2', 'h3')
title('3 mic filters')
grid on

figure
subplot(3,1,1)
plot(w1_3/pi,20*log10(abs(H1_3)))
ylabel('Magnitude (dB)')
a1 = gca; 
title('mic 1')
ylabel('Magnitude (dB)')
grid on

subplot(3,1,2)
plot(w2_3/pi,20*log10(abs(H2_3)))
a2 = gca; 
title('mic 2')
ylabel('Magnitude (dB)')
grid on

subplot(3,1,3)
plot(w3_3/pi,20*log10(abs(H3_3)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
title('mic 3')
linkaxes([a1 a2 gca], 'xy')
grid on
%-------------------------------


h1_4 = h_hat4(1:201);
h2_4 = h_hat4(202:402);
h3_4 = h_hat4(403:603);
h4_4 = h_hat4(604:804);
[H1_4,w1_4] = freqz(h1_3,1);
[H2_4,w2_4] = freqz(h2_3,1);
[H3_4,w3_4] = freqz(h3_3,1);
[H4_4,w4_4] = freqz(h3_3,1);

figure
plot(w1_4/pi,20*log10(abs(H1_4)))
hold on
plot(w2_4/pi,20*log10(abs(H2_4)))
plot(w3_4/pi,20*log10(abs(H3_4)))
plot(w4_4/pi,20*log10(abs(H4_4)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
legend('h1', 'h2', 'h3', 'h4')
title('4 mic filters')
grid on

figure
subplot(4,1,1)
plot(w1_4/pi,20*log10(abs(H1_4)))
ylabel('Magnitude (dB)')
title('mic 1 filter')
grid on
a1 = gca;


subplot(4,1,2)
plot(w2_4/pi,20*log10(abs(H2_4)))
ylabel('Magnitude (dB)')
title('mic 2 filter')
grid on
a2 = gca;

subplot(4,1,3)
plot(w3_4/pi,20*log10(abs(H3_4)))
ylabel('Magnitude (dB)')
title('mic 3 filter')
grid on
a3 = gca;

subplot(4,1,4)
plot(w4_4/pi,20*log10(abs(H4_4)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
title('mic 4 filter')
linkaxes([a1, a2, a3, gca], 'xy');
grid on


f = figure;
pwelch(target)
hold on
pwelch(v_2)
pwelch(v_3)
pwelch(v_4)

axa = f.Children;
axa.Children(1).Color = [0 0 1];
axa.Children(2).Color = [1 0 0];
axa.Children(3).Color = [0 1 0];
axa.Children(4).Color = [0 0 0];
legend('target', '2 mic response', '3 mic response', '4 mic response')

f = figure;
pwelch(target)
hold on
pwelch(v_2)
axb = f.Children;
axb.Children(1).Color = [0 0 1];
axb.Children(2).Color = [1 0 0];
legend('target', '2 mic response')

f = figure;
pwelch(target)
hold on
pwelch(v_3)
axc = f.Children;
axc.Children(1).Color = [0 0 1];
axc.Children(2).Color = [1 0 0];
legend('target', '3 mic response')

f = figure;
pwelch(target)
hold on
pwelch(v_4)
axd = f.Children;
axd.Children(1).Color = [0 0 1];
axd.Children(2).Color = [1 0 0];
legend('target', '4 mic response')

linkaxes([axa axb axc axd], 'xy')