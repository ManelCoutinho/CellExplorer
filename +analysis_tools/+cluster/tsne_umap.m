function out = tsne_umap(varargin)
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

% Initialize States - with selected states data
if exist(fullfile(UI.data.basepath,[UI.data.basename,'.',UI.settings.statesData,'.states.mat']),'file')
    if ~isfield(data,'states') || ~isfield(data.states,UI.settings.statesData)
        data.states.(UI.settings.statesData) = loadStruct(UI.settings.statesData,'states','session',data.session);
    end
    if isfield(data.states.(UI.settings.statesData),'ints')
        states  = data.states.(UI.settings.statesData).ints;
    else
        states  = data.states.(UI.settings.statesData);
    end
end

% Default preferences
% tSNE representation
preferences = {};
preferences.algorithm = 'tSNE';
preferences.dDistanceMetric = 'chebychev';
preferences.exaggeration = 10;
preferences.standardize = false;
preferences.NumPCAComponents = 0;
preferences.LearnRate = 1000;
preferences.Perplexity = 30;
preferences.InitialY = 'Random';

% UMAP
preferences.n_neighbors = 30;
preferences.min_dist = 0.3;

ce_waitbar = [];

% Dropdown fields
algorithms = {'tSNE','UMAP','PCA'};
InitialYMetrics = {'Random','PCA space'};
distanceMetrics = {'euclidean', 'seuclidean', 'cityblock', 'chebychev', 'minkowski', 'mahalanobis', 'cosine', 'correlation', 'spearman', 'hamming', 'jaccard'};
spectrogram = {};
spectrogram.window_time = 2;
spectrogram.window_sample = 2^floor(log2(spectrogram.window_time * ephys.sr));
spectrogram.freq_low = 1;
spectrogram.freq_high = 100;
spectrogram.overlap_perc = 80;
spectrogram.overlap = round(spectrogram.window_sample * spectrogram.overlap_perc / 100);
spectrogram.nw = 2;
channels = [UI.channels{:}];

% [list_tSNE_metrics,ia] = generateMetricsList(cell_metrics,'all',preferences.metrics);

% [indx,tf] = listdlg('PromptString',['Select the metrics to use for the tSNE plot'],'ListString',list_tSNE_metrics,'SelectionMode','multiple','ListSize',[350,400],'InitialValue',1:length(ia));

load_tSNE.dialog = dialog('Position', [300, 300, 500, 518],'Name','Select metrics for dimensionality reduction','WindowStyle','modal','visible','off'); movegui(load_tSNE.dialog,'center'), set(load_tSNE.dialog,'visible','on')
load_tSNE.channelList = uicontrol('Parent',load_tSNE.dialog,'Style','listbox','String', channels,'Position',[10, 135, 190, 372],'Value',1:5,'Max',length(channels),'Min',1);

% Spectrogram Menu
uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 481, 270, 20],'Units','normalized','String','________________________________','HorizontalAlignment','left');
uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 487, 270, 20],'Units','normalized','String','Spectrogram Settings','HorizontalAlignment','left');

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 456, 180, 20],'Units','normalized','String','Window width (sec)','HorizontalAlignment','left');
load_tSNE.spectrogram.window_time = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[420, 456, 60, 20],'Units','normalized','String', num2str(spectrogram.window_time),'HorizontalAlignment','center','Callback',@updateWindow);

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 434, 180, 20],'Units','normalized','String','Window width (#samples)','HorizontalAlignment','left');
load_tSNE.spectrogram.window_sample = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[420, 434, 60, 20],'Units','normalized','String', num2str(spectrogram.window_sample),'HorizontalAlignment','center','Enable','off');

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 412, 180, 20],'Units','normalized','String','Low frequency (Hz)','HorizontalAlignment','left');
load_tSNE.spectrogram.freq_low = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[420, 412, 60, 20],'Units','normalized','String', num2str(spectrogram.freq_low),'HorizontalAlignment','center','Callback',@updateVariable);

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 390, 180, 20],'Units','normalized','String','High frequency (Hz)','HorizontalAlignment','left');
load_tSNE.spectrogram.freq_high = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[420, 390, 60, 20],'Units','normalized','String', num2str(spectrogram.freq_high),'HorizontalAlignment','center','Callback',@updateVariable);

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 368, 180, 20],'Units','normalized','String','Overlap (%)','HorizontalAlignment','left');
load_tSNE.spectrogram.overlap_perc = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[420, 368, 60, 20],'Units','normalized','String', num2str(spectrogram.overlap_perc),'HorizontalAlignment','center','Callback',@updateOverlap);

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 346, 180, 20],'Units','normalized','String','Overlap (#samples)','HorizontalAlignment','left');
load_tSNE.spectrogram.overlap = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[420, 346, 60, 20],'Units','normalized','String',num2str(spectrogram.overlap),'HorizontalAlignment','center','Enable','off');

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[210, 324, 180, 20],'Units','normalized','String','Time Bandwidth','HorizontalAlignment','left');
load_tSNE.spectrogram.nw = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[420, 324, 60, 20],'Units','normalized','String', num2str(spectrogram.nw),'HorizontalAlignment','center','Callback',@updateVariable);

