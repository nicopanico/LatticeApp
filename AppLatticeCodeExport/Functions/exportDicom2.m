function [contourOut, infoOut, number] = exportDicom2(PatientID, CTinfo, zDim, path0, path, maskSphere, case_name)

% Uso la funzione di Matlab: https://it.mathworks.com/help/images/ref/dicomcontours.converttoinfo.html
% Essendoci più sfere nelle stesse slices, e lui cerca di chiudere le
% strutture (poligoni chiusi) il codice di Matlab non riesce. Bisogna farlo
% girare fetta per fetta (z) e sfera per sfera. Dunque contourXYZ deve
% essere la sequenza: per ogni slice z, prima punti XY sfera 1, poi
% eventuale sfera 2 ecc
% Update: Added the case_name part in order to save the Dicom of lattice with
% different names 
% @Nicola 28'07'2023
% ...added the function Mask2Contour to make it faster and clearer
% @Nicola 12-10-23


% Convert lattice into structure

[contourOut, infoOut, number] = Mask2Contour(CTinfo, zDim, path, maskSphere, "LatticeMatlab", [0;255;0])

% Write the Dicom with the new ROI "LatticeMatlab" and save it in the
% patient folder "immagini\PatientID"

nameSTR = strcat(path0,'STR_Lattice_', PatientID, '_', case_name, '.dcm');
dicomwrite([],nameSTR,infoOut,"CreateMode","copy");

end