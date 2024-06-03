function [vertices, gto_evaluate] = findMaximum_gpu(CTinfo, zDim ,distVertex_px, maskPTV_1D, maskReticolo_3D)

xDim=CTinfo.Width; yDim=CTinfo.Height;
step_x=distVertex_px(1); step_y=distVertex_px(2); step_z=distVertex_px(3); 
step_x2=round(step_x/2); step_y2=round(step_y/2); step_z2=round(step_z/2);

fprintf("\nTranslations to maximize the number of vertices within the PTV\n")
maskPTV_3D=zeros([xDim,yDim,zDim]);
maskPTV_3D(maskPTV_1D)=1;
maskPTV_3D=logical(maskPTV_3D);
maskReticolo_1D=find(maskReticolo_3D);
[righe, colonne, zeta]=ind2sub([xDim yDim zDim],maskReticolo_1D);
iv=1;
d = zeros(round(step_z2/2)*round(step_x2/2)*round(step_y2/2),4);
for z=1:2:step_z2 
    for i=1:2:step_x2
        for j=1:2:step_y2
            d(iv,1:3)=[i,j,z];
            iv=iv+1;
        end
    end
end
gd=gpuArray(d);
to_evaluate=zeros(iv,4);
gto_evaluate=gpuArray(to_evaluate);
parfor ii=1:iv
            newreticolo=false(xDim,yDim,zDim);
            righe1=righe+gd(ii,1)-1;
            colonne1=colonne+gd(ii,2)-1;
            zeta1=zeta+gd(ii,3)-1;
            righe1(righe1>xDim)=xDim;
            colonne1(colonne1>yDim)=yDim;
            zeta1(zeta1>zDim)=zDim;
            punti1=sub2ind([xDim yDim zDim],righe1,colonne1,zeta1);
            newreticolo(punti1)=1;
            gto_evaluate(ii,:)=[numel(find(newreticolo.*maskPTV_3D)),gd(ii,1:3)];
end
vertices = [righe, colonne, zeta];
end

