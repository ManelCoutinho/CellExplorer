function [pow_mean] = PowerMean(y,f,ChannelInt,a,b)
% Power smoothing of a frequency band.
% y = input WhitenSignal
% ChannelInt = [1,nChannel]

%movmedian: function for moving median window, give it a look, more robust

if isempty(a)==0
    f_ind=find(f>a & f<b);
    for j=1:length(ChannelInt)
        pow_mean(j,:) = squeeze(mean(y(:,f_ind,ChannelInt(j)),2));
    end
else
    pow_mean = y;
end
