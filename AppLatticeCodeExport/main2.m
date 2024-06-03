function launch_Ryan(PatientID, radius, spacing, case_name)


addpath("Functions"); %initialize all the functions 
%% Input parameters
% Modicia automatica GTV (shrink R)
% optimize_OVH riga 27, min della somma degli OVH degli OAR?
% NO ROTATION: main riga 18; optimize_OVH riga 21
tic
% PatientID = '767-23';
% radius = 5.0;                            % mm, raggio sfere (Duriseti 7.5)
% xd=radius*8; yd=radius*8; zd = radius*8; % mm, distanza tra sfere (articolo 6 cm con sfere da 0.75 cm di raggio)
xd=spacing; yd = spacing; zd = spacing; % mm, distanza tra sfere (articolo 6 cm con sfere da 0.75 cm di raggio)
dVertex = [xd yd zd];
% case_name = '5mm_incr_cov'; %name of the case to save final Dicom (will be displayed at the beginning)
to_save = strcat(pwd,"\Immagini\",PatientID,"\Results\"); %define the folder where the results will be saved

sprintf("Lattice optimization for Patient %s", PatientID)

[path, CTinfo, zDim, strList] = extract_data(PatientID);
GUIselectPTV('init', strList); % close window -> gives nPTV
%%
%uiwait;

%%
%[maskPTV_1D, maskPTV_3D] = RSdicom2mask_VT(path{1,1},nPTV, path{1,2}); %CTpath,indexSTR, STRpath
maskPTV_3D = get_3D_mask(path{1,1}, path{1,2}, nPTV); %CTpath,indexSTR, STRpath

%%

[W, centerOfMass, XYZ2, vq] = findOptimalRotation(CTinfo, zDim, maskPTV_3D);
[Vrot,teta]=Axis_Angle(W); %trova asse e angolo di rotazione
norot=maskPTV_3D~=0;
norot=Isotropic_mesh(CTinfo,zDim, norot);
vq=imrotate3(norot,teta,Vrot',"nearest","crop");
dim_vq=size(vq);
%vq = maskPTV_3D;
[reticolo3D, distV_px] = generate_lattice_iso(CTinfo, dim_vq(3), dVertex);
% modifica per distanza di Hausdorff
%[vertices, to_evaluate,to_evaluateH] = findMaximum2(CTinfo, dim_vq(3), distV_px, vq, reticolo3D);
[vertices, to_evaluate] = findMaximum(CTinfo, dim_vq(3), distV_px, vq, reticolo3D);
% [vertices, to_evaluate] = findMaximum_gpu(CTinfo, zDim, distV_px, maskPTV_1D, maskReticolo_3D);  
ind = printResults(to_evaluate, 'target');

%%
%selecting the better dispositions for target covering
incr = 5; % (mm) provisional increment to be discussed with @Andrea- @Nicola

best_ones = check_TCS(ind, to_evaluate, vq, vertices, zDim, maskPTV_3D, CTinfo, radius, teta, Vrot, incr);

%find the best lattice indeces based on target coverage
best_idx = best_ones{:, 5};
ind = intersect(ind, best_idx);

%select OAR for the OVH estimation 
GUIselectOAR('init', strList);
uiwait;
%%
% indOpt = optimize_OVH(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, W, vq, centerOfMass);
[indOpt, integ_ovh, ovhf] = optimize_OVH4(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, vq, strList,teta,Vrot, PatientID, to_save);
fileName = sprintf('%s%s%s', PatientID, '_', 'OVH Data');
save(strcat(to_save,fileName), 'integ_ovh', 'ovhf');
% lattice3D = reverseRotation(CTinfo, zDim, W, vertices, to_evaluate, indOpt, vq, centerOfMass);
%lattice3D = indOptLattice(CTinfo, zDim, vertices, to_evaluate, vq, indOpt);
% [maskSphere_cell, nVertices] = generate_spheres2(CTinfo, zDim, radius, lattice3D);
maskSphere_cell = VertexMask(CTinfo, zDim, teta, Vrot, vertices, to_evaluate, radius, vq, indOpt);
%%
path0 = fullfile(pwd,'Immagini', PatientID,'\');
[contourOut, infoOut, number] = exportDicom2(PatientID, CTinfo, zDim, path0, path, maskSphere_cell, case_name);
toc

figure('Name','PTV and Lattice structure');
plotContour(contourOut, [nPTV number]) % Visualizza la struttura
grid on

figName = sprintf('%s%s%s', PatientID, '_', 'contourOut', '_', 'best.png');
saveas(gcf, strcat(to_save,figName));
end