function  plot_dicom_ROI(contour,ROI_name)

%given the contour set from the Dicom with all the ROI metadata
%the function plots the ROI selected
%Inputs: contour == ROIs metadata taken from the Dicom using DicomContour
%        ROI_name == name of the ROI wanted given as a string '__'
%   
% Nicola-2023

for ii = 1 : size(contour.ROIs,1)

  if  strcmp(contour.ROIs.Name{ii},ROI_name) %take the ROI denoted as GTV

     ROI_wanted = contour.ROIs(ii, :);
     plotContour(contour,ii); %plot the ROI Volume

  end
end

