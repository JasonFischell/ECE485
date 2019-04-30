
classdef PitchShifter < audioPlugin & matlab.System
    % PitchShifter Change the pitch of an audio signal.
    % PitchShifter generates an audio pitch shift plug-in that can be
    %   used in Digital Audio Workstations (DAW).
    %
    % This object is used in the "Delay Line Pitch Shifter" featured
    % example
    
    %   Copyright 2015-2017 The MathWorks, Inc.
    
    %#codegen
    
    properties (Constant)
        % Define plug-in interface
        PluginInterface = audioPluginInterface(...
            'PluginName','Pitch Shifter',...
            audioPluginParameter('PitchShift',...
            'DisplayName','Pitch Shift',...
            'Label','Semi-Tones',...
            'Mapping',{'int',-24,24}),...
            audioPluginParameter('Overlap',...
            'DisplayName','Overlap',...
            'Label','',...
            'Mapping',{'lin',0.01,0.5}));
    end
    
    % Public, tunable properties.
    properties
        
        % Amount of pitch shift (in semi-tones)
        % Valid ranges are from -12 to 12
        PitchShift = 0;
        
        % Delay line overlap
        Overlap = 0.01;
        
    end
    
    properties (DiscreteState)
        % Phase of the delay lines
        Phase1State;
        Phase2State;
    end
    
    properties (Nontunable, Access = protected)
        % The two delay lines ramp linearly from pMaxDelay (in seconds) to
        % 0. The constant rate of delay time change is what produces the
        % pitch shift.
        pMaxDelay = 0.03;
    end
    
    % Pre-computed constants.
    properties (Access = private)
        
        % The rate of the ramp determines the amount of pitch shift.
        % Positive values produce downward shifts (delay time is constantly
        % increasing) and negative values produce upward shifts (delay time
        % is constantly decreasing).
        
        % The user will set the pitch shift amount via the public property
        % and then we will update the rate accordingly
        pRate;
        
        % Max delay time in samples
        pSampsDelay;
        
        % The pitch shifter object
        pShifter;
        
        % How much the phase accumulator steps each sample. Dependent upon
        % rate setting and sample rate.
        pPhaseStep;
        
        % Constant used in calculations for cross-fading between the delay
        % lines
        pFaderGain;
    end
    
    methods
        % Constructor
        function obj = PitchShifter(varargin)
            setProperties(obj, nargin, varargin{:});
        end
    end
    
    methods (Access = protected)
        
        function setupImpl(obj,~)
            
            % Assume longest delay is 0.03ms and max Fs is 192 kHz
            pMaxDelaySamps = 192e3 * obj.pMaxDelay;
            
            obj.pShifter = dsp.VariableFractionalDelay('MaximumDelay',pMaxDelaySamps,...
                'InterpolationMethod','farrow');
            
            obj.Phase1State = 0;
            obj.Phase2State = (1 - obj.Overlap);
            
            tuneParameters(obj)
        end
        
        function tuneParameters(obj)
            % The amount of pitch shift is determined by the slope of this
            % ramp. The slope of the ramp determines the delay time delta
            % from one sample to the next. Pitch is the derivative (in
            % discrete time, the delta) of delay. Decreasing delay times
            % produce higher pitches and increasing delays produce lower
            % pitches. For example, if the delay time delta is a constant
            % -1 sample period (i.e. delayTime(n) = delayTime(n) - T) there
            % is a constant pitch shift of + 1 octave. When the rate is 0
            % there is no pitch shift.
                        
            obj.pRate = (1 - 2^((obj.PitchShift)/12)) / obj.pMaxDelay;
            obj.pPhaseStep = obj.pRate / getSampleRate(obj);
            obj.pFaderGain = 1 / obj.Overlap;
        end
        
        function processTunedPropertiesImpl(obj)
            tuneParameters(obj);
        end
        
        function [y,delays,gains] = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of
            % input u and discrete states.
            
            % Calculate delay times and gains
            blockSize = size(u,1);
            
            gains1 = zeros(blockSize,1);
            gains2 = zeros(blockSize,1);
            
            delays1 = zeros(blockSize,1);
            delays2 = zeros(blockSize,1);
            
            if(obj.pRate == 0)
                y = u;
                delays = [delays1,delays2];
                gains  = [gains1,gains2];
                return;
            end
            
            ph1   = obj.Phase1State;
            ph2   = obj.Phase2State;
            pstep = obj.pPhaseStep;
            ovrlp = obj.Overlap;
            sd    =  obj.pSampsDelay;
            fgain = obj.pFaderGain;
            
            for i = 1:blockSize
                
                ph1 = mod((ph1 + pstep),1);
                ph2 = mod((ph2 + pstep),1);
                
                % delayline2 is approaching its end. fade in delayline1
                if((ph1 < ovrlp) && (ph2 >= (1 - ovrlp)))
                    
                    delays1(i) = sd * ph1;
                    delays2(i) = sd * ph2;
                    
                    % Use equal power cross-fade rule
                    % gain1 = cos((1 - percent) * pi/2)
                    % gain2 = cos(percent * pi/2);
                    
                    gains1(i) = cos((1 - (ph1* fgain)) * pi/2);
                    gains2(i) = cos(((ph2 - (1 - ovrlp)) * fgain) * pi/2);
                    
                    % delayline1 is active
                elseif((ph1 > ovrlp) && (ph1 < (1 - ovrlp)))
                    
                    % delayline2 shouldn't move while delayline1 is active
                    ph2 = 0;
                    
                    delays1(i) = sd * ph1;
                    
                    gains1(i) = 1;
                    gains2(i) = 0;
                    
                    % delayline1 is approaching its end. fade in delayline2
                elseif((ph1 >= (1 - ovrlp)) && (ph2 < ovrlp))
                    
                    delays1(i) = sd * ph1;
                    delays2(i) = sd * ph2;
                    
                    % Use equal power cross-fade rule
                    % gain1 =  cos(percent * pi/2);
                    % gain2 =  cos((1 - percent) * pi/2);
                    gains1(i) = cos(((ph1 - (1 - ovrlp)) * fgain) * pi/2);
                    gains2(i) = cos((1 - (ph2* fgain)) * pi/2);
                    
                    % delayline2 is active
                elseif((ph2 > ovrlp) && (ph2 < (1 - ovrlp)))
                    
                    % delayline1 shouldn't move while delayline2 is active
                    ph1 = 0;
                    
                    delays2(i) = sd * ph2;
                    
                    gains1(i) = 0;
                    gains2(i) = 1;
                    
                end
            end
            
            obj.Phase1State = ph1;
            obj.Phase2State = ph2;
            
            % Get delayed output
            dly = zeros(blockSize,1,2);
            dly(:,:,1) = delays1;
            dly(:,:,2) = delays2;
            delayedOut = obj.pShifter(u,dly);
   
            % Multiply by fader gains. There's one set of gains that can be
            % applied to all channels so loop through the columns
            for i = 1:size(u,2)
                delayedOut(:,i,1) = delayedOut(:,i,1) .* gains1;
                delayedOut(:,i,2) = delayedOut(:,i,2) .* gains2;
            end
            
            % Sum to create output
            y = sum(delayedOut,3);
            delays = [delays1,delays2] / getSampleRate(obj);
            gains  = [gains1,gains2];
            
        end
        
        function resetImpl(obj)
            obj.Phase1State = 0;
            obj.Phase2State = (1 - obj.Overlap);
            reset(obj.pShifter);
            
            % Pre-load max-delay * Fs (i.e. delay in samples) because this
            % is used throughout the step method.
            obj.pSampsDelay = round(obj.pMaxDelay * getSampleRate(obj));

            tuneParameters(obj);
        end
    end
end