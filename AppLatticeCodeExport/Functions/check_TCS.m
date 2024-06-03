function [best_ones, final] = check_TCS(ind, to_evaluate, vq, vertices, zDim, struct_mask_3D, CTinfo, radius, teta, Vrot, incr)
%Function to calculate the target covering score (TCS) through vertices
%spheres expansion. The function takes as input all the geometrical parameters
%originated from the main code (vq, teta, vertices, radius, Vrot) as much
%as the info from the Dicom as CTinfo and the structure mask.
%The function also takes the results of the first optimziation in ind and
%to_evaluate. Then it creates for every disposition the lattice3D with
%spheres in its vertices and expand them till they cover the entire volume
%of target counting the increased radius and number of increases with
%constant step taken to achieve the result.
%OUTput: final: Array containing in the first columns the number of
%vertices, in the second columns the nuber of expansions, in the third the
%increased radius, in the fourth the TCS score, in the fifth the indices of
%that translation as ind(ii)
%Update: added also a second outcome called best_ones containing the best 5
%dispositions in terms of target coverage to be used for the OVH

% @Nicola 27'07'2023


fprintf("Checking the target covering using a radius increment of %d mm\n", incr);

final = [];%create the array
for ii = 1:size(ind, 1)
    [lattice3D, tform] = create_lattice_PTV(ind, to_evaluate, vq, vertices, zDim, ii);%creating the lattice for that disposition
    
    %expanding the spheres of the vertices till covering the entire target
    %volume
    [incr_count, incr_R] = target_unif_covering(CTinfo, radius, struct_mask_3D, lattice3D, tform, vq, teta, Vrot, incr);

    %total voxel of target
    num_vxl = count_voxels(struct_mask_3D);
    %evaliuating the TCS score
    TC_score = target_cov_score(num_vxl, radius, incr_R, to_evaluate(ind(ii),1));
    
    final(ii, :) = [to_evaluate(ind(ii),1), incr_count, incr_R, TC_score, ind(ii)];%appending values
end


best_ones = sortrows(final,4, 'descend');


end

    
