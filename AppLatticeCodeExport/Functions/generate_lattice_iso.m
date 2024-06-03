function [reticolo3D, distVertex_px] = generate_lattice_iso(CTinfo, zDim, distVertex)

% Crea un reticolo (maskReticolo_3D) con distanza dei vertici pari a
% distVertex (mm), restituisce anche la distanza dei vertici
% (distVertex_px) in unità di pixel
% 
% Typical CT: 512x512xSlice   PixelSpacing=0.9766 mm; slicegap=3 mm

xDim=CTinfo.Width; yDim=CTinfo.Height;
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;
%dist_z = round(distVertex(3)/slicegap);% Distanza vertici in numero pixel (distVertex in mm)
dist_x = round(distVertex(1)/PixelSpacing);
dist_y = round(distVertex(2)/PixelSpacing);
dist_z = round(distVertex(3)/PixelSpacing);

reticolo1=false(xDim,yDim,zDim);
reticolo2=false(xDim,yDim,zDim);
for z=1:dist_z:zDim 
    for i=1:dist_x:xDim 
        for j=1:dist_y:yDim
            reticolo1(i,j,z)=1;
        end
    end
    for i=round(dist_x/2):dist_x:xDim 
        for j=round(dist_y/2):dist_y:yDim
            reticolo2(i,j,z)=1;
        end
    end
end
reticolo_p=reticolo1+reticolo2;

reticolo1=false(xDim,yDim,zDim);
reticolo2=false(xDim,yDim,zDim);
for z=round(dist_z/2):dist_z:zDim 
    for i=round(dist_x/2):dist_x:xDim 
        for j=1:dist_y:yDim
            reticolo2(i,j,z)=1;
        end
    end
    for i=1:dist_x:xDim 
        for j=round(dist_y/2):dist_y:yDim
            reticolo1(i,j,z)=1;
        end
    end
end
reticolo_p1=reticolo1+reticolo2;

reticolo3D=reticolo_p+reticolo_p1;
reticolo3D = logical(reticolo3D);
distVertex_px = [dist_x dist_y dist_z];

end

