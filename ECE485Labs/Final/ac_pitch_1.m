function [to_ret] = ac_pitch_1(x, L, M, Fs, Fmin, Fmax)

% Note: Cut out last points (bad data)
k_max = ceil((length(x - 2*L))./M)-5;
n_0_func = @(k) M.*(k-1) + 1;
w_L = 4*L;
w_func = @(n) (sin(pi.*n./(w_L-1)).^2).*(n>=0).*(n<w_L);
x_mod = [ zeros(1, length(x)), x, zeros(1, length(x))];
x_func = @(n) x_mod(n+length(x));
n = 1:length(x);

% F = Fs/N
% Nmin = Fs / Fmin

l_max = Fs/Fmin;
l_min = Fs/Fmax;

to_ret = zeros(2, k_max);

for k = 1:k_max
    n_0 = n_0_func(k);
    y = w_func(1:w_L).*x_func(floor(n_0):floor(n_0+w_L-1));
    [corr, lag] = xcorr(y, 'coeff');
    indices = find(lag == 0);
    index_z = indices(1,1);

    max_amp = -1;
    max_freq = -1;
    for l = ceil(l_min):ceil(l_max)
        index = l+index_z;
        if(corr(index)>max_amp)
            % Halving
            if(corr(ceil(l/2) + index_z)>.7*corr(l + index_z) &&  ceil(l/2) > l_min)
                max_amp = corr(ceil(l/2)+index_z);
                max_freq = 2*Fs/ceil(l/2);
            else
                max_amp = corr(l+index_z);
                max_freq = 2*Fs/l;
            end
        end
    end
    to_ret(1:2, k) = [n_0 max_freq];
end
%xto_ret(2, :) = medfilt1(to_ret(2, :), 9);

