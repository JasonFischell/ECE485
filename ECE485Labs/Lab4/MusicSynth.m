% Jason Fischell
% ECE 280 Lab 1: Music Synthesis
% Section ___

%% Setup
clear
fs = 44100;      % Set the sampling frequency of our discrete time wave to 8000 Hz
%t = @(d)[0:1/fs:d-(1/fs)];   % Make the duration of the note variable by making time t variable as a function of D
f = @(n) 440*2^(n/12);  % The frequency of each note based off of the base A frequency of 440 Hz

 % Each note x as a function of its modified frequency n and duration d
% The following assign the exponents n to the letter name of each note
LowD = -7; LowDs = -6; LowEf = -6; LowE = -5; LowF = -4; LowFs = -3;
LowGf = -3; LowG=-2; LowGs = -1; LowAf = LowGs; LowA=0; LowAs = 1; 
Bf = LowAs; B=2; C = 3; Cs = 4; Df = Cs; D=5; Ds = 6; Ef = Ds; E = 7;
F = 8; Fs = 9; Gf = Fs; G = 10; Gs = 11; Af = Gs; A = 12; 

n = 1;
% The following assign numbers to the duration of each musical note
s = n*1/16; % Sixteenth Note
ds = n*3/32;  % Dotted 16th Note
tpl = n*1/12; % Triplet
e = n*1/8; % Eighth note
de = n*3/16; % Dotted eighth
q = n*1/4; % Quarter note
dq = n*3/8; % Dotted Quarter note
h = n*.5; % Half Note
dh = n*.75; % Dotted half note
w = n*1; % Whole note

%% Make some music
% Main Component
n1 = [LowA,D,Fs,E,D,Fs,E,D,B,LowA,LowA,D,Fs,E,D,Fs,E,A,...
    Fs,A,Fs,D,LowA,B,D,D,B,LowA,LowA,D,Fs,E,D,Fs,E,D];
d1 = [q,h,tpl,tpl,tpl,h,q,h,q,h,q,h,tpl,tpl,tpl,h,q,w+q,...
    q,h,q,h,q,dq,e,e,e,h,q,h,tpl,tpl,tpl,h,q,dh+dh];

% Volume Variation Type 1
Song1 = zeros(1,1669766);
i = 1;
for k=1:numel(n1)
    temp = Lab4(f(n1(k)),d1(k));
    Song1(i+(0:length(temp)-1)) = temp;
    i = i + length(temp);
end
soundsc(Song1,fs);