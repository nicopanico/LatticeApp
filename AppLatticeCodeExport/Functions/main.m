%% Input parameters

% Modicia automatica GTV (shrink R)
% optimize_OVH riga 27, min della somma degli OVH degli OAR?
% NO ROTATION: main riga 18; optimize_OVH riga 21
tic
PatientID = '1080-18';
radius = 5.0;                            % mm, raggio sfere (Duriseti 7.5)
xd=radius*8; yd=radius*8; zd = radius*8; % mm, distanza tra sfere (articolo 6 cm con sfere da 0.75 cm di raggio)
dVertex = [xd yd zd];

[path, CTinfo, zDim, strList] = extract_data(PatientID);
GUIselectPTV('init', strList); % close window -> gives nPTV
%%
%uiwait;

%%
[maskPTV_1D, maskPTV_3D] = RSdicom2mask_VT(path{1,1},nPTV, path{1,2}); %CTpath,indexSTR, STRpath
%%

[W, centerOfMass, XYZ2, vq] = findOptimalRotation(CTinfo, zDim, maskPTV_3D);
[Vrot,teta]=Axis_Angle(W); %trova asse e angolo di rotazione
norot=maskPTV_3D~=0;
norot=Isotropic_mesh(CTinfo,zDim, norot);
vq=imrotate3(norot,teta,Vrot',"nearest","crop");
dim_vq=size(vq);
vq = maskPTV_3D;
[reticolo3D, distV_px] = generate_lattice_iso(CTinfo, dim_vq(3), dVertex);
[vertices, to_evaluate] = findMaximum(CTinfo, dim_vq(3), distV_px, vq, reticolo3D);
% [vertices, to_evaluate] = findMaximum_gpu(CTinfo, zDim, distV_px, maskPTV_1D, maskReticolo_3D);  
ind = printResults(to_evaluate);
GUIselectOAR('init', strList);
uiwait;
% indOpt = optimize_OVH(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, W, vq, centerOfMass);
[indOpt, integ_ovh, ovhf] = optimize_OVH3(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, vq, strList);
% lattice3D = reverseRotation(CTinfo, zDim, W, vertices, to_evaluate, indOpt, vq, centerOfMass);
lattice3D = indOptLattice(CTinfo, zDim, vertices, to_evaluate, vq, indOpt);
[maskSphere_cell, nVertices] = generate_spheres2(CTinfo, zDim, radius, lattice3D);
[contourOut, infoOut, number] = exportDicom(PatientID, CTinfo, zDim, path, maskSphere_cell, nVertices);
toc

figure('Name','PTV and Lattice structure');
plotContour(contourOut, [nPTV number]) % Visualizza la struttura
grid on
