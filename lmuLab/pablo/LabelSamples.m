function [labels] = LabelSamples(states_file,t)

	labels = repmat({'Unassigned'}, size(t));
	statenames = fieldnames(states_file);

	for st=1:length(statenames)
		states = StatesSamples(states_file.(statenames{st}),t);

		for j=1:length(states)
			for i=states(j,1):states(j,2)
				if ~strcmp(labels{i}, 'Unassigned')
					error(strcat("Errors: Intervals are not disjoint: sample ", num2str(i), " is in " , labels{i}, " and ", statenames{st}));
				end
				labels{i}=statenames{st};
			end
		end
	end
end