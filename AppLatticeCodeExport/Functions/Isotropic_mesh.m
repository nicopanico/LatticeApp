function vq = Isotropic_mesh(CTinfo,zDim, norot)


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
z1=0:xsp:(zDim-1)*zsp;
[X1,Y1,Z1]=meshgrid(x,y,z1);
vq = interp3(X,Y,Z,norot,X1,Y1,Z1,'nearest');
clearvars -except vq
end