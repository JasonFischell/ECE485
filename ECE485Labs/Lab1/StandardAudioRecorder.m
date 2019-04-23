function [r] = StandardAudioRecorder(Record, Play)
% Standard Audio Recorder
if Record ~= 0
    r = audiorecorder(44100, 16, 1);
    disp('Recording: press return to stop');
    record(r); % speak into microphone...
    pause;
    pause(r); 
end

if Play ~= 0
   disp('Playing back recording r');
    p = play(r); % listen
    pause;
end



