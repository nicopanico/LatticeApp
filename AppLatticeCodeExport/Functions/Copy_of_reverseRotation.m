function lattice2 = reverseRotation(CTinfo, zDim, W, vertices, to_evaluate, ind, vq, centerOfMass1)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Parametri
xDim=double(CTinfo.Width); yDim=double(CTinfo.Height); zDim = double(zDim);
% xsp=CTinfo.PixelSpacing(1);  % mm
% ysp = xsp;
% zsp = CTinfo.SliceThickness;  % mm
righe=vertices(:,1); colonne=vertices(:,2); zeta=vertices(:,3); % Reticolo originale (non traslato)
trasl = to_evaluate(ind, 2:4);  % Prendo la traslazione ind

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
meanA = mean(maskLattice_3D(:));
centerOfMassX = mean(maskLattice_3D(:) .* X(:)) / meanA;
centerOfMassY = mean(maskLattice_3D(:) .* Y(:)) / meanA;
centerOfMassZ = mean(maskLattice_3D(:) .* Z(:)) / meanA;
X1=X-centerOfMassX;
Y1=Y-centerOfMassY;
Z1=Z-centerOfMassZ;

% Rotazione inversa per tornare al riferimento iniziale
kk=[X1(:) Y1(:) Z1(:)];
Q = inv(W);
XYZ2=(Q*kk')';
X2=reshape(XYZ2(:,1),size(X1));
Y2=reshape(XYZ2(:,2),size(X1));
Z2=reshape(XYZ2(:,3),size(X1));

% Traslazione inversa per tornare al riferimento iniziale
X3=X2+centerOfMass1(1);
Y3=Y2+centerOfMass1(2);
Z3=Z2+centerOfMass1(3);

% Lattice ruotato
lattice = interp3(X,Y,Z,maskLattice_3D,X3,Y3,Z3,'nearest'); % Lattice ruotato
lattice(isnan(lattice))=0;
% scatter3(X(lattice(:)==1),Y((lattice(:)==1)),Z((lattice(:)==1)))
lattice = logical(lattice);

% >>>>>>>PROBLEMA CODICE
scatter3(X(maskLattice_3D(:)==1),Y((maskLattice_3D(:)==1)),Z((maskLattice_3D(:)==1)))
scatter3(X(lattice(:)==1),Y((lattice(:)==1)),Z((lattice(:)==1)))

% Elimino elementi adiacenti
Dim = [xDim yDim zDim];
lattice_1D = find(lattice);
[x, y, z]=ind2sub(Dim,lattice_1D);
xnew=x; ynew=y; znew=z;
for i = 1 : length(x)
    is = (xnew-xnew(i)).^2+(ynew-ynew(i)).^2+(znew-znew(i)).^2 <= 1;
    if sum(is~=0)>1
    xnew(i) = NaN;
    ynew(i) = NaN;
    znew(i) = NaN;
    end
end
xnew(isnan(xnew)) = [];
ynew(isnan(ynew)) = [];
znew(isnan(znew)) = [];
lattice2 = false(xDim,yDim,zDim);
idx = sub2ind(size(lattice2), xnew, ynew,znew);
lattice2(idx) = 1;
lattice2 = logical(lattice2);

clearvars -except lattice2

