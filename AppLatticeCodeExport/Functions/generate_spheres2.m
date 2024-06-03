function [maskSphere_cell, nVertices] = generate_spheres2(CTinfo, zDim, radius, lattice3D)

% Prende la prima traslazione che massimizza il numero di vertici (ind(1)),
% costruisco il reticolo con tale traslazione (maskReticoloTrasl), faccio
% convoluzione con PTV (maskLattice) e costruisco sfere dal raggio 'radius'
% intorno ai  vertici di maskLattice.
%
% maskSphere è un 512x512x112xnSphere, quindi ha una mask per ogni sfera
% (serve così quando si forma il DICOM per avere un contourXY ordinato per
% z e per sfera)
% last edit 02/09/2022

fprintf("\nCreating mask with the spheres\n")
% Costruisco Reticolo traslato
xDim=double(CTinfo.Width); yDim=double(CTinfo.Height); zDim = double(zDim);
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;  % mm

lattice1D = find(lattice3D);
[rVertex, cVertex, zVertex]=ind2sub([xDim yDim zDim],lattice1D);  % Vertici reticolo traslato in PTV in coordinate XYZ

% Aggiungo sfera dal diametro raggio r, per ogni vertice
[xx, yy, zz] = meshgrid(1:xDim, 1:yDim, 1:zDim);
xx=double(xx); yy=double(yy); zz=double(zz);
xx = xx.*PixelSpacing;
yy = yy.*PixelSpacing;
zz = (zDim+1-zz).*slicegap; 
rVertex = rVertex*PixelSpacing;
cVertex = cVertex*PixelSpacing;
zVertex = (zDim+1-zVertex)*slicegap;
nVertices = length(lattice1D);   % numero vertici della Lattice entro il PTV
maskSphere_cell = cell(xDim,yDim,zDim, nVertices);
for i = 1:nVertices
    maskSphere_cell{i} = ((xx - cVertex(i)).^2 + (yy - rVertex(i)).^2 + (zz - zVertex(i)).^2) <= radius^2;
end
end

