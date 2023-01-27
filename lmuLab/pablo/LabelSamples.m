function [labels] = LabelSamples(FileBase,sts,Fs,t)

	labels = repmat({'Unassigned'}, size(t));

	for st=1:length(sts)
		states = StatesSamples(FileBase, sts{st}, Fs, t);

		for j=1:length(states)
			for i=states(j,1):states(j,2)
				if ~strcmp(labels{i}, 'Unassigned')
					error(strcat("Errors: Intervals are not disjoint: sample ", num2str(i), " is in " , labels{i}, " and ", sts{st}));
				end
				labels{i}=sts{st};
			end
		end
	end
end