classdef Manager
	properties (Constant)
		DefaultSaveLocation = 'data' % Default location to save results
	end

	methods (Static)
		% TODO: improve the loading of spectrograms
		% if there are some already calculated but not others
		% Remove channels from spect list and add them only on the cluster algo
		function save(data, type, name, nChannels, new_channels)
			type_list = ['spect', 'tsne', 'umap', 'pca'];
			if ~ismember(type, type_list)
				error(['Exception: ' type ' not in list. Possible types are: ' strjoin(type_list, ', ')])
			end

			dir = fullfile(Manager.DefaultSaveLocation, type);

			if ~exist(dir, 'dir')
				mkdir(dir);
			end
			filename = fullfile(dir, name);

			if strcmp(type, 'spect')
				if exist(filename, 'file')
                    complete = load(filename, 'data');
                    complete = complete.data;
					complete.y(:, :, new_channels) = data.y;
					data.y = complete.y;
                else
					y_complete = zeros([size(data.y, 1:2), nChannels]);
					y_complete(:, :, new_channels) = data.y;
					data.y = y_complete;
				end
			end
			save(filename, 'data', '-v7.3');
		end
		%regexprep(num2str(channels),'\s+',','),
		function name = get_spectrogram_name(filename, nFFT, window_samples, overlap_perc, low_freq, high_freq, timeband, whiten)
			name = sprintf('Spect-%s_nfft-%d_ws-%d_ovl-%s_frq-%d-%d_tb-%d_wht-%d.mat', filename, nFFT, window_samples,num2str(overlap_perc), low_freq, high_freq,timeband, whiten);
		end

		function name = get_tsne_name(spect_name, distanceMetric, lr, perplexity, exaggeration, npca, init)
			hashed_name = FletcherHash(spect_name);
			name = sprintf('Tsne-%s_dist-%s_lr-%d_perp-%d_exag-%d_npca-%d_initPCA-%d.mat', hashed_name, distanceMetric, lr, perplexity, exaggeration, npca, init);
		end

		function name = get_umap_name(spect_name, distanceMetric, n_neighbors, min_dist)
			hashed_name = FletcherHash(spect_name);
			name = sprintf('Umap-%s_dist-%s_nn-%d_min-%s.mat', hashed_name, distanceMetric, n_neighbors, num2str(min_dist));
		end

		function name = get_pca_name(spect_name)
			hashed_name = FletcherHash(spect_name);
			name = sptrinf('PCA-%s.mat', hashed_name);
		end

		function data = load(type, name, channels)
			type_list = ['spect', 'tsne', 'umap', 'pca'];
			if ~ismember(type, type_list)
				error(['Exception: ' type ' not in list. Possible types are: ' strjoin(type_list, ', ')])
			end

			file = fullfile(Manager.DefaultSaveLocation, type, name);
            if exist(file, 'file')
				load(file, 'data');
				if strcmp(type,'spect')
					data.y = data.y(:, :, channels);
				end
            else
                data = struct();
            end
		end
	end
end