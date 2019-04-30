function [pitch, is_sound, diff] = autotune_fcn(x)
energy = sum(abs(x.*x));
is_sound = energy > .1;
temp_pitch = estimate_pitch(x);

if is_sound
    pitch = temp_pitch;
    diff = shift_factor(pitch);
else 
    pitch = 0;
    diff = 0;
end

end