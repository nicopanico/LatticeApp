function PseudoDoseShow()

%create the slice map showing the radius expansion and the pseudo-dose
%modelling

%% first step
% Create the mask containing bth the target and the spehres of initial
% disposition
trial = (maskSphere_cell+maskPTV_3D); % + (maskSphere_cell - maskPTV_3D);
D = [0.1, 0.2, 0.5, 0.6, 0.8];

D = sort(D, 'descend');
for bb = 1:length(D)


    incr = -(log(D(bb))/0.6384); %the generate different pseudo-dose lines


    %% second step
    % Increase the radius of the spheres creating the expanded mask and
    % assigning them the exponentiale decrease
    %incr = 2.5;
    incr_R = radius + incr; %starting radius increment
    D_0 = pseudo_dose_exp(incr_R, 5, 0.6384);
    sphere3D = VertexMask(CTinfo, zDim, teta, Vrot, vertices, to_evaluate, incr_R, vq, indOpt);
    sph_crown = sphere3D - maskSphere_cell;
    D_0 = pseudo_dose_exp(incr_R, 5, 0.6384);
    sph_crown = sph_crown.*D_0;
    trial = sph_crown + trial;


    % pseudoDose_mask = sph_crown + trial;
    % while D_0 > 0.002
%     dilate_sph = generate_spheres_iso(CTinfo, zDim_1, incr_R, lattice3D);
%     sph_crown = dilate_sph - maskSphere_3D;
%     D_0 = pseudo_dose_exp(incr_R, 5, 0.6384);
%     sph_crown = sph_crown.*D_0;
%     pseudoDose_mask = sph_crown + trial;
%     incr_R = incr_R + incr; %update the radius for the next overlap
% end
end

end