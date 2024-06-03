function [contourOut, infoOut, number] = exportDicom(PatientID, CTinfo, zDim, path, maskSphere_cell, nVertices)

% Uso la funzione di Matlab: https://it.mathworks.com/help/images/ref/dicomcontours.converttoinfo.html
% Essendoci più sfere nelle stesse slices, e lui cerca di chiudere le
% strutture (poligoni chiusi) il codice di Matlab non riesce. Bisogna farlo
% girare fetta per fetta (z) e sfera per sfera. Dunque contourXYZ deve
% essere la sequenza: per ogni slice z, prima punti XY sfera 1, poi
% eventuale sfera 2 ecc

STRpath = path{1,2};
CTorigin=CTinfo.ImagePositionPatient;
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;  % mm

contourXYZ = cell(1,1);
k=1;
infoIn = dicominfo(STRpath);
contourIn = dicomContours(infoIn); % estrai i ROI data nel formato dicomContours object
number = max(contourIn.ROIs.Number)+1;  % specify these attributes of the ROI (!!!!TO VERIFY!!!!!!)
name = "LatticeMatlab";
geometricType = "Closed_planar";
color = [0;255;0]; % red

for z = 1:zDim
    for i = 1:nVertices
        poly=mask2poly(maskSphere_cell{i}(:,:,z),'Exact'); %Estrae poligono dalla mask (XY)
        poly(poly(:,1)<1,:) = []; % Elimino quel punto in più che dava
        if ~isempty(poly)    
            colZ = repmat((z-1)*slicegap+(CTorigin(3)-(zDim-1)*slicegap),size(poly,1),1); % Coordinata z per ogni punto (tutte uguali siamo in una fetta z)
            poly = (poly-1) * PixelSpacing + CTorigin(1:2)';
            polyZ = [poly colZ];  % Poligono XYZ
            contourXYZ{k,1}=polyZ;
            k = k+1;
        end
    end
end

contourOut = addContour(contourIn,number,name,contourXYZ,geometricType, color);
infoOut = convertToInfo(contourOut);
ItemNumber = strcat('Item_', num2str(number));
infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationNumber', infoOut.RTROIObservationsSequence.Item_1.ObservationNumber);
infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationLabel', 'LatticeMatlab');
infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ROIInterpreter', infoOut.RTROIObservationsSequence.Item_1.ROIInterpreter);
infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', infoOut.RTROIObservationsSequence.Item_1.RTROIInterpretedType);
infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ReferencedFrameOfReferenceUID', infoOut.StructureSetROISequence.Item_1.ReferencedFrameOfReferenceUID);
infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ROIGenerationAlgorithm', infoOut.StructureSetROISequence.Item_1.ROIGenerationAlgorithm);
infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', 'CTV');

nameSTR = strcat('STR_Lattice_', PatientID, '.dcm');
dicomwrite([],nameSTR,infoOut,"CreateMode","copy");

end