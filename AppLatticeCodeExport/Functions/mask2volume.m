function [vol, varargout] = mask2volume(CTinfo, GTVmask)

% Define the x and y of the Voxel
xx = CTinfo.PixelSpacing(1); yy = CTinfo.PixelSpacing(2);
% Slice thinknes, z of the Voxel
zz = CTinfo.SliceThickness;
voxelVol = xx*yy*zz;
% Calculate the voxels from the mask 
Voxels = sum(GTVmask(:));

% Multiply the Voxels for the Voxel Volume and convert it in cc
vol  = (Voxels * voxelVol)/1000 ;

%% Evaluate the Area-to-surface ratio as optional output (if necessary)
TargetMaskLogi = logical(GTVmask);
% Calculate surface area using isosurface
[faces, vertices] = isosurface(TargetMaskLogi, 0.5);

% Calculate surface area
surfaceArea = surface_area(vertices, faces);

varargout{1} = surfaceArea/vol;

end