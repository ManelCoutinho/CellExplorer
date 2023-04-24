# Neuroscope2 Documentation
Documentation of the main features added to Neuroscope2 developed. Full documentation can be found [here](https://cellexplorer.org/interface/neuroscope2/).

![NeuroScope2](https://raw.githubusercontent.com/petersenpeter/common_resources/main/images/NeuroScope2_screenshot_1.png)

## Run
### Matlab Script

In Matlab go to the basepath of the session you want to visualize. Now run NeuroScope2:
```m
NeuroScope2
```
NeuroScope2 will detect and load an existing `basename.session.mat` from the folder. If it is missing, it will generate the metadata Matlab struct using the template script `sessionTemplate`. The template script will detect and import metadata from:
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
> Neuroscope will assume that you are reading a lfp file by default, if you are using ECoG set the lfp flag to false:
>```matlab
>% Setting NeuroScope2 lfp flag
>NeuroScope2('lfp',false)
>```

### Compiled Version
There are 2 main ways of running the script:
1. Without Arguments: will open a file selector menu.  
   ```shell
	foo@bar:~$ ./NeuroScope2
	```
2. With name of the file as an argument
   ```shell
	foo@bar:~$ ./NeuroScope2 /path/to/file.xml
	```

## New Main Features

### Channel Spectrogram
**Description**:  
Shows a channel spectrogram of the visible ephys traces on their right side in the same order as they are shown.

**Location**:  
Analysis Tab &rarr; Improved Spectrograms Section &rarr; 1st checkbox

**Interaction**:  
You can adjust the spectrogram using the lower part of this section by chaning the window width (should be lower than the current displayed window duration), defining the overlap and the frequency range (max frequency should be lower than half of the sampling rate).

_Left Mouse Click_ selects the a new channel to hightlight (might influence the other spectrogram) while _Right Click_ highlights a frequency.

### Improved Spectrogram
**Description**:  
Shows the spectrogram of the selected channel below the ephys traces for the current window.

**Location**:  
Analysis Tab &rarr; Improved Spectrograms Section &rarr; 2nd checkbox

**Interaction**:  
You can adjust the spectrogram using the lower part of this section by chaning the window width (should be lower than the current displayed window duration), defining the overlap and the frequency range (max frequency should be lower than half of the sampling rate).   
You can also change the selected channel by hand or decouple it from the current window, allowing you to visualize the spectrogram for the full session (might take a while to calculate).

In addition to the usual zoom, pan and move mouse iteraction, the _Right Click_ highlights a frequency, while the _Left Click_ can select a specific time in the decouple view.

### ECoG Grid
**Description**:  
Shows a grid of the current sample color coded in a new window for ECoG visualizations. Assumes that the session has 256 channels.

**Location**:  
Menu Bar &rarr; Settings Option &rarr; Show ECoG Grid

**Interaction**:  
You can change the sample being represented by left clicking on the ephys traces. _Right Mouse Click_ on the grid selects the corresponding channel to hightlight (might influence other spectrograms). 


### Clustering
**Description**:  
Opens a menu that allows you to choose how do you pretend to do perform the dimensionality reduction based on the spectrogram properties of the selected channels.  
After the computation, a scatter plot is shown with the different sample embeddings in 2D space and the different states are colored following a ```*.states.mat``` file.   

The results of both the spectrograms and the clustering is saved in a ```data``` folder with their parameterization indexed.

> **⚠ Warning:**  
> Spectrogram processing is based on Pablo's paper and it is sub ideal, if you want to use this, a common template of inputs and outputs should be agreed on to enable different types of processing.

**Location**:  
Menu Bar &rarr; Analysis Option &rarr; Cluster Folder &rarr;  tsne_umap  

**Interaction**:  
Besides the main menu, the final plot has the regular zoom, pan and move mouse interaction.   
In addition, you might select one of the samples to highlight, which will move the window of the ephys traces accordingly, and jump to a random nearby sample using the arrows.


## Contribute
If you want to contribute to this project either:
- Create a **branch** with the format ```feature/name``` and do a pull request with the ```lmu-lab``` branch
- Open an issue/feature request in the github repo
- Contact me directly

## Compilation   
You have to add the following packages to compile NeuroScope2:
- +analysis_tools
- toolboxes/GUI Layout Toolbox 2.3.5
- toolboxes/umap1.3.3