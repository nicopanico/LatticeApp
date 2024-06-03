function num_vxl = count_voxels(struct_mask_3D)
%function in order to count the voxels that are inside a structure
%INputs:
   %strcuct_mask_3D == 3D mask of the desired structure (CT mask...
     % ...515x515x128)
%OUTputs:
   %num_vxl == number of voxels of the structure (pure count, no position
   %or coordinates
% @Nicola 26'07'2023

target_voxels = find(struct_mask_3D); %voxels of the target (mask in this case)
num_vxl = length(struct_mask_3D); % number of target voxels

end