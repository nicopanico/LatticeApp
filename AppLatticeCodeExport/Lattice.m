function Lattice(PatPath, SavePath, app)
tic
addpath("Functions"); %initialize all the functions 

%% Input parameters
% Modicia automatica GTV (shrink R)
% optimize_OVH riga 27, min della somma degli OVH degli OAR?
% NO ROTATION: main riga 18; optimize_OVH riga 21

answer = give_input;
[PatientID, radius, dVertex, check_target, mode, case_name, how] = extract_input(answer);

to_save = SavePath; %New addition to be free to save the results in the Folder that you prefer....
                    %Implementation for the Application @Nicola 01/04/24
% to_save = strcat(pwd,"\Immagini\",PatientID,"\Results\"); % define the folder where the results will be saved
% check if the Results folder exists 
if ~exist("to_save", 'dir')
       mkdir(to_save)
end


%% START OF THE SCRIPT
% updateProgress(app,[fprintf('Lattice optimization for Patient %s', PatientID)]);
updateProgress(app, char(sprintf(['\nLattice optimization for Patient ', PatientID,'...\n'])));
[path, CTinfo, zDim, strList, infoIn, RoiCont] = extract_data(PatPath, PatientID);
GUIselectPTV('init', strList); % close window -> gives nPTV
nOAR = GUIselectOAR3('init', strList); % Select also the OARs critical for the patient
uiwait;

%%
%uiwait;
%%
% part added by Andrea to define the
% correct OAR and GTV (18-10-23)
updateProgress(app, char(sprintf('\nCropping the GTV to create Mask\n')));
nOAR=RoiCont.ROIs.Number(nOAR);
nPTV = RoiCont.ROIs.Number(nPTV);

% Create the provisional expansione and crop of GTV and OARs selected
crop_mask = cropGTV(path, nPTV, radius);
expand_mask = dilate_OAR(path, nOAR, 10); % The margin for OARs is constant and set at 10mm 

% The output infoOut is unused in the script but it is usefull to check at
% the end of the script for mistakes or error or just a controll variable

[contourOut, maskPTV_3D, infoOut, number] = GTVmask(crop_mask, expand_mask, CTinfo, zDim, RoiCont, strcat("Mask",case_name), [255, 0, 100]);
updateProgress(app, char(sprintf('\nMask done...\n')));
%%
%[maskPTV_1D, maskPTV_3D] = RSdicom2mask_VT(path{1,1},nPTV, path{1,2}); %CTpath,indexSTR, STRpath
% maskPTV_3D = get_3D_mask(path{1,1}, path{1,2}, nPTV); %CTpath,indexSTR, STRpath

%% Rotation and traslation optimization
updateProgress(app,char(sprintf('\nStarting optimization...\n')));
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
[vertices, to_evaluate] = findMaximum(CTinfo, dim_vq(3), distV_px, vq, reticolo3D,app);
% [vertices, to_evaluate] = findMaximum_gpu(CTinfo, zDim, distV_px, maskPTV_1D, maskReticolo_3D);  
ind = printResults(to_evaluate, mode,app);

%% Target coverage check (if necessary or wanted)

 if check_target == 1
     updateProgress(app,'Checking for the target');

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
[indOpt, integ_ovh, ovhf] = optimize_OVH4(path, CTinfo, zDim, nOAR, ind, to_evaluate, vertices, radius, vq, strList,teta,Vrot, PatientID, to_save, case_name,app, how);
fileName = sprintf('%s%s%s', PatientID, '_',case_name,'_', 'OVH Data');
save(strcat(to_save,fileName), 'integ_ovh', 'ovhf');
% lattice3D = reverseRotation(CTinfo, zDim, W, vertices, to_evaluate, indOpt, vq, centerOfMass);
%lattice3D = indOptLattice(CTinfo, zDim, vertices, to_evaluate, vq, indOpt);
% [maskSphere_cell, nVertices] = generate_spheres2(CTinfo, zDim, radius, lattice3D);
maskSphere_cell = VertexMask(CTinfo, zDim, teta, Vrot, vertices, to_evaluate, radius, vq, indOpt);

%% DicomWrite and export and final Results
updateProgress(app, char(sprintf('\nOVH optimization finished saving the Result\n')));
% path0 = fullfile(pwd,'Immagini', PatientID,'\');
[LatticeXYZ] = Mask2Contour(CTinfo, zDim, maskSphere_cell);
[contourOut, infoOut, number] = addROI(contourOut, LatticeXYZ, 'LatticeMatlab',[0, 255, 100]);

% Save the Dicom with the lattice structure and the new Mask
nameSTR = strcat(SavePath,'STR_Lattice_', PatientID, '_', case_name, '.dcm');
dicomwrite([],nameSTR,infoOut,"CreateMode","copy");

% [contourOut, infoOut, number] = exportDicom2(PatientID, CTinfo, zDim, path0, path, maskSphere_cell, case_name);
toc

figure('Name','PTV and Lattice structure');
plotContour(contourOut, [contourOut.ROIs.Number(end) contourOut.ROIs.Number(end-1)]) % Visualizza la struttura
grid on
if app.saveResultsFlag
    figName = sprintf('%s%s%s', PatientID, '_', 'contourOut', '_',case_name,'_','best.png');
    figName_2 = sprintf('%s%s%s', PatientID, '_', 'contourOut', '_',case_name,'_','best.fig');%Also save the .fig for matlab
    saveas(gcf, strcat(to_save,figName));
    saveas(gcf, strcat(to_save,figName_2))
end
end