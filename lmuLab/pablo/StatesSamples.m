function [sampleMatrix] = StatesSamples(FileBase,state,Fs,t)
	FileName = FileBase + ".sts." + state;
	% TODO: improve with pre-allocate size
		
	if isfile(FileName)
		var = load(FileName);
		var = var./Fs;
		for i=1:length(var(:,1))
			for j=1:length(t) - 1
				if t(j) < var(i, 1) && t(j+1) >= var(i, 1)
					sampleMatrix(i,1) = j+1;
				elseif t(j) <= var(i, 2) && t(j+1) > var(i, 2)
					sampleMatrix(i,2) = j;
				end
			end
		end
		
		%to avoid hanging labels
		[m,n] = size(sampleMatrix);
		if n==1
			sampleMatrix = [sampleMatrix j];
		else
			if sampleMatrix(m,2) == 0
				sampleMatrix(m,2) = j; %end of data
			end
		end
	else
		sampleMatrix=[0,0];
	end
end