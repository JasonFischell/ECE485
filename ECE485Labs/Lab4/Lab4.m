% Jason Fischell and Greg Goldman
% Dr. Henry Pfister
% ECE 485
% Lab 4 - Physical Synthesis via the Wave Equation 

%% Calibrate the parameters of the model
function [note] = Lab4(f, d)
%f = 220;
fs = 44100;
N = 2.*round(fs./(f*2));% Make sure the value of N is even, based on f (^)

%top = [zeros(1,N/8), .25.*(sawtooth(linspace(0, 2.*pi, N/4),0.5)+1), zeros(1,N/8)];
%top = sin(linspace(0,pi,N/2+1))/2;
%top = top(1:N/2);
%bot = fliplr(top);

top = .25*(sawtooth(linspace(0, 2.*pi, N/2),0.2)+1);
top = top(1:N/2);
bot = top;

g = 0.995;
a = 0.02;


%top = .25*(sawtooth(linspace(0, 2.*pi, N/2),0.2)+1);
%bot = fliplr(-top);
%pluck = .25*(sawtooth(linspace(0, 2.*pi, N),0.1)+1);
%plot(1:N, pluck)

%plot(1:N, [top,bot])%, 'k-', 1:N/2, bot, 'b-')
graph = 0;
if graph
    cycles = 10;
else 
    cycles = round(1830.*60.*d./72);
    note = zeros(1,cycles*N+1);
end

for i = 1:round(cycles*N)+1
    if graph
        plot(1:N/2, top, 'k-', 1:N/2, bot, 'r-');
        hold on
        plot(1:N/2, top+bot, 'b-');
        hold off
        ylim([-2,2])
        pause(0.01)
    else
        note(i) = top(round(N/5))+bot(round(N/5));
        
    end
    [top, bot] = delay(top, bot, g, a);
end
%nnz(note)
%soundsc(note, fs)

