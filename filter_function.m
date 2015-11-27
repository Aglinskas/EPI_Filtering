function Y=filter_function(y)
%y=cosmo_data.samples

y=y'; %.all.samples
Fs = .5;                    % sample rate in Hz
N = size(y,2);                     % number of signal samples
rng default;
t = (0:N-1)/Fs;              % time vector
Fnorm = 1/50;%75/(Fs/2);           % Normalized frequency


df = designfilt('highpassfir','FilterOrder',80,'CutoffFrequency',Fnorm);
% df = designfilt('highpassfir', 'StopbandFrequency', 0.02, ...
%                 'PassbandFrequency', 0.0208, 'StopbandAttenuation', 60, ...
%                 'PassbandRipple', 1, 'SampleRate', 0.5);
D = mean(grpdelay(df)); % filter delay in samples
padding=128;
Y = filter(df,[[y(:,1:padding) y y(:,1:padding)]'; zeros(D,size(y,1))])'; % Append D zeros to the input data
Y = Y(:,D+1:end);                  % Shift data to compensate for delay
Y=Y(:,padding+1:end-padding)';

y=y'; %just for plotting purpose
plot(y(:,4500))
hold on
plot(Y(:,4500))

end

