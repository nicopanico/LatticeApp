function [vertices, to_evaluate, to_evaluateH] = findMaximum2(CTinfo, zDim, distVertex_px, maskPTV_3D, reticolo3D)

% Prende il Reticolo (maskReticolo_3D) e il PTV (maskPTV_1D), e fa
% traslazioni del Reticolo a passo di 2 pixel fino a metà della distanza
% tra i vertici (oltre è ridondante), calcolando il numero di vertici entro
% PTV.
% Restituisce in 'to_evaluate' il numero di vertici e le coordinate della
% traslazione. In 'vertices' salva le righe,colonne,zeta del reticolo
% originale (non traslato).

xDim=CTinfo.Width; yDim=CTinfo.Height;
step_x=distVertex_px(1); step_y=distVertex_px(2); step_z=distVertex_px(3); 
step_x2=ceil(step_x/2); step_y2=ceil(step_y/2); step_z2=ceil(step_z/2);

fprintf("\nTranslations to maximize the number of vertices within the PTV\n")
reticolo1D=find(reticolo3D);
[righe, colonne, zeta]=ind2sub([xDim yDim zDim],reticolo1D);
cont=1;
to_evaluate=zeros(round(step_z2/2)*round(step_x2/2)*round(step_y2/2),4);
% modificato da 2 a 3 il passo dei cicli for (andrea)
vq=maskPTV_3D>0;
b_vq=bwperim(vq);
for z=1:2:step_z2
    for i=1:2:step_x2
        for j=1:2:step_y2
            newreticolo=false(xDim,yDim,zDim);
            righe1=righe+(i-1);
            colonne1=colonne+(j-1);
            zeta1=zeta+(z-1);
            righe1(righe1>xDim)=xDim;
            colonne1(colonne1>yDim)=yDim;
            zeta1(zeta1>zDim)=zDim;
            punti1=sub2ind([xDim yDim zDim],righe1,colonne1,zeta1);
            newreticolo(punti1)=1;
            %to_evaluate(cont,1)=numel(find(newreticolo.*maskPTV_3D));
            ret_overlap=newreticolo.*maskPTV_3D==1;
            to_evaluate(cont,1)=sum(ret_overlap,'all');%modifica andrea per velocizzare di un fattore >2
            to_evaluate(cont,2)=i;
            to_evaluate(cont,3)=j;
            to_evaluate(cont,4)=z;
            to_evaluateH(cont)=hausdorff(ret_overlap,b_vq);
            cont=cont+1;
        end
    end
end
vertices = [righe, colonne, zeta];
end

