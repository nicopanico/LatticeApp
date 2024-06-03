function [contourOut, infoOut, number] = addROI(contourIn, contourXYZ, varargin)

% Function to add the ROi to the Dicom contour, this fucntion uses the
% built-in matlab fucntion addContour and the input features to create to
% add the new contour to the Dicom ROIs

% The function gives as output the contour info and the Dicom info and also
% the number of the newly added structure (contourOut, infoOut, number)

% the feature of the contour can be specified as
 % contourName -- varargin{1}
 % color -- varargin{2} (as an RGB triplet)
 % number -- varargin{3} 

 % If not specified they are set as default values --> ( Mask, [0, 255, 0],
 % last position in the ROIs list)

% @Nicola 19-10-23


geometricType = "Closed_planar";
if nargin <= 2
    contourName = "Mask";
    color = [0;255;0]; % red color
    number = max(contourIn.ROIs.Number)+1;  
elseif nargin == 3
    contourName = varargin{1};
    color = [0; 255; 0]; % red color
    number = max(contourIn.ROIs.Number)+1;  % default as last pos. of the ROIs contours
elseif nargin == 4
    contourName = varargin{1};
    color = varargin{2};
    number = max(contourIn.ROIs.Number)+1;  
else
    number = varargin{3};
    contourName = varargin{1};
    color = varargin{2};
end

contourOut = addContour(contourIn,number,contourName,contourXYZ,geometricType, color);
infoOut = convertToInfo(contourOut);
itemNum=number;
%ItemNumber = strcat('Item_', num2str(itemNum));
for i=1:number
    try 
        infoOut.StructureSetROISequence.(strcat('Item_',num2str(i))).ReferencedFrameOfReferenceUID;
    catch %mess
        warning('Some data not found....correcting');
        ItemNumber = strcat('Item_', num2str(i));
        infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationNumber', infoOut.RTROIObservationsSequence.Item_1.ObservationNumber);
        infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationLabel', convertStringsToChars( contourName ));
        infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ROIInterpreter', infoOut.RTROIObservationsSequence.Item_1.ROIInterpreter);
        infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', infoOut.RTROIObservationsSequence.Item_1.RTROIInterpretedType);
        infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ReferencedFrameOfReferenceUID', infoOut.StructureSetROISequence.Item_1.ReferencedFrameOfReferenceUID);
        infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ROIGenerationAlgorithm', infoOut.StructureSetROISequence.Item_1.ROIGenerationAlgorithm);
        infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', 'CTV');
    end

end
%infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationNumber', infoOut.RTROIObservationsSequence.Item_1.ObservationNumber);
%infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ObservationLabel', convertStringsToChars( contourName ));
%infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'ROIInterpreter', infoOut.RTROIObservationsSequence.Item_1.ROIInterpreter);
%infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', infoOut.RTROIObservationsSequence.Item_1.RTROIInterpretedType);
%infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ReferencedFrameOfReferenceUID', infoOut.StructureSetROISequence.Item_1.ReferencedFrameOfReferenceUID);
%infoOut = setfield(infoOut, 'StructureSetROISequence',ItemNumber,'ROIGenerationAlgorithm', infoOut.StructureSetROISequence.Item_1.ROIGenerationAlgorithm);
%infoOut = setfield(infoOut, 'RTROIObservationsSequence',ItemNumber,'RTROIInterpretedType', 'CTV');
end