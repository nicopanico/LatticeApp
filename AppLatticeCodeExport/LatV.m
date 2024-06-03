% function launch_LRTopt(PatientID, radius, spacing, case_name)


tic
addpath("Functions"); %initialize all the functions 

%% Input parameters
% Modicia automatica GTV (shrink R)
% optimize_OVH riga 27, min della somma degli OVH degli OAR?
% NO ROTATION: main riga 18; optimize_OVH riga 21

PatientID = '592-06';                     % Patient name
radius = 3;                               % mm, raggio sfere (Duriseti 7.5)
xd=radius*8; yd=radius*8; zd = radius*8;  % mm, distanza tra sfere (articolo 6 cm con sfere da 0.75 cm di raggio)
dVertex = [xd yd zd];                     % vertex distance
check_target = 0;                         % option to perform target coverage check (1 = yes, 0 = no)
mode = 'max';                             % 'target' for target coverage or 'max' for standard method

% Define names and save options
case_name = 'Radius_3mm_noTarget';                               % name of the case to save final Dicom (will be displayed at the beginning)
to_save = strcat(pwd,"\Immagini\",PatientID,"\Results\"); % define the folder where the results will be saved

%% START OF THE SCRIPT
fprintf('Lattice optimization for Patient %s', PatientID);

[path, CTinfo, zDim, strList, infoIn, RoiCont] = extract_data(PatientID);
GUIselectPTV('init', strList); % close window -> gives nPTV
GUIselectOAR('init', strList); % Select also the OARs critical for the patient
uiwait;
%%
%uiwait;
%%
% part added by Andrea to define the
% correct OAR and GTV (18-10-23)
nOAR=RoiCont.ROIs.Number(nOAR);
nPTV = RoiCont.ROIs.Number(nPTV);

% Create the provisional expansione and crop of GTV and OARs selected
crop_mask = cropGTV(path, nPTV, radius);
expand_mask = dilate_OAR(path, nOAR, 10); % The margin for OARs is constant and set at 10mm 

% The output infoOut is unused in the script but it is usefull to check at
% the end of the script for mistakes or error or just a controll variable

[contourOut, maskPTV_3D, infoOut, number] = GTVmask(crop_mask, expand_mask, CTinfo, zDim, RoiCont, strcat("Mask",case_name), [255, 0, 100]);

%%
%[maskPTV_1D, maskPTV_3D] = RSdicom2mask_VT(path{1,1},nPTV, path{1,2}); %CTpath,indexSTR, STRpath
% maskPTV_3D = get_3D_mask(path{1,1}, path{1,2}, nPTV); %CTpath,indexSTR, STRpath

%% Rotation and traslation optimization

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
ind = printResults(to_evaluate, mode);

%% Target coverage check (if necessary or wanted)

if check_target == 1;
    %selecting the better dispositions for target covering
    incr = 5; % (mm) provisional increment to be discussed with @Andrea- @Nicola
    % gives best ones table but al the final containing all the cases not
    % just the best 5, for further checkings at the end! @Nicola 25-08-23
    [best_ones, final] = check_TCS(ind, to_evaluate, vq, vertices, zDim, maskPTV_3D, CTinfo, radius, teta, Vrot, incr);

    best_ones   = select_best_ones(best_ones, length(final), 'min_incr', 1:size(best_ones,1), 2);

    %find the best lattice indeces based on target coverage
    best_idx = best_ones{:, 5};
    ind = intersect(ind, best_idx);
end
%select OAR for the OVH estimation 

%% OVH optimization, minimizing the OVH curve Area

% indOpt = optimize_OVH(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, W, vq, centerOfMass);
[indOpt, integ_ovh, ovhf] = optimize_OVH4(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, vq, strList,teta,Vrot, PatientID, to_save, case_name);
fileName = sprintf('%s%s%s', PatientID, '_',case_name,'_', 'OVH Data');
save(strcat(to_save,fileName), 'integ_ovh', 'ovhf');
% lattice3D = reverseRotation(CTinfo, zDim, W, vertices, to_evaluate, indOpt, vq, centerOfMass);
%lattice3D = indOptLattice(CTinfo, zDim, vertices, to_evaluate, vq, indOpt);
% [maskSphere_cell, nVertices] = generate_spheres2(CTinfo, zDim, radius, lattice3D);
maskSphere_cell = VertexMask(CTinfo, zDim, teta, Vrot, vertices, to_evaluate, radius, vq, indOpt);

%% DicomWrite and export and final Results

path0 = fullfile(pwd,'Immagini', PatientID,'\');
[LatticeXYZ] = Mask2Contour(CTinfo, zDim, maskSphere_cell);
[contourOut, infoOut, number] = addROI(contourOut, LatticeXYZ, 'LatticeMatlab',[0, 255, 100]);

% Save the Dicom with the lattice structure and the new Mask
nameSTR = strcat(path0,'STR_Lattice_', PatientID, '_', case_name, '.dcm');
dicomwrite([],nameSTR,infoOut,"CreateMode","copy");

% [contourOut, infoOut, number] = exportDicom2(PatientID, CTinfo, zDim, path0, path, maskSphere_cell, case_name);
toc

figure('Name','PTV and Lattice structure');
plotContour(contourOut, [nPTV number]) % Visualizza la struttura
grid on

figName = sprintf('%s%s%s', PatientID, '_', 'contourOut', '_',case_name,'_','best.png');
figName_2 = sprintf('%s%s%s', PatientID, '_', 'contourOut', '_',case_name,'_','best.fig');%Also save the .fig for matlab
saveas(gcf, strcat(to_save,figName));
saveas(gcf, strcat(to_save,figName_2))
% end