load_tSNE.spectrogram.whitening = uicontrol('Parent',load_tSNE.dialog,'Style','checkbox','Position',[210, 302, 260, 20],'Units','normalized','String','Whiten Channels before Spectrogram','Value', 1,'HorizontalAlignment','right');

uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[10, 113, 100, 20],'Units','normalized','String','Algorithm','HorizontalAlignment','left');
load_tSNE.popupmenu.algorithm = uicontrol('Parent',load_tSNE.dialog,'Style','popupmenu','Position',[10, 95, 100, 20],'Units','normalized','String',algorithms,'HorizontalAlignment','left','Callback',@(src,evnt)setAlgorithm);
if isfield(preferences,'algorithm') && find(strcmp(preferences.algorithm,algorithms))
    load_tSNE.popupmenu.algorithm.Value = find(strcmp(preferences.algorithm,algorithms));
else
    load_tSNE.popupmenu.algorithm.Value = 1;
end
        
uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[120, 113, 110, 20],'Units','normalized','String','Distance metric','HorizontalAlignment','left');
load_tSNE.popupmenu.distanceMetric = uicontrol('Parent',load_tSNE.dialog,'Style','popupmenu','Position',[120, 95, 120, 20],'Units','normalized','String',distanceMetrics,'HorizontalAlignment','left');

%     tSNE_preferences.InitialY = 'Random';
load_tSNE.label.NumPCAComponents = uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[10, 73, 100, 20],'Units','normalized','String','nPCAComponents','HorizontalAlignment','left');
load_tSNE.popupmenu.NumPCAComponents = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[10, 55, 100, 20],'Units','normalized','String',preferences.NumPCAComponents,'HorizontalAlignment','left');

load_tSNE.label.LearnRate = uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[120, 73, 90, 20],'Units','normalized','String','LearnRate','HorizontalAlignment','left');
load_tSNE.popupmenu.LearnRate = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[120, 55, 90, 20],'Units','normalized','String',preferences.LearnRate,'HorizontalAlignment','left');

load_tSNE.label.Perplexity = uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[220, 73, 70, 20],'Units','normalized','String','Perplexity','HorizontalAlignment','left');
load_tSNE.popupmenu.Perplexity = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[220, 55, 70, 20],'Units','normalized','String',preferences.Perplexity,'HorizontalAlignment','left');


load_tSNE.label.InitialY = uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[380, 73, 110, 20],'Units','normalized','String','InitialY','HorizontalAlignment','left');
load_tSNE.popupmenu.InitialY = uicontrol('Parent',load_tSNE.dialog,'Style','popupmenu','Position',[380, 55, 110, 20],'Units','normalized','String',InitialYMetrics,'HorizontalAlignment','left','Value',1);
if find(strcmp(preferences.InitialY,InitialYMetrics)); load_tSNE.popupmenu.InitialY.Value = find(strcmp(preferences.InitialY,InitialYMetrics)); end

load_tSNE.label.exaggeration = uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[300, 73, 70, 20],'Units','normalized','String','Exaggeration','HorizontalAlignment','left');
load_tSNE.popupmenu.exaggeration = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[300, 55, 70, 20],'Units','normalized','String',num2str(preferences.exaggeration),'HorizontalAlignment','left');

% UMAP Fields
load_tSNE.label.n_neighbors = uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[10, 73, 100, 20],'Units','normalized','String','n_neighbors','HorizontalAlignment','left');
load_tSNE.popupmenu.n_neighbors = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[10, 55, 100, 20],'Units','normalized','String',preferences.n_neighbors,'HorizontalAlignment','left');

