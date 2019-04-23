
% Lab 2 
% Exerise B
[x, Fs] = audioread('singing44.wav');
p = 860; q = 766;
y = zeros(1, length(x)+1);
i = 0;
while i > -1
    for j = 0:q-1
        try 
            y(q.*i + j + 1) = x(floor(q.*i + p.*j./q) + 1);    
        catch
            i = -2;
        end
    end
    i = i+1;
end
%soundsc(x,Fs);
%pause
%soundsc(y, Fs);
%pause
m = 0:q-1;
w = sin(pi.*m./q).^2;
y2 = zeros(1, length(x)+1);
i = 0;
while i > -1
    for j = 0:floor(q/2)-1
        try
            y2(q.*i./2 + j + 1) = x(floor((q.*(i-1)/2)+((p.*(q./2)+j)/q))).*w((q/2) + j) + x(floor(q.*i./2 + p*j./q)+1).*w(j+1);
        catch
            i = -2;
        end
    end
i = i + 1;
end
%soundsc(x,Fs);
pause
soundsc(y2, Fs);
