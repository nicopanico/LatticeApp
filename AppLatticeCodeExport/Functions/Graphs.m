% Graphs

% Legenda:
% 1D: gli indici
% 3D: le coordinate (x,y,z)
% mask: 0/1
% maskReticolo: il reticolo originale
% maskReticoloTrasl: il reticolo traslato
% maskLattice: il reticolo traslato convoluzione in PTV
% maskSphere: sfere aggiunte in ogni vertice di maskLattice

%%
figure('Name','Reticolo originale');
sliceViewer(maskReticolo_3D);
figure('Name','Reticolo traslato');
sliceViewer(maskReticoloTrasl_3D);
figure('Name','PTV');
sliceViewer(maskPTV_3D);
figure('Name','Mask in PVT');
sliceViewer(maskLattice_3D);
figure('Name','PTV and Lattice structure');
plotContour(contourOut, [nPTV number]) % Visualizza la struttura

%% Rotation
xDim=double(CTinfo.Width); yDim=double(CTinfo.Height);
figure('Name','Mask PTV')
[x, y, z]=ind2sub([xDim yDim zDim],maskPTV_1D);
scatter3(x,y,z)
xlabel('x')
ylabel('y')
zlabel('z')
alpha(.1)
grid on

xDim=double(CTinfo.Width); yDim=double(CTinfo.Height);
figure('Name','PTV')
[x, y, z]=ind2sub([xDim yDim zDim],maskPTV_1D);
k = boundary(x,y,z);
trisurf(k,x,y,z,'Facecolor','red','FaceAlpha',0.1)
% trimesh(k2,x2,y2,z2)
xlabel('x')
ylabel('y')
zlabel('z')
grid on

