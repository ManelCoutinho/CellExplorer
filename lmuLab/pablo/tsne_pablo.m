function [X] = tsne_pablo(file, sr, channels, nChannels)

	% disp('Loading Data');
	% data = LoadBinary(file, 'frequency', sr, 'channels', channels, 'nChannels', nChannels);
	% disp(size(data));


	% disp('Whitening Data');
	% % TODO: use same  ARModel and pass it?
	% wdata = WhitenSignal(data, sr * 2000, 1);
	% clear data
	% disp(size(wdata));

	% disp('Calculating Spectrogram');

	% T=2; %sec
	% WinLength = 2^floor(log2(T*sr));
	% nFFT= 2*WinLength;
	% nOverlap = round(WinLength*0.8); 
	% NW = 2; 
	% FreqRange = [1 120]; 
	% [y, f, t] = mtcsglong(wdata, nFFT, sr, WinLength, nOverlap, NW, 'linear', [], FreqRange);
	% clear wdata
	% var=load("tsne/spect.mat");
	% y = var.y;
	% f = var.f;
	% t = var.t;
	% disp(size(y));
	% disp(size(f));
	% disp(size(t));

	% Spect = struct('t',t,'f',f,'y',y);
	% save("tsne/spect.mat", 't', 'f', 'y');



	%% Power Mean, smoothing, normalizing, concatenating
	% disp('Mean, Smoothing and Normalizing');
	% TODO: range, assumes various channels. do it per group?
	% PowerSignal = PowerMean(y,f,[1:length(y(1,1,:))],FreqRange(1),FreqRange(2));
	% clear y
	% clear f
	% clear t
	
	%Variables
	% WindowType = 'Gauss';
	% Plotting = false;
	% WinLength=21; %number of samples
	% Smoothed = PowerSmoothing(PowerSignal,WindowType,WinLength,Plotting);
	% Norm = rescale(Smoothed);
	% TODO: twice as much channels??
	% disp(size(Norm));
	% save("tsne/norm.mat",'Norm');
	
	
	var = load("tsne/norm.mat");
	Norm = var.Norm';

	disp('Calculating tsne');
	%% t-SNE calculation
	tic;

	% Creation of new dimension matrix. Only 2 dimensions
	% TODO: test 10
	X = lab_tsne(Norm, [], 2, 10);
	t = toc/60;
	fprintf('Time taken: %.2f minutes',t);
	disp(size(X))

	disp("Saving file");
	save("tsne/tsne_pablo.mat",'X');
	%% plotting t-SNE graph
	% figure
	% gscatter(X(:,1),X(:,2),new_labels)
	% xlabel('1st Dimension')
	% ylabel('2nd Dimension')
	% tit = "1-chunk t-SNE. NoWhitening";
	% title(tit)

end