function [indOpt, integ_ovh, ovhf]  = optimize_OVH3(path, CTinfo, zDim0, nOAR, ind, to_evaluate, vertices, radius, vq, strList,teta,Vrot, PatientID)

% In questa funzione gli do le varie strutture lattice (ind) e
% la listOAR e lui mi calcola OVH delle verie lattice con gli listOAR.
% Trova così la struttura che minimizza OVH

[xDim,yDim,zDim]=size(vq);
%xDim=double(CTinfo.Width); yDim=double(CTinfo.Height);
fprintf("\n Calculating OVH to find the optimal lattice structure\n\n");
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;
b = 10; % dimensione cuboide per la dilatazione

oar3d{1,length(nOAR)} = []; % cell con tutte gli OAR selezionati in GUI
for i = 1 : length(nOAR)
    [~, oar3DTemp] = RSdicom2mask_VT(path{1,1},nOAR(i),path{1,2});
    oar3d{i} = oar3DTemp;
end

formatspec= '\n Calculating OVH - step %4.0f di %4.0f \n\n';
integ_ovh = zeros(length(ind),length(nOAR)); % ha OVH delle varie lattice sulle righe e per ogni OAR sulle colonne
ovhf = cell(length(ind),length(nOAR));
for i = 1 : length(ind)
    fprintf(formatspec, i, length(ind));
%     lattice3D = reverseRotation(CTinfo, zDim, W, vertices, to_evaluate, ind(i), vq, centerOfMass);
    righe=vertices(:,1); colonne=vertices(:,2); zeta=vertices(:,3);
    trasl = to_evaluate(ind(i), 2:4);
    maskReticoloTrasl_3D = false(xDim,yDim,zDim);
    r=righe+(trasl(1)-1);
    c=colonne+(trasl(2)-1);
    z=zeta+(trasl(3)-1);
    r(r>xDim)=xDim;
    c(c>yDim)=yDim;
    z(z>zDim)=zDim;
    maskReticoloTrasl_1D=sub2ind([xDim yDim zDim],r,c,z);
    maskReticoloTrasl_3D(maskReticoloTrasl_1D)=1;        % Reticolo traslato
    maskReticoloTrasl_3D=maskReticoloTrasl_3D==1;
    lattice3D = (maskReticoloTrasl_3D.*vq)==1;   % Reticolo traslato interno al PTV
    sphere3D = generate_spheres_iso(CTinfo, zDim, radius, lattice3D);
    
    sphere3D=imrotate3(sphere3D,-teta,Vrot',"nearest","crop"); %controruota il lattice
    
    %ridemensionamento della matrice
    %r=zDim/size(vq,3);
    tform = affine3d([1 0 0 0; 0 1 0 0; 0 0 zDim0/size(vq,3) 0; 0 0 0 1]);
    sphere3D=imwarp(sphere3D,tform,'interp','nearest');
    
%     [X1,Y1,Z1]=meshgrid(0:PixelSpacing:(xDim-1)*PixelSpacing,...
%         0:PixelSpacing:(yDim-1)*PixelSpacing,...
%         0:slicegap:(zDim0-1)*slicegap);
%     [X,Y,Z]=meshgrid(0:PixelSpacing:(xDim-1)*PixelSpacing,...
%         0:PixelSpacing:(yDim-1)*PixelSpacing,...
%         0:PixelSpacing:(zDim0-1)*slicegap);
    %%%
%     lattice3D = interp3(X,Y,Z,lattice3D,X1,Y1,Z1,'nearest');
    
%    sphere3D = generate_spheres_iso(CTinfo, zDim, radius, lattice3D);
    for j = 1 : length(nOAR)
        oar = oar3d{1,j};
        [integ_ovh(i, j), ovhcurve] = OVH_f(sphere3D, oar, b, PixelSpacing, slicegap );
        ovhf{i,j} = ovhcurve;
    end
end
[~, indOVH] = max(sum(integ_ovh,2)); % prendo la configurazione (i) che ha la somma degli OVH sugli OAR minima
indOpt = ind(indOVH);

%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%% tutti insieme
for i = 1 : length(ind)
    for j = 1 : length(nOAR)
        if (i==1 && j==1)
          figure('Name','OVH curves');
          txt = ['L=',num2str(i), ' OAR=', num2str(j)];
          ovhc = ovhf{i,j};
          plot(ovhc(:,1), ovhc(:,2),'DisplayName', txt);
          grid on
          xlabel('Distance (mm)')
          ylabel('OVH')
        end
        ovhc = ovhf{i,j};
        txt = ['L=',num2str(i), ' OAR=', num2str(j)];
        hold on
        plot(ovhc(:,1), ovhc(:,2),'DisplayName', txt);
    end
end
FigName = sprintf('%s%s%s',PatientID, '_', 'OVH.png');
saveas(gcf, FigName)
%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%% grafico per ogni OAR
for j = 1 : length(nOAR)
    figure('Name','OVH curves')
    for i = 1 : length(ind)
        if i==1
          txt = ['L=',num2str(i)];
          ovhc = ovhf{i,j};
          plot(ovhc(:,1), ovhc(:,2),'DisplayName', txt);
          grid on
          xlabel('Distance (mm)')
          ylabel('OVH')
        end
        txt = ['L=',num2str(i)];
        ovhc = ovhf{i,j};
        hold on
        plot(ovhc(:,1), ovhc(:,2),'DisplayName', txt);
    end
    txtOAR = strList{nOAR(j)};
    title(txtOAR);
    FigName = sprintf('%s%s%s%s%s',PatientID, '_', 'OVH_',txtOAR, '.png');
    saveas(gcf, FigName)
end
%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%
        

clearvars -except indOpt integ_ovh ovhf
end