function [reticolo3D, distVertex_px] = generate_lattice_iso_app(CTinfo, zDim, distVertex)

% Crea un reticolo (maskReticolo_3D) con distanza dei vertici pari a
% distVertex (mm), restituisce anche la distanza dei vertici
% (distVertex_px) in unità di pixel
% 
% Typical CT: 512x512xSlice   PixelSpacing=0.9766 mm; slicegap=3 mm

xDim = CTinfo.Width;
yDim = CTinfo.Height;
PixelSpacing = CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;

dist_x = round(distVertex(1) / PixelSpacing);
dist_y = round(distVertex(2) / PixelSpacing);
dist_z = round(distVertex(3) / PixelSpacing);

% Inizializza i reticoli
reticolo3D = false(xDim, yDim, zDim);

% Genera il reticolo
for z = 1:dist_z:zDim 
    [X, Y] = meshgrid(1:xDim, 1:yDim);
    reticolo_slice = mod(floor((X-1) / dist_x) + floor((Y-1) / dist_y), 2) == 0;
    reticolo3D(:, :, z) = reticolo_slice;
end

distVertex_px = [dist_x, dist_y, dist_z];
end