function indOpt = optimize_OVH(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, W, vq, centerOfMass)

% In questa funzione gli do le varie strutture lattice (ind) e
% la listOAR e lui mi calcola OVH delle verie lattice con gli listOAR.
% Trova così la struttura che minimizza OVH

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
for i = 1 : length(ind)
%     lattice3D = reverseRotation(CTinfo, zDim, W, vertices, to_evaluate, ind(i), vq, centerOfMass);
    lattice3D = vq;
    sphere3D = generate_spheres(CTinfo, zDim, radius, lattice3D);
    for j = 1 : length(nOAR)
        oar = oar3d{1,j};
        integ_ovh(i, j) = OVH_f(sphere3D, oar, b, PixelSpacing, slicegap );
    end
end
[~, indOVH] = min(sum(integ_ovh,2)); % prendo la configurazione (i) che ha la somma degli OVH sugli OAR minima
indOpt = ind(indOVH);

clearvars -except indOpt
end