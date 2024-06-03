% function lattice2 = provaReverse(CTinfo, zDim, W, vertices, to_evaluate, ind, vq, centerOfMass1, radius)

% Parametri
xDim=double(CTinfo.Width); yDim=double(CTinfo.Height); zDim = double(zDim);
righe=vertices(:,1); colonne=vertices(:,2); zeta=vertices(:,3); % Reticolo originale (non traslato)
trasl = to_evaluate(indOpt, 2:4);  % Prendo la traslazione ind

% Righe,colonne,zeta del reticolo traslato
maskReticoloTrasl_3D = false(xDim,yDim,zDim);
r=righe+(trasl(1)-1);
c=colonne+(trasl(2)-1);
z=zeta+(trasl(3)-1);
r(r>xDim)=xDim;
c(c>yDim)=yDim;
z(z>zDim)=zDim;

% Costruisco Lattice (Reticolo*PTV), il PTV ruotato (vq)
maskReticoloTrasl_1D=sub2ind([xDim yDim zDim],r,c,z);
maskReticoloTrasl_3D(maskReticoloTrasl_1D)=1;        % Reticolo traslato
maskLattice_3D = maskReticoloTrasl_3D.*vq;   % Reticolo traslato interno al PTV

% Costruisco la meshgrid
xsp=CTinfo.PixelSpacing(1);  % mm
ysp=xsp; % mm
zsp = CTinfo.SliceThickness;  % mm
x=0:xsp:(xDim-1)*xsp; 
y=0:ysp:(yDim-1)*ysp;
z=0:zsp:(zDim-1)*zsp;
[X,Y,Z]=meshgrid(x,y,z);

% Coordinate XYZ1 con origine nel centro di massa della Lattice
meanA = mean(vq(:));
centerOfMassX = mean(vq(:) .* X(:)) / meanA;
centerOfMassY = mean(vq(:) .* Y(:)) / meanA;
centerOfMassZ = mean(vq(:) .* Z(:)) / meanA;
X1=X-centerOfMassX;
Y1=Y-centerOfMassY;
Z1=Z-centerOfMassZ;


Q = inv(W);
aa=[X1(maskLattice_3D==1),Y1(maskLattice_3D==1),Z1(maskLattice_3D==1)];
bbb=Q*aa'+centerOfMass1';
figure
scatter3(bbb(1,:),bbb(2,:),bbb(3,:))


%%%%%%%%%%%% generate_sphere

PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;  % mm

rVertex = bbb(1,:);
cVertex = bbb(2,:);
zVertex = bbb(3,:);

% Aggiungo sfera dal diametro raggio r, per ogni vertice
[xx, yy, zz] = meshgrid(1:xDim, 1:yDim, 1:zDim);
xx=double(xx); yy=double(yy); zz=double(zz);
xx = xx.*PixelSpacing;
yy = yy.*PixelSpacing;
zz = (zDim+1-zz).*slicegap; 
rVertex = rVertex*PixelSpacing;
cVertex = cVertex*PixelSpacing;
% zVertex = (zDim+1-zVertex)*slicegap;
zVertex = (zVertex-zDim+1)*slicegap; % MODIFICATO Z PERCHE' NEGATIVI
% nVertices = length(lattice1D);   % numero vertici della Lattice entro il PTV
nVertices = length(rVertex);
maskSphere_cell = cell(xDim,yDim,zDim, nVertices);
for i = 1:nVertices
    maskSphere_cell{i} = ((xx - cVertex(i)).^2 + (yy - rVertex(i)).^2 + (zz - zVertex(i)).^2) <= radius^2;
end



%%%%%%%%%%%% exportDicom

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
figure('Name','PTV and Lattice structure');
plotContour(contourOut, [nPTV number]) % Visualizza la struttura
grid on


