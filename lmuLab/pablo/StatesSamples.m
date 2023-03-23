function [sampleMatrix] = StatesSamples(states,t)

	for i=1:length(states(:,1))
		for j=1:length(t) - 1
			if t(j) < states(i, 1) && t(j+1) >= states(i, 1)
				sampleMatrix(i,1) = j+1;
			elseif t(j) <= states(i, 2) && t(j+1) > states(i, 2)
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
        if sampleMatrix(1, 1) == 0
            sampleMatrix(1, 1) = 1;
        end
	end
end