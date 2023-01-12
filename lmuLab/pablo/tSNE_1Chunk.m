% t-SNE Analysis: 1 Frequency chunk

% State Classification of Mice according to brain activity
% Classes to distinguish: SWS,Active,Inactive,Hvs,Rear,Active_theta,Active_SWS
% Overlapping between the labels of some of the classes

% Author: Pablo Sarricolea
% Last time modified: 27/05/2020

%% Data Loading

[OB,DorsalHPC,MEC,EEG,VentralHPC_LEC] = UploadSpectVbles("07c","NoWhitening");
[OB2,DorsalHPC2,MEC2,EEG2,VentralHPC_LEC2] = UploadSpectVbles('09e',"NoWhitening");

%% Labels Loading

FileBase = "IF04-20181007c";
FileBase2 = "IF04-20181009e";

Fs = 1250;
plotting = true;
vbles = ["Hvs","Rear"]; %Add states w/ commas

[labels,States] = StatesLabels(FileBase,vbles,Fs,OB,plotting);
[labels2,States2] = StatesLabels(FileBase2,vbles,Fs,OB2,plotting);

disp('Data Labelled')
%% Power Mean, smoothing, normalizing, concatenating

OB.PowerSignal = PowerMean(OB.Spect.y,OB.Spect.f,[1:length(OB.Spect.y(1,1,:))],25,100);
DorsalHPC.PowerSignal = PowerMean(DorsalHPC.Spect.y,DorsalHPC.Spect.f,[1:length(DorsalHPC.Spect.y(1,1,:))],1,12);
MEC.PowerSignal = PowerMean(MEC.Spect.y,MEC.Spect.f,[1:length(MEC.Spect.y(1,1,:))],1,12);
EEG.PowerSignal = PowerMean(EEG.Spect.y,EEG.Spect.f,[1:length(EEG.Spect.y(1,1,:))],1,12);
VentralHPC_LEC.PowerSignal = PowerMean(VentralHPC_LEC.Spect.y,VentralHPC_LEC.Spect.f,[1:length(VentralHPC_LEC.Spect.y(1,1,:))],1,12);

%Variables
WindowType = 'Gauss';
Plotting = false;
WinLength=21; %number of samples

OB.Smoothed = PowerSmoothing(OB.PowerSignal,WindowType,WinLength,Plotting);
DorsalHPC.Smoothed= PowerSmoothing(DorsalHPC.PowerSignal,WindowType,WinLength,Plotting);
MEC.Smoothed = PowerSmoothing(MEC.PowerSignal,WindowType,WinLength,Plotting);
EEG.Smoothed = PowerSmoothing(EEG.PowerSignal,WindowType,WinLength,Plotting);
VentralHPC_LEC.Smoothed = PowerSmoothing(VentralHPC_LEC.PowerSignal,WindowType,WinLength,Plotting);

OB.Norm = rescale(OB.Smoothed);
DorsalHPC.Norm = rescale(DorsalHPC.Smoothed);
MEC.Norm = rescale(MEC.Smoothed);
EEG.Norm = rescale(EEG.Smoothed);
VentralHPC_LEC.Norm = rescale(VentralHPC_LEC.Smoothed);

conc.Norm = [OB.Norm(10,:);OB.Norm(20,:);OB.Norm(30,:);DorsalHPC.Norm(10,:);...
    DorsalHPC.Norm(20,:);DorsalHPC.Norm(30,:);DorsalHPC.Norm(40,:);DorsalHPC.Norm(50,:);...
    MEC.Norm(10,:);MEC.Norm(20,:);MEC.Norm(30,:);MEC.Norm(40,:);MEC.Norm(50,:);....
    EEG.Norm(10,:);VentralHPC_LEC.Norm(10,:);];

%%
labels2 = labels2(6000:length(labels2));

OB2.Spect.t = OB2.Spect.t(6000:length(OB2.Spect.t),:);
% OB.Spect.f = OB.Spect.f(6000:length(OB.Spect.f),:,:);
OB2.Spect.y = OB2.Spect.y(6000:length(OB2.Spect.y),:,:);

DorsalHPC2.Spect.t = DorsalHPC2.Spect.t(6000:length(DorsalHPC2.Spect.t),:);
% DorsalHPC.Spect.f = DorsalHPC.Spect.f(6000:length(DorsalHPC.Spect.f),:,:);
DorsalHPC2.Spect.y = DorsalHPC2.Spect.y(6000:length(DorsalHPC2.Spect.y),:,:);

MEC2.Spect.t = MEC2.Spect.t(6000:length(MEC2.Spect.t),:);
% MEC.Spect.f = MEC.Spect.f(6000:length(MEC.Spect.f),:,:);
MEC2.Spect.y = MEC2.Spect.y(6000:length(MEC2.Spect.y),:,:);

EEG2.Spect.t = EEG2.Spect.t(6000:length(EEG2.Spect.t),:);
% EEG.Spect.f = EEG.Spect.f(6000:length(EEG.Spect.f),:,:);
EEG2.Spect.y = EEG2.Spect.y(6000:length(EEG2.Spect.y),:,:);

VentralHPC_LEC2.Spect.t = VentralHPC_LEC2.Spect.t(6000:length(VentralHPC_LEC2.Spect.t),:);
% VentralHPC_LEC.Spect.f = VentralHPC_LEC.Spect.f(6000:length(VentralHPC_LEC.Spect.f),:,:);
VentralHPC_LEC2.Spect.y = VentralHPC_LEC2.Spect.y(6000:length(VentralHPC_LEC2.Spect.y),:,:);


