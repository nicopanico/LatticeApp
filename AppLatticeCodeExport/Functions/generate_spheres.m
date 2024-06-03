function maskSphere_3D = generate_spheres(CTinfo, zDim, radius, lattice3D)

% Prende LATTICE da reverseRotation e costruisce sfere dal raggio 'radius'
% intorno ai  vertici di maskLattice.
%
% maskSphere è un 512x512x112, quindi ha una mask contenente tutte le
% sfere, al contrario della funzione "generate_sphere2"


xDim=double(CTinfo.Width); yDim=double(CTinfo.Height); zDim = double(zDim);
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;  % mm
% righe=vertices(:,1); colonne=vertices(:,2); zeta=vertices(:,3); % Reticolo originale (non traslato)
% trasl = to_evaluate(index, 2:4);  % Prendo la prima traslaz che da max numero vertici
% maskReticoloTrasl_3D = false(xDim,yDim,zDim);

% r=righe+(trasl(1)-1);
% c=colonne+(trasl(2)-1);
% z=zeta+(trasl(3)-1);
% r(r>xDim)=xDim;
% c(c>yDim)=yDim;
% z(z>zDim)=zDim;
% 
% maskReticoloTrasl_1D=sub2ind([xDim yDim zDim],r,c,z);
% maskReticoloTrasl_3D(maskReticoloTrasl_1D)=1;        % Reticolo traslato
% maskLattice_3D = maskReticoloTrasl_3D.*maskPTV_3D;   % Reticolo traslato interno al PTV
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
maskSphere_3D = false(xDim,yDim,zDim);
for i = 1:nVertices
    maskSphere_3D = maskSphere_3D | ((xx - cVertex(i)).^2 + (yy - rVertex(i)).^2 + (zz - zVertex(i)).^2) <= radius^2;
end

end

