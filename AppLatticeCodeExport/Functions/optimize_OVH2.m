function [indOpt, integ_ovh, ovhf]  = optimize_OVH2(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, vq, strList)

% In questa funzione gli do le varie strutture lattice (ind) e
% la listOAR e lui mi calcola OVH delle verie lattice con gli listOAR.
% Trova così la struttura che minimizza OVH
xDim=double(CTinfo.Width); yDim=double(CTinfo.Height);
fprintf("\n Calculating OVH to find the optimal lattice structure\n\n");
PixelSpacing=CTinfo.PixelSpacing(1);  % mm
slicegap = CTinfo.SliceThickness;
b = 10; % dimensione cuboide per la dilatazione

oar3d{1,length(nOAR)} = []; % cell con tutte gli OAR selezionati in GUI
for i = 1 : length(nOAR)
    [~, oar3DTemp] = RSdicom2mask_VT(path{1,1},nOAR(i),path{1,2});
    oar3d{i} = oar3DTemp;
end

integ_ovh = zeros(length(ind),length(nOAR)); % ha OVH delle varie lattice sulle righe e per ogni OAR sulle colonne
ovhf = cell(length(ind),length(nOAR));
for i = 1 : length(ind)
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
    lattice3D = maskReticoloTrasl_3D.*vq;   % Reticolo traslato interno al PTV
    sphere3D = generate_spheres(CTinfo, zDim, radius, lattice3D);
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
end
%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%
        

clearvars -except indOpt integ_ovh ovhf
end