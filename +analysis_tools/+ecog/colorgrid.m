function out = colorgrid(varargin)
	% This function is called from NeuroScope2 via the menu Analysis 
	
	p = inputParser;
	
	% The inputs are NeuroScope2 variables:
	addParameter(p,'ephys',[],@isstruct); % ephys: Struct with ephys data for current shown time interval, e.g. ephys.raw (raw unprocessed data), ephys.traces (processed data)
	addParameter(p,'UI',[],@isstruct); % UI: struct with UI elements and settings of NeuroScope2
	addParameter(p,'data',[],@isstruct); % data: contains all external data loaded like data.session, data.spikes, data.events, data.states, data.behavior
	parse(p,varargin{:})
	
	ephys = p.Results.ephys;
	UI = p.Results.UI;
	data = p.Results.data;
	
	out = {};
	
	% % % % % % % % % % % % % % % %
	% Function content below
	% % % % % % % % % % % % % % % % 

	% TODO: generalize
	grid.dialog = dialog('Position', [300, 300, 500, 518],'Name','ECoG Color Map - TODO: name later','WindowStyle','normal','visible','off'); movegui(grid.dialog,'center'), set(grid.dialog,'visible','on')

	% TODO: missing channels - always 16 - 16?
	% TODO: make with provided mapping
	map = reshape(ephys.traces(1,:), [16, 16]);
	% TODO: maybe remove in the future
	map = imgaussfilt(map, 1);
    imagesc(map);
	colormap default
	clim([-1 1]*prctile(abs(ephys.traces(1,:)),99));
    
	
end