function [contourXYZ] = Mask2Contour(CTinfo, zDim, Mask)

% Function in order to convert a 3D mask into a Dicom Roi contour to be
% exported starting from the Dicom CTinfo and the number of slices (zDim)
% The conversion and contour reconstruction has to be performed slice by
% slice using the zDim and the mask informations

% INputs:
        % CTinfo = DicomCT info to recosntruct the contour
        % zDim = number of slices where to recontruct the contour
        % Mask = 3D ROI mask to be converted
% OUTputs:
        % contourXYZ = contour slice by slice of the input Mask

% @Nicola 19-10-23

% importing usefull values from the Dicom
% STRpath = path{1,2};
% infoIn = dicominfo(STRpath);
% contourIn = dicomContours(infoIn);% estrai i ROI data nel formato dicomContours object
CTorigin=CTinfo.ImagePositionPatient;
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;  % mm
CC = bwconncomp(Mask); % trova i punti connessi
nVertices=CC.NumObjects;
% Set default values for the contour name and the color of the contour and
% the position of the ROI in the ROIs names list
% if nargin <= 4
%     contourName = "Mask";
%     color = [0;255;0]; % red color
%     number = max(contourIn.ROIs.Number)+1;  
% elseif nargin == 5
%     contourName = varargin{1};
%     color = [0; 255; 0]; % red color
%     number = max(contourIn.ROIs.Number)+1;  % default as last pos. of the ROIs contours
% elseif nargin == 6
%     contourName = varargin{1};
%     color = varargin{2};
%     number = max(contourIn.ROIs.Number)+1;  
% else
%     number = varargin{3};
%     contourName = varargin{1};
%     color = varargin{2};
% end


% Create the cell
maskSphere_cell=cell(1,nVertices);
for i=1:nVertices
    maskSphere_cell{i}=false(size(Mask));
    maskSphere_cell{i}(CC.PixelIdxList{i})=Mask(CC.PixelIdxList{i});
end

contourXYZ = cell(1,1);
k=1;
% geometricType = "Closed_planar";


% the conversion to contour has to be done slice for slice (Z)
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

% contourOut = addContour(contourIn,number,contourName,contourXYZ,geometricType, color);
% infoOut = convertToInfo(contourOut);
% itemNum=number;
% ItemNumber = strcat('Item_', num2str(itemNum));
% infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationNumber', infoOut.RTROIObservationsSequence.Item_1.ObservationNumber);
% infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationLabel', convertStringsToChars( contourName ));
% infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ROIInterpreter', infoOut.RTROIObservationsSequence.Item_1.ROIInterpreter);
% infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', infoOut.RTROIObservationsSequence.Item_1.RTROIInterpretedType);
% infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ReferencedFrameOfReferenceUID', infoOut.StructureSetROISequence.Item_1.ReferencedFrameOfReferenceUID);
% infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ROIGenerationAlgorithm', infoOut.StructureSetROISequence.Item_1.ROIGenerationAlgorithm);
% infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', 'CTV');

end