load_tSNE.label.min_dist = uicontrol('Parent',load_tSNE.dialog,'Style','text','Position',[120, 73, 90, 20],'Units','normalized','String','min_dist','HorizontalAlignment','left');
load_tSNE.popupmenu.min_dist = uicontrol('Parent',load_tSNE.dialog,'Style','Edit','Position',[120, 55, 90, 20],'Units','normalized','String',preferences.min_dist,'HorizontalAlignment','left');

uicontrol('Parent',load_tSNE.dialog,'Style','pushbutton','Position',[300, 10, 90, 30],'String','OK','Callback',@(src,evnt)close_tSNE_dialog);
uicontrol('Parent',load_tSNE.dialog,'Style','pushbutton','Position',[400, 10, 90, 30],'String','Cancel','Callback',@(src,evnt)cancel_tSNE_dialog);
setAlgorithm
uiwait(load_tSNE.dialog)

    function setAlgorithm
        if load_tSNE.popupmenu.algorithm.Value == 1
            distanceMetrics = {'euclidean', 'seuclidean', 'cityblock', 'chebychev', 'minkowski', 'mahalanobis', 'cosine', 'correlation', 'spearman', 'hamming', 'jaccard'};
            load_tSNE.popupmenu.distanceMetric.String = distanceMetrics;
            if find(strcmp(preferences.dDistanceMetric,distanceMetrics))
                load_tSNE.popupmenu.distanceMetric.Value = find(strcmp(preferences.dDistanceMetric,distanceMetrics)); 
            else
                load_tSNE.popupmenu.distanceMetric.Value = 1;
            end
            load_tSNE.popupmenu.distanceMetric.Enable = 'on';
            % t-SNE Fields
            load_tSNE.popupmenu.NumPCAComponents.Visible = 'on';
            load_tSNE.popupmenu.LearnRate.Visible = 'on';
            load_tSNE.popupmenu.Perplexity.Visible = 'on';
            load_tSNE.popupmenu.exaggeration.Visible = 'on';
            load_tSNE.popupmenu.InitialY.Visible = 'on';
            % t-SNE Labels
            load_tSNE.label.NumPCAComponents.Visible = 'on';
            load_tSNE.label.LearnRate.Visible = 'on';
            load_tSNE.label.Perplexity.Visible = 'on';
            load_tSNE.label.exaggeration.Visible = 'on';
            load_tSNE.label.InitialY.Visible = 'on';
            
            % UMAP
            load_tSNE.popupmenu.n_neighbors.Visible = 'off';
            load_tSNE.popupmenu.min_dist.Visible = 'off';
            load_tSNE.label.n_neighbors.Visible = 'off';
            load_tSNE.label.min_dist.Visible = 'off';
            
        elseif load_tSNE.popupmenu.algorithm.Value == 2
            distanceMetrics = {'euclidean', 'cosine', 'cityblock', 'seuclidean', 'squaredeuclidean', 'correlation', 'jaccard', 'spearman', 'hamming'};
            load_tSNE.popupmenu.distanceMetric.String = distanceMetrics;
            if find(strcmp(preferences.dDistanceMetric,distanceMetrics))
                load_tSNE.popupmenu.distanceMetric.Value = find(strcmp(preferences.dDistanceMetric,distanceMetrics)); 
            else
                load_tSNE.popupmenu.distanceMetric.Value = 1;
            end
            load_tSNE.popupmenu.distanceMetric.Enable = 'on';
            % t-SNE Fields
            load_tSNE.popupmenu.NumPCAComponents.Visible = 'off';
            load_tSNE.popupmenu.LearnRate.Visible = 'off';
            load_tSNE.popupmenu.Perplexity.Visible = 'off';
            load_tSNE.popupmenu.exaggeration.Visible = 'off';
            load_tSNE.popupmenu.InitialY.Visible = 'off';
            % t-SNE Labels
            load_tSNE.label.NumPCAComponents.Visible = 'off';
            load_tSNE.label.LearnRate.Visible = 'off';
            load_tSNE.label.Perplexity.Visible = 'off';
            load_tSNE.label.exaggeration.Visible = 'off';
            load_tSNE.label.InitialY.Visible = 'off';
            
            % UMAP
            load_tSNE.popupmenu.n_neighbors.Visible = 'on';
            load_tSNE.popupmenu.min_dist.Visible = 'on';
            load_tSNE.label.n_neighbors.Visible = 'on';
            load_tSNE.label.min_dist.Visible = 'on';
        else
            load_tSNE.popupmenu.distanceMetric.Enable = 'off';
            % t-SNE Fields
            load_tSNE.popupmenu.NumPCAComponents.Visible = 'off';
            load_tSNE.popupmenu.LearnRate.Visible = 'off';
            load_tSNE.popupmenu.Perplexity.Visible = 'off';
            load_tSNE.popupmenu.exaggeration.Visible = 'off';
            load_tSNE.popupmenu.InitialY.Visible = 'off';
            % t-SNE Labels
            load_tSNE.label.NumPCAComponents.Visible = 'off';
            load_tSNE.label.LearnRate.Visible = 'off';
            load_tSNE.label.Perplexity.Visible = 'off';
            load_tSNE.label.exaggeration.Visible = 'off';
            load_tSNE.label.InitialY.Visible = 'off';
            
            % UMAP
            load_tSNE.popupmenu.n_neighbors.Visible = 'off';
            load_tSNE.popupmenu.min_dist.Visible = 'off';
            load_tSNE.label.n_neighbors.Visible = 'off';
            load_tSNE.label.min_dist.Visible = 'off';
        end
    end

    function close_tSNE_dialog
        s1 = dir(UI.data.fileName);
        s2 = dir(UI.data.fileNameLFP);
        if ~isempty(s1) && ~strcmp(UI.priority,'lfp')
            file = UI.data.fileName;
        elseif ~isempty(s2)
            file = UI.data.fileNameLFP;
        end
        
        spectrogram.channels = load_tSNE.channelList.Value;
        spectrogram.nFFT = 2 * spectrogram.window_sample;
        
        % TODO: error verification (?)
        preferences.dDistanceMetric = load_tSNE.popupmenu.distanceMetric.String{load_tSNE.popupmenu.distanceMetric.Value};
        preferences.exaggeration = str2double(load_tSNE.popupmenu.exaggeration.String);
        preferences.algorithm = load_tSNE.popupmenu.algorithm.String{load_tSNE.popupmenu.algorithm.Value};
        
        preferences.NumPCAComponents = str2double(load_tSNE.popupmenu.NumPCAComponents.String);
        preferences.LearnRate = str2double(load_tSNE.popupmenu.LearnRate.String);
        preferences.Perplexity = str2double(load_tSNE.popupmenu.Perplexity.String);
        preferences.InitialY = load_tSNE.popupmenu.InitialY.String{load_tSNE.popupmenu.InitialY.Value};
        
        preferences.n_neighbors = str2double(load_tSNE.popupmenu.n_neighbors.String);
        preferences.min_dist = str2double(load_tSNE.popupmenu.min_dist.String);
        
        whitening = load_tSNE.spectrogram.whitening.Value;
        delete(load_tSNE.dialog);

        spect_name = Manager.get_spectrogram_name(UI.data.basename, spectrogram.nFFT, spectrogram.window_sample, spectrogram.overlap_perc, spectrogram.freq_low, spectrogram.freq_high, spectrogram.nw, whitening);
        switch preferences.algorithm
            case 'tSNE'
                algo_name = Manager.get_tsne_name(spect_name, spectrogram.channels, preferences.dDistanceMetric, preferences.LearnRate, preferences.Perplexity, preferences.exaggeration, preferences.NumPCAComponents, strcmp(preferences.InitialY,'PCA space'));                
            case 'UMAP'
                algo_name = Manager.get_umap_name(spect_name, spectrogram.channels, preferences.dDistanceMetric, preferences.n_neighbors, preferences.min_dist);
            case 'PCA'
                algo_name = Manager.get_pca_name(spect_name, spectrogram.channels);
        end

        ce_waitbar = waitbar(0,'Preparing metrics for tSNE space...');

        algo_res = Manager.load(preferences.algorithm, algo_name);
        if ~isempty(algo_res)
            out.Y = algo_res;
            out.spectrogram = spectrogram;

            % Calculating t to add out.labels
            winstep = spectrogram.window_sample - spectrogram.overlap;
            t = winstep*(0:(size(out.Y,1)-1))'/ephys.sr;
            waitbar(0.5,ce_waitbar,'Labeling samples...');
            if exist('states', 'var') && ~isempty(states)
                out.labels = LabelSamples(states, t);
            else
                out.labels = LabelSamples(struct(), t);
            end 
            if ishandle(ce_waitbar)
                close(ce_waitbar)
            end
            return
        end


        % TODO optimize loading (are freq just subsetting?)
        data = Manager.load('spect', spect_name, spectrogram.channels);
        if ~isempty(data)
            new_channels_idx = find(all(data.y==0, [1, 2]));
            new_channels = spectrogram.channels(new_channels_idx);
        else
            new_channels = spectrogram.channels;
        end
        if ~isempty(new_channels)
            waitbar(0,ce_waitbar,'Loading Channels...');
            new_data = LoadBinary(file, 'frequency', ephys.sr, 'channels', new_channels, 'nChannels', length(channels));
    
            if whitening == 1
                waitbar(0.1,ce_waitbar,'Whitening Channels...');
                % TODO: selectable Whitening Parameters, maybe save ARModel to be consistent per file?
                new_data = WhitenSignal(new_data, ephys.sr * 2000, 1);
            end

            waitbar(0.2,ce_waitbar,'Calculating Spectrogram...');

            [y, f, t] = mtcsglong(new_data, spectrogram.nFFT, ephys.sr, spectrogram.window_sample, spectrogram.overlap, spectrogram.nw, 'linear', [], [spectrogram.freq_low spectrogram.freq_high]);           
            Manager.save(struct('t',t, 'f',f, 'y',y), 'spect', spect_name, length(channels), new_channels);
            
            if ~isempty(new_channels_idx)
                data.y(:, :, new_channels_idx) = y;
                y = data.y;
            end
        else
            y = data.y;
            f = data.f;
            t = data.t;
        end
        clear new_data
        clear data
                
        waitbar(0.3,ce_waitbar,'Labeling samples...');
        if exist('states', 'var') && ~isempty(states)
            out.labels = LabelSamples(states, t);
        else
            out.labels = LabelSamples(struct(), t);
        end
        %%%%%%%%%%%%%%
        % Processing %
        %%%%%%%%%%%%%%

        waitbar(0.4,ce_waitbar,'Mean, Smoothing and Normalizing...');
        % TODO: add this as options?
        X = PowerMean(y,f, 1:length(y(1,1,:)),spectrogram.freq_low, spectrogram.freq_high);
        clear y
        clear f
        clear t

        WindowType = 'Gauss';
        Plotting = false;
        WinLength=21; %number of samples
        % why does the number of channels increase? - due to Filter0
        X = PowerSmoothing(X,WindowType,WinLength,Plotting);
        X = rescale(X)';

        % TODO: for now
	    % X = X(1:1000,:);
        % out.labels = out.labels(1:1000);
        % opts = statset('OutputFcn',@updateBar, 'MaxIter', 505);
        opts = statset('OutputFcn',@updateBar);
        
        switch preferences.algorithm
            case 'tSNE'
                if strcmp(preferences.InitialY,'PCA space')
                    
                    pca_name = Manager.get_pca_name(spect_name, spectrogram.channels);
                    initPCA = Manager.load('PCA', pca_name);
                    if isempty(initPCA)
                        waitbar(0.45,ce_waitbar,'Calculating PCA init space...')
                        initPCA = pca(X,'NumComponents',2);
                        Manager.save(initPCA, 'PCA', pca_name);
                    end
                    
                    waitbar(0.5,ce_waitbar,'Calculating tSNE space...')
                    out.Y = tsne(X,'Standardize',preferences.standardize,'Distance',preferences.dDistanceMetric,'Exaggeration',preferences.exaggeration,'NumPCAComponents',preferences.NumPCAComponents,'Perplexity',preferences.Perplexity,'InitialY',initPCA,'LearnRate',preferences.LearnRate,'NumPrint',100,'Options',opts);
                else
                    waitbar(0.5,ce_waitbar,'Calculating tSNE space...')
                    out.Y = tsne(X,'Standardize',preferences.standardize,'Distance',preferences.dDistanceMetric,'Exaggeration',preferences.exaggeration,'NumPCAComponents',min(size(X,1),preferences.NumPCAComponents),'Perplexity',min(size(X,2),preferences.Perplexity),'LearnRate',preferences.LearnRate,'NumPrint',100,'Options',opts);                    
                end
                
            case 'UMAP'
                waitbar(0.5,ce_waitbar,'Calculating UMAP space...')
                % TODO: progress_callback
                out.Y = run_umap(X,'verbose','none','metric',preferences.dDistanceMetric,'n_neighbors',preferences.n_neighbors,'min_dist',preferences.min_dist); %
            case 'PCA'
                waitbar(0.5,ce_waitbar,'Calculating PCA space...')
                out.Y = pca(X,'NumComponents',2); % ,'metric',tSNE_preferences.dDistanceMetric
        end
        Manager.save(out.Y, preferences.algorithm, algo_name);
        
        out.spectrogram = spectrogram;

        if ishandle(ce_waitbar)
            close(ce_waitbar)
        end
    end

    function cancel_tSNE_dialog
        % Closes the dialog
        delete(load_tSNE.dialog);
        return
    end

    function updateVariable(src,~)
        numeric_gt_0 = @(n) ~isempty(n) && isnumeric(n) && (n > 0); % numeric and greater than 0
        numeric_gte_0 = @(n) ~isempty(n) && isnumeric(n) && (n >= 0); % Numeric and greater than or equal to 0

        freq_low = str2double(load_tSNE.spectrogram.freq_low.String);
        freq_high = str2double(load_tSNE.spectrogram.freq_high.String);

        if numeric_gte_0(freq_low) && numeric_gt_0(freq_high) && freq_high > freq_low
            spectrogram.freq_low = freq_low;
            spectrogram.freq_high = freq_high;
        else
            load_tSNE.spectrogram.freq_low.String = num2str(spectrogram.freq_low);
            load_tSNE.spectrogram.freq_high.String = num2str(spectrogram.freq_high);
            warndlg('The spectrogram frequency range is not valid','NeuroScope2');
        end

        nw = str2double(load_tSNE.spectrogram.nw.String);
        if numeric_gt_0(nw)
            spectrogram.nw = nw;
        else
            load_tSNE.spectrogram.nw.String = num2str(spectrogram.nw);
            warndlg('The spectrogram time bandwidth is not valid','NeuroScope2');
        end
    end

    function updateWindow(~,~)
        window_time = str2double(load_tSNE.spectrogram.window_time.String);
        if ~isempty(window_time) && isnumeric(window_time) && (window_time > 0) 
            spectrogram.window_time = window_time;
            spectrogram.window_sample = 2^floor(log2(spectrogram.window_time * ephys.sr));
            load_tSNE.spectrogram.window_sample.String = num2str(spectrogram.window_sample);
            updateOverlap;
        else
            load_tSNE.spectrogram.window_time.String = num2str(spectrogram.window_time);
            warndlg('The spectrogram window width is not valid','NeuroScope2');
        end
    end

    function updateOverlap(~,~)
        overlap_perc = str2double(load_tSNE.spectrogram.overlap_perc.String);
        if ~isempty(overlap_perc) && isnumeric(overlap_perc) && (overlap_perc >= 0) && (overlap_perc <= 100)
            spectrogram.overlap_perc = overlap_perc;
            spectrogram.overlap = round(spectrogram.window_sample * spectrogram.overlap_perc / 100);
            load_tSNE.spectrogram.overlap.String = num2str(spectrogram.overlap);
        else
            load_tSNE.spectrogram.overlap_perc.String = num2str(spectrogram.overlap_perc);
            warndlg('The overlap percentage is not valid','NeuroScope2');
        end
    end

    function stop = updateBar(optimValues,state)
        persistent stopnow
        switch state
            case 'init'
                stopnow = false;
                set(UI.fig_cluster,'visible','on'); 
                %uicontrol('Style','pushbutton','String','Stop','Position', [10 10 50 20],'Callback',@stopme);
            case 'iter'
                waitbar(0.5 + optimValues.iteration / (1000 / 0.5),ce_waitbar,'Calculating tSNE space...');
                cla(UI.plot_cluster_axis);

                UI.cluster.plot = gscatter(UI.plot_cluster_axis, optimValues.Y(:, 1), optimValues.Y(:, 2), out.labels);

                limit_x = [min(optimValues.Y(:,1)), max(optimValues.Y(:,1))];
                offset_x = (limit_x(2) - limit_x(1)) * 0.015;
                limit_y = [min(optimValues.Y(:,2)), max(optimValues.Y(:,2))];
                offset_y = (limit_y(2) - limit_y(1)) * 0.015;
                set(UI.plot_cluster_axis, 'XLim', [limit_x(1) - offset_x, limit_x(2) + offset_x], 'YLim', [limit_y(1) - offset_y, limit_y(2) + offset_y]);                
            case 'done'
                % Nothing here
        end
        stop = stopnow;
        
        %function stopme(~,~)
        %    stopnow = true;
        %end
    end
end