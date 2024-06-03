function [crop_mask, varargout] = cropGTV(path, nPTV, radius)
% First code update...
% @Nicola 29/09/2023

% Function in order to create cropped mask of the GTV based on the radius
% of the vertices.
% INputs:
         % path = containing the path of the Dicoms
         % nPTV = defined as the indices in the Dicom ROI of the GTV
         % radius =  radius of the spheres/vertices defined in the setup
% Output:
         % crop_mask = cropped mask of the GTV defined as mask
         % GTV_mask* = (optional) also the binary mask of the GTV

% @Nicola 12-10-23


varargout{1} = get_3D_mask(path{1,1}, path{1,2}, nPTV); %get the GTV binary mask

% Create the grid for the filter
[X,Y,Z] = ndgrid(-10:10, -10:10, -10:3:10);
% Sphere inside the filter to perform the operation
nhood = sqrt(X.^2 + Y.^2 + Z.^2) <= radius;
crop_mask = imerode(varargout{1}, nhood);

end


