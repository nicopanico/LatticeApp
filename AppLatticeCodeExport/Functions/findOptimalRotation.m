function [W, centerOfMass, XYZ2, vq] = findOptimalRotation(CTinfo,zDim, maskPTV_3D)
% TRASLA E RUOTA IL PTV IN MODO DA CENTRARLO NELL'ORIGINE E RUOTARLO PER
% AVERE L'ASSE PRINCIPALE SU UNO DEGLI ASSI DEL SISTEMA DI RIFERIMENTO
%   Utilizza le coordinate mesh (matrici con coordinate x,y,z per ogni
%   voxel), ottiene nuove coordinate (X1,Y1,Z1) in modo da avere baricentro
%   nell'origine, trova la matrice di trasformazione W (data dagli
%   autovettori, che permette di ruotare il sistema con l'asse principale
%   su uno degli assi), applica tale rotazione ottenendo le coordinate
%   (X2,Y2,Z2). Calcola il PTV nelle nuove coordinate (vq).

% Parametri
xDim=double(CTinfo.Width); yDim=double(CTinfo.Height);
xsp=CTinfo.PixelSpacing(1);  % mm
ysp=xsp; % mm
zsp = CTinfo.SliceThickness;  % mm

% Crea meshgrid in coordinate CT
x=0:xsp:(xDim-1)*xsp;
y=0:ysp:(yDim-1)*ysp;
z=0:zsp:(zDim-1)*zsp;
[X,Y,Z]=meshgrid(x,y,z);

% Sposta origine nel baricentro
meanA = mean(maskPTV_3D(:));
centerOfMassX = mean(maskPTV_3D(:) .* X(:)) / meanA;
centerOfMassY = mean(maskPTV_3D(:) .* Y(:)) / meanA;
centerOfMassZ = mean(maskPTV_3D(:) .* Z(:)) / meanA;
centerOfMass = [centerOfMassX centerOfMassY centerOfMassZ];
X1=X-centerOfMassX;
Y1=Y-centerOfMassY;
Z1=Z-centerOfMassZ;

% Trovo autovettori e matrice di trasformazione W
cXY=cov(X1(maskPTV_3D==1),Y1(maskPTV_3D==1));
cXX=cov(X1(maskPTV_3D==1),X1(maskPTV_3D==1));
cYY=cov(Y1(maskPTV_3D==1),Y1(maskPTV_3D==1));
cZZ=cov(Z1(maskPTV_3D==1),Z1(maskPTV_3D==1));
cXZ=cov(X1(maskPTV_3D==1),Z1(maskPTV_3D==1));
cYZ=cov(Y1(maskPTV_3D==1),Z1(maskPTV_3D==1));
CM=[cXX(1,1),cXY(1,2),cXZ(1,2);cXY(2,1),cYY(1,1),cYZ(1,2);...
    cXZ(2,1),cYZ(2,1),cZZ(1,1)];
[~,~,W] = eig(CM);
clear cXY cXX cYY cZZ cXZ cYZ CM

% Trasformo le coordinate tramite la matrice W
kk=[X1(:) Y1(:) Z1(:)];
kk2=(W*kk')';
X2=reshape(kk2(:,1),size(X));
Y2=reshape(kk2(:,2),size(X));
Z2=reshape(kk2(:,3),size(X));
vq = interp3(X1,Y1,Z1,maskPTV_3D,X2,Y2,Z2,'nearest'); % PTV ruotato
vq(isnan(vq))=0;
% vq = logical(vq);

XYZ2{1} = X2;
XYZ2{2} = Y2;
XYZ2{3} = Z2;

% ----- Graphs ------
% [V,D,W] = eig(CM);
% v1 = 35*V(:,1);
% figure('Name','Original PTV')
% Dim = [xDim yDim zDim];
% maskPTV_1D = find(maskPTV_3D);
% [x, y, z]=ind2sub(Dim,maskPTV_1D);
% % plot3(x,y,z)
% k = boundary(x,y,z);
% trisurf(k,x,y,z,'Facecolor','red','FaceAlpha',0.1)
% % trimesh(k,x,y,z)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% grid on
% hold on
% plot3([-v1(1)+centerOfMassY v1(1)+centerOfMassY],[-v1(2)+centerOfMassX v1(2)+centerOfMassX], [-v1(3)+75 v1(3)+75],'r','linewidth',3)
% 
% v2 = W*v1;
% figure('Name','Rotated PTV')
% vq1D = find(vq);
% [x2, y2, z2]=ind2sub(Dim,vq1D); % 
% % plot3(x2,y2,z2)
% k2 = boundary(x2,y2,z2);
% trisurf(k2,x2,y2,z2,'Facecolor','red','FaceAlpha',0.1)
% % trimesh(k2,x2,y2,z2)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% grid on
% hold on
% plot3([-v2(1)+centerOfMassY v2(1)+centerOfMassY],[-v2(2)+centerOfMassX v2(2)+centerOfMassX], [-v2(3)+75 v2(3)+75],'r','linewidth',3)

% Plotto maschera non ruotata nel riferimento non ruotato
% figure('Name','Original PTV')
% scatter3(X(maskPTV_3D(:)==1),Y((maskPTV_3D(:)==1)),Z((maskPTV_3D(:)==1)))
% xlabel('x')
% ylabel('y')
% zlabel('z')
% grid on

% Plotto maschera ruotata nel riferimento non ruotato
% figure('Name','Rotated PTV')
% scatter3(X(vq(:)==1),Y((vq(:)==1)),Z((vq(:)==1)))
% xlabel('x')
% ylabel('y')
% zlabel('z')
% grid on
% Uguale a maschera originale nel riferimento ruotato
% plot3(X2(maskPTV_3D(:)==1),Y2((maskPTV_3D(:)==1)),Z2((maskPTV_3D(:)==1)))
% ----- Graphs ------
clearvars -except W centerOfMass XYZ2 vq
end