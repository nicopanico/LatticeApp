PatientID = '477-20';
CTpath = fullfile('Immagini', PatientID, 'CT');
STRname = strcat('RS.', PatientID, '.dcm');
STRpath = fullfile('Immagini', PatientID, STRname);
currentFolder = pwd;
CTpath = fullfile(currentFolder, CTpath);
STRpath = fullfile(currentFolder, STRpath);

infoIn = dicominfo(STRpath);
contourIn = dicomContours(infoIn);
strList = contourIn.ROIs.Name;

figure('Name','All structures');
plotContour(contourIn) % Visualizza la struttura
grid on

%%
figure('Name','All structures');
plotContour(contourIn, [1 2])
grid on