# Neuroscope2 Documentation
Documentation of the main features added to Neuroscope2 developed. Full documentation can be found [here](https://cellexplorer.org/interface/neuroscope2/).

![NeuroScope2](https://raw.githubusercontent.com/petersenpeter/common_resources/main/images/NeuroScope2_screenshot_1.png)

## Run
### Matlab Script

In Matlab go to the basepath of the session you want to visualize. Now run NeuroScope2:
```m
NeuroScope2
```
NeuroScope2 will detect and load an existing `basename.session.mat` from the folder. If missing, it will generate the metadata Matlab struct using the template script `sessionTemplate`. The template script will detect and import metadata from:
* An existing `basename.xml` file (NeuroSuite)
* From Intan's `info.rhd` file
* From KiloSort's `rez.mat` file
* From a `basename.sessionInfo.mat` (Buzcode) file. 

You can also specify a basepath or a session struct when opening NeuroScope2:
```matlab
% Open NeuroScope2 specifying a basepath
NeuroScope2('basepath',basepath)

% Open NeuroScope2 specifying a session struct
NeuroScope2('session',session)
```
> **⚠ Warning:**  
> Neuroscope will assume that you are using the sample rate defined in the Acquisition Field of the XML file by default. If you want to use the ```lfpSamplingRate``` parameter set the ```acq``` flag to _false_.   
> If you are using the compiled version, you can use the Session Metadata GUI.
>```Matlab
>% Setting NeuroScope2 lfp flag
>NeuroScope2('acq',false)
>```

### Compiled Version
There are 2 main ways of running the script:
1. Without Arguments: will open a file selector menu.  
   ```shell
	foo@bar:~$ ./NeuroScope2
	```
2. With name of the file as an argument
   ```shell
	foo@bar:~$ ./NeuroScope2 /path/to/file.lfp
	```

> **⚠ Warning:**  
> Make sure that you have a file with one of the extensions specified [above](#matlab-script), i.e., if your ```.lfp``` file is called ```animal_1.rec_1.interp.lfp```, your ```.xml``` should have the same basename (```animal_1.rec_1.interp.xml```).

## New Main Features

### Channel Spectrogram
![ChannelSpectrogram](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/54cb8292-fe03-47ff-978d-e3bc7630c1e5)

**Description**:  
Shows a channel spectrogram of the visible ephys traces on their right side in the same order as they are shown. You can choose between logarithmic and linear scale for the power of the spectrogram.  
  
**Location**:  
Analysis Tab &rarr; Improved Spectrograms Section &rarr; 1st checkbox   
![ChannelSpectrogramLoc](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/12dc45f4-2b74-44ef-ace9-1c7a558ef079)

**Interaction**:  
You can adjust the spectrogram using the lower part of this section by changing the window width (should be lower than the current displayed window duration), defining the overlap and the frequency range (max frequency should be lower than half of the sampling rate).

_Left Mouse Click_ selects a new channel to highlight in the Traces Plot. Changes the selected channel in the [Improved Spectrogram](#improved-spectrogram) and highlights the corresponding square in the [Ecog Grid](#ecog-grid).  
_Right Click_ highlights a frequency with a vertical line. If the [Improved Spectrogram](#improved-spectrogram) is open, the same frequency will also be highlighted with a horizontal line, and the selected frequency will change if the [Ecog Grid](#ecog-grid) is in ```spectrogram``` mode.

### Improved Spectrogram
![ImprovedSpectrogram](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/e0b6a6da-ff4f-47d7-afff-2cd0a0550e19)

**Description**:  
Shows the spectrogram of the selected channel below the ephys traces for the current window. You can choose between logarithmic and linear scale for the power of the spectrogram.  

**Location**:  
Analysis Tab &rarr; Improved Spectrograms Section &rarr; 2nd checkbox   
![ImprovedSpectrogramLoc](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/eea7728a-3cd0-440c-ada8-e9526f446fae)


**Interaction**:  
You can adjust the spectrogram using the lower part of this section by changing the window width (should be lower than the current displayed window duration), defining the overlap and the frequency range (max frequency should be lower than half of the sampling rate).   
You can also change the selected channel by hand or decouple it from the current window, allowing you to visualize the spectrogram for the full session (it might take a while to calculate).

_Default Mouse Interactions_ like the usual zoom, pan and move are available   
_Right Click_ highlights a frequency (which will also be highlighted in the [Channel Spectrogram](#channel-spectrogram) if open), and changes the selected frequency if the [Ecog Grid](#ecog-grid) is in ```spectrogram``` mode   
_Left Click_ can select a specific time in the decouple view, which also changes the timestep being sampled if the [Ecog Grid](#ecog-grid) is in ```raw``` mode or the window to calculate the spectrograms for both the [Channel Spectrogram](#channel-spectrogram) and the [Ecog Grid](#ecog-grid) (in ```spectrogram``` mode).

### ECoG Grid
![EcogGrid](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/18071034-d9f0-4d47-b0eb-2f26f3dfe581)

**Description**:   
Opens a new window and plots color-coded data in a grid according to the groups specified in the .xml file.   
The user can choose between plotting one sample of the traces at a certain point (```raw``` mode) or the channel spectrogram at a specific frequency (```spectrogram``` mode) - the settings for the spectrogram are in the same menu described previously.   
It also enables the user to export a video of the ecog grid evolution across a desired interval.   
The limits for the interval to be exported are shown in three different places:
- Session Epochs Plot: the second last section in the General tab of the left sidebar will show 2 green bars corresponding to the beginning and end of the interval;
- Improved Spectrogram: when in decouple mode, two lines vertical indicating the start and end of the interval will be shown;
- Ephys Traces Plot: the lines will also be shown on the main plot (if the current window allows you to see them).

> **⚠ Warning:**  
> Every group must have the same number of channels.


**Location**:  
Menu Bar &rarr; Settings Option &rarr; Show ECoG Grid   
![EcogGridLoc](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/49655209-33c2-488b-9f80-0688357931ac)


**Interaction**:  
_Left Mouse Click_ selects the corresponding channel and highlights both in this plot and the main ephys traces plot. This will also change the channel selected for the [Improved Spectrogram](#improved-spectrogram).   
The sample being plotted can be changed by left-clicking on the ephys traces, while the frequency by right-clicking on either of the explained spectrograms (or entering an approximate number in the appropriate box).   
You can use the options to set a fixed scale for the ECoG grid, choose between the two modes, or export a video of a defined interval with the desired frame rate, sample step (or refresh rate),... - while the other refresh rate options are based on the main plot window, the ```Default``` is based on the overlap used to calculate the spectrogram.

> **⚠ Warning:**  
> The frequency entered in the input area won't be exact since the spectrogram doesn't sample every frequency point between the specified limits. For the exact frequency being chosen, select them with your mouse in one of the ways described above.



### Clustering
**Description**:  
Opens a menu that allows you to choose how you pretend to perform the dimensionality reduction based on the spectrogram properties of the selected channels.  
After the computation, a scatter plot is shown with the different sample embeddings in 2D space and the different states are colored following a ```*.states.mat``` file.   

The results of both the spectrograms and the clustering are saved in a ```data``` folder with their parameterization indexed.

> **⚠ Warning:**  
> Spectrogram processing is based on Pablo's paper and it is sub-ideal, if you want to use this, a common template of inputs and outputs should be agreed on to enable different types of processing.

**Location**:  
Menu Bar &rarr; Analysis Option &rarr; Cluster Folder &rarr;  tsne_umap  
![ClusterLoc](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/350898f3-ab75-4593-ab5c-db6e013bc523)


**Interaction**:  
Besides the main menu, the final plot has the regular zoom, pan and move mouse interaction.   
In addition, you might select one of the samples to highlight, which will move the window of the ephys traces accordingly, and jump to a random nearby sample using the arrows.   
![ClusterInt](https://github.com/ManelCoutinho/CellExplorer/assets/37669762/88eff4ca-2f15-4216-a433-ff3095ed223f)


### Other Features
**Streaming:**   
Streaming the data was optimized for the [Ecog Grid](#ecog-grid). Now, if you choose the ```raw``` mode, the stream speed changes to the number of samples per second that you want to plot and the white line indicating the sample being plotted moves swiftly through the ephys traces. In the ```spectrogram``` mode or any other circumstances, since the plots are derived from the whole window, the stream speed are the usual 0.5x, 2x, ... options.
> **⚠ Warning:**  
> Channel Spectrograms take a while to calculate so it is not advisable to go faster than 0.05x.

**Sparsify:**   
Due to the huge amount of channels that these recordings tend to have, and the fact that they are quite often redundant, the user can choose to drop every X-channel of one channel group, making every visualization faster to compute.   
This option can be found in the General Tab of the left sidebar, under the ```Extracellular traces``` section.  

**Saving Module:**   
[This](lmuLab/saving/) module was created so that different spectrogram calculations could be saved and fetched at will in order to improve the performance of the program by avoiding repetitive and costly operations. Specially used for the [Clustering](#clustering). All the files will be saved in the basepath inside the ```NeuroScope2_data``` folder.


## Matlab data structures
### States
Simple explanation of the states file, for a more detailed breakdown, please refer to this [page](https://cellexplorer.org/datastructure/data-structure-and-format/#states).

Name format: `basename.statesName.states.mat` (you can add multiple states to the same file). It has the following struct:
* `statesName`: same name as the random one chosen for the file with the following inside:
	* `.ints`: a struct containing the different states (e.g. REM, RUN, SWS, ...).
  		* `.stateName`: [Nx2] double with start/stop time for each instance of state stateName.
		
> **⚠ Warning:**  
> If intervals by samples are being used, don't forget to convert it to time by dividing by the sample frequency.

*Example:*  
In this case `statesName` is Test and the three defined `stateName` are REM, RUN and  SWS.   
![StateFileExample](https://user-images.githubusercontent.com/37669762/235695157-4c028ec3-a51d-4829-81b0-e43370d29b79.png)



## Contribute
If you want to contribute to this project either:
- Create a **branch** with the format ```feature/name``` and do a pull request with the ```lmu-lab``` branch
- Open an issue/feature request in the GitHub repo
- Contact me directly

## Compilation   
You have to add the following packages to compile NeuroScope2:
- +analysis_tools
- toolboxes/GUI Layout Toolbox 2.3.5
- toolboxes/umap1.3.3

## Improvements
- [x] Add Scale to ECoG
- [x] NaN ECoG
- [x] ECoG Limits
- [x] Different sizes ECoG (16x16, 32x32, 32x8)
- [ ] ECoG Grid Smoothing
- [x] Sparsify - drop every X channel
- [x] NW - add timeband to spectrogram parameters
- [ ] NaN channel spectrogram
- [ ] Fix Zoom-reset decoupled spectrogram
- [ ] Saving optimization decoupled spectrogram
- [ ] ECoG grid in tab
- [ ] ECoG grid in different tabs for different freq range
- [x] ECoG grid by spect freq instead of sample
- [x] Save ECoG grid video
- [ ] Saving ECoG limits selection with mouse
- [ ] Improve performance
- [ ] Refactor main NeuroScope2.m file

## Troubleshooting
### Missing Function Problem
Make sure that you have set the path by adding this folder and its subfolders.
### Library Problem
Make sure that you have the correct Matlab version in your ```LD_LIBRARY_PATH``` environment variable. The actual compiled version was made for Matlab 2019b so your variable should look something like this:
```m
/path/to/matlab/R2019b/runtime/glnxa64:/path/to/matlab/R2019b/bin/glnxa64:/path/to/matlab/R2019b/sys/os/glnxa64:/path/to/matlab/R2019b/sys/opengl/lib/glnxa64
```
