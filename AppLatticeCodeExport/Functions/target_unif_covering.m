
function [incr_count, incr_R] = target_unif_covering(CTinfo, radius, maskPTV_3D, lattice3D, tform, vq, teta, Vrot, incr)
% Function to calculate how good the lattice disposition used is covering
% the target in terms of voxels. The idea of the function is to take the
% lattice disposition with its vertex spheres and test how do they assure
% a good covering of the target expanding them till the total volume of the
% PTV is covered (in this case the volume of the mask_structure), then
% counting how many expansions are necessary to cover the entire volume and
% what is the incread R necessary to do so. This gives an estimation of how
% good the vertices covers the target and assure the PVDR desired.
% INputs: 
%   CTinfo == info of patients taken from DicomInfo(path)
%   radius == radius of the spheres
%   maskPTV_3D ==  mask of the mask_structure used as target
%   lattice3D ==  mask of the lattice disposition used
%   tform == geometrical transformation (got from the function
%   create_lattice_PTV)
%   vq == mask containing the rotation (source main2.mat)
%   teta == angle of rotation (source main2.mat)
%   incre ==  increment of the radius used to generate new spheres
%OUTputs:
%   incr_count == number of increments of the spheres radius necessary to
%     cover the entire target volume (all the voxels)
%   incr_R == the final increased radius obtained as radius +
%     incr_count*(incr)
% @Nicola 26'07'2023
 

%generate the mask containing the spheres for the particulare vertices
%disposition
[xDim, yDim, zDim_1] = size(vq);
maskSphere_3D = generate_spheres_iso(CTinfo, zDim_1, radius, lattice3D);%generate the mask containing the spheres for the lattice vertex disposition


%take the PTV mask and generate the spheres expansions
zdimmin=min([size(maskPTV_3D,3) zDim_1]); %as now this term is useless, but still evaluated (Nicola)

%Part taken from the OVH evaluation (Domenico/Andrea)
tform_1=tform;
tform_1.T=tform.T^(-1); %generate the affine trasformation 
maskPTV_3D = imwarp(maskPTV_3D, tform_1, 'interp', 'nearest'); %trasnofmr the target according to the affine trasformation tform_1
maskPTV_3D = imrotate3(maskPTV_3D,teta,Vrot',"nearest","crop"); %rotate the target

target_voxels = find(maskPTV_3D); %voxels of the target (mask in this case)
num_vxl = length(target_voxels); % number of target voxels

vxl_overlap = sum(sum(sum(maskSphere_3D(:,:,1:zDim_1).*maskPTV_3D(:,:,1:zDim_1)))); %evaliuate the starting voxels overlap, spheres are inside the target
incr_count = 0;
incr_R = radius + incr; %starting radius increment

%condition is that the radius get espanded till the overlapping voxels are
%equal to the target (mask) voxels, which means total overlapping
while vxl_overlap < num_vxl
    dilate_sph = generate_spheres_iso(CTinfo, zDim_1, incr_R, lattice3D);
    vxl_overlap = sum(sum(sum(dilate_sph(:,:,1:zDim_1).*maskPTV_3D(:,:,1:zDim_1))));
    incr_count = incr_count + 1;
    incr_R = incr_R + incr; %update the radius for the next overlap
end

% sprintf('Number of increments to cover the entire PTV: %d', incr_count)
end