%% Power Mean, smoothing, normalizing, concatenating

OB2.PowerSignal = PowerMean(OB2.Spect.y,OB2.Spect.f,[1:length(OB2.Spect.y(1,1,:))],25,100);
DorsalHPC2.PowerSignal = PowerMean(DorsalHPC2.Spect.y,DorsalHPC2.Spect.f,[1:length(DorsalHPC2.Spect.y(1,1,:))],1,12);
MEC2.PowerSignal = PowerMean(MEC2.Spect.y,MEC2.Spect.f,[1:length(MEC2.Spect.y(1,1,:))],1,12);
EEG2.PowerSignal = PowerMean(EEG2.Spect.y,EEG2.Spect.f,[1:length(EEG2.Spect.y(1,1,:))],1,12);
VentralHPC_LEC2.PowerSignal = PowerMean(VentralHPC_LEC2.Spect.y,VentralHPC_LEC2.Spect.f,[1:length(VentralHPC_LEC2.Spect.y(1,1,:))],1,12);

%Variables
WindowType = 'Gauss';
Plotting = false;
WinLength=21; %number of samples

OB2.Smoothed = PowerSmoothing(OB2.PowerSignal,WindowType,WinLength,Plotting);
DorsalHPC2.Smoothed= PowerSmoothing(DorsalHPC2.PowerSignal,WindowType,WinLength,Plotting);
MEC2.Smoothed = PowerSmoothing(MEC2.PowerSignal,WindowType,WinLength,Plotting);
EEG2.Smoothed = PowerSmoothing(EEG2.PowerSignal,WindowType,WinLength,Plotting);
VentralHPC_LEC2.Smoothed = PowerSmoothing(VentralHPC_LEC2.PowerSignal,WindowType,WinLength,Plotting);

OB2.Norm = rescale(OB2.Smoothed);
DorsalHPC2.Norm = rescale(DorsalHPC2.Smoothed);
MEC2.Norm = rescale(MEC2.Smoothed);
EEG2.Norm = rescale(EEG2.Smoothed);
VentralHPC_LEC2.Norm = rescale(VentralHPC_LEC2.Smoothed);

conc2.Norm = [OB2.Norm(10,:);OB2.Norm(20,:);OB2.Norm(30,:);DorsalHPC2.Norm(10,:);...
    DorsalHPC2.Norm(20,:);DorsalHPC2.Norm(30,:);DorsalHPC2.Norm(40,:);DorsalHPC2.Norm(50,:);...
    MEC2.Norm(10,:);MEC2.Norm(20,:);MEC2.Norm(30,:);MEC2.Norm(40,:);MEC2.Norm(50,:);....
    EEG2.Norm(10,:);VentralHPC_LEC2.Norm(10,:)];


% %%
% 
% corrcoef(DorsalHPC.Norm2(20,:),DorsalHPC.Norm(20,:))
% %%
% 
% figure
% plot(rescale(OB.Smoothed(20,:)))
% hold on
% plot(rescale(OB.Smoothed2(20,:)))
% %%
% figure
% plot(OB.Norm2(20,:))
% hold on
% % plot(OB.Norm2(20,:))
% % hold on
% plot(OB.Norm(20,:))
% 
% %%
% figure
% plot(OB.PowerSignal(20,:))
% hold on
% plot(OB.Smoothed(20,:))


%% Concatenating information from both files

new_mat = [conc.Norm conc2.Norm].';
new_labels = [labels; labels2];
%% t-SNE calculation
tic;

% Creation of new dimension matrix. Only 2 dimensions
X = tsne(new_mat,'Algorithm','exact','Distance','Mahalanobis');
t = toc/60;
fprintf('Time taken: %.2f minutes',t)

%% plotting t-SNE graph
figure
gscatter(X(:,1),X(:,2),new_labels)
xlabel('1st Dimension')
ylabel('2nd Dimension')
tit = "1-chunk t-SNE. NoWhitening";
title(tit)

%% k-fold CV

n_fold=10;
a = 1;
b = 10;
indices = round(a + (b-a).*rand(length(new_labels),1));
% indices = crossvalind('Kfold',labels,n_fold);
acc= [];
err = [];
C=[];

for i=1:n_fold
    test = (indices == i);
    train = ~test;
    % model = TreeBagger(200,X(train,:),labels(train,:));
    model = fitcknn(X(train,:),new_labels(train,:),'NumNeighbors',2);
    y_hat = predict(model,X(test,:));
    % C{i} = confusionmat(labels(test,:),str2double(y_hat));
    C{i} = confusionmat(new_labels(test,:),y_hat);
end

%% LOOCV


acc_LOOCV= [];
err_LOOCV = [];
y_hat=[];

train_length = size(conc.Norm,2);

model_LOOCV = fitcknn(X(1:train_length,:),new_labels(1:train_length,:),'NumNeighbors',2);
y_hat = predict(model_LOOCV,X((train_length+1):size(X,1),:));
C_LOOCV = confusionmat(new_labels(train_length+1:size(X,1),:),y_hat);

%%

save('confusionmat_1Chunk_NoWhitening_Kfold_Rear.mat','C','t')
save('confusionmat_1Chunk_NoWhitening_LOOCV_Rear.mat','C_LOOCV','t')