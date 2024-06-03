function [path, CTinfo, varargout] = extract_data(PatPath, PatientID)

% Estrae le informazioni dalla cartella 'Immagini' per il paziente definito
% in PatientID
% Added the Varargout option in order to extract more info if necessary:
  % Varargout{1} = zDim 
  % Varargout{2} = list of structure names
  % Varargout{3} = Dicom Info of structures
  % Varargout{4} = Info of ROI contours
  % @Nicola 02/10/2023
% Update: Added the input argument: "PatPath" in case you are using
% patients from another folder (addition for the Desktop Application)
% @Nicola 01-04-2024
  
CTpath = fullfile(PatPath,'\', 'CT');
STRname = strcat('RS.', PatientID, '.dcm');
STRpath = fullfile(PatPath,'\', STRname);
% currentFolder = pwd;
% CTpath = fullfile(currentFolder, CTpath);
% STRpath = fullfile(currentFolder, STRpath);
elementi = dir(CTpath);
CTinfo=dicominfo(fullfile(elementi(3).folder, elementi(3).name));
CTinfo0=dicominfo(fullfile(elementi(end).folder, elementi(end).name));
if CTinfo0.ImagePositionPatient(3)>CTinfo.ImagePositionPatient(3)  %%necessario per il verso di acquisizione rivedere!
    CTinfo=CTinfo0;
end
xDim=CTinfo.Width; yDim=CTinfo.Height; varargout{1}=length(elementi)-2;
dimCT = [xDim yDim varargout{1}];
CTorigin=CTinfo.ImagePositionPatient;
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;  % mm

varargout{3} = dicominfo(STRpath);
varargout{4} = dicomContours(varargout{3}); % estrai i ROI data nel formato dicomContours object
varargout{2} = varargout{4}.ROIs.Name;

path{1,1} = CTpath;
path{1,2} = STRpath;

end