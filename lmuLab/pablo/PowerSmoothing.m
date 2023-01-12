function [pow_smooth] = PowerSmoothing(pow_mean,WindowType,WinLength,plotting)
% PowerSmoothing(ChannelInt,FreqBand,WindowType,x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,FreqRange
% Power smoothing of a frequency band.

% pow_mean = The mean of the power over  specified range of frequencies
% WindowType = 'Hamming','Hann','Gauss','Blackman'

% default arguments and that
%[x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers,nChannels,...
% nSamples,nFFTChunks,winstep,select,nFreqBins,f,t,FreqRange] = mtparam(varargin);

padding=5;

%movmedian: function for moving median window, give it a look, more robust
switch WindowType
    case 'Hamming'
        win = hamming(WinLength, 'periodic');
    case 'Hann'
        win = hann(WinLength, 'periodic');
    case 'Gauss'
        win = gausswin(WinLength);
    case 'Blackman'
        win = blackman(WinLength, 'periodic');
end

% ending = length(pow_mean);
% pow_pad =[flipud(pow_mean(1:padding)); pow_mean;  flipud(pow_mean(ending-padding:ending))];
pow_smooth = Filter0(win,pow_mean);
C = sum(win)/WinLength;
pow_smooth = pow_smooth/WinLength/C;

time=linspace(1,36,length(pow_smooth));

if plotting == true
    figure
    plot(time,pow_smooth)
    title('Power smoothed');
    xlabel('time (min)');
    ylabel('power (psd)');
end

end
