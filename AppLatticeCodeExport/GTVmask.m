function [contourOut, varargout] = GTVmask(crop_mask, expand_mask, CTinfo, zDim, contourIn, varargin)

% Function to create the mask and then add it as a Dicom contour to the
% ROIs, starting from the GTV crop mask and the expanded OARs masks the
% function uses the already developed functions Mask2Contour and addROI
% Remember to specify also the features of your ROI in varargin if you want
% something else different from the default

% @Nicola 19-10-23

%convert the mask to logical if necessary
crop_mask1 = crop_mask == 1;
expand_mask1 = expand_mask == 1;

% Find the intersection and subtract it to the original mask to find the
% margin to the OAR and also crop for them and obtai  the final mask
varargout{1} =crop_mask1 - (crop_mask1 .* expand_mask1);

%%
% Converting it from binary mask to contour and adding it as a Dicom ROI
[contourXYZ] = Mask2Contour(CTinfo, zDim, varargout{1});
[contourOut, varargout{2}, varargout{3}] = addROI(contourIn, contourXYZ, varargin{1}, varargin{2});

% dicomwrite(,path{1,2},varargout{2},"CreateMode","copy");

end


