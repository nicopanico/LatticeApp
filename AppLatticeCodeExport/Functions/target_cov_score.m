function TC_score = target_cov_score(num_vxl, radius, incr_R, nv)

%Function to evaluate the target covering score --> TC_score
%the TC_score is defined on how good the vertex disposition is able to
%cover the target taking as a reference a uniform distribution having one
%vertex in the target.
%INput:
%      -num_vxl ==  target voxels
%      -radius == radius of the spheres (initial) 
%      -incre_R == incremented radius of the spheres to cover the entire
%      target
%      -nv == number of vertices used in the disposition taken into account
%OUTput:
%      -TC_score ==  target covering score

% @Nicola 26'07'2023
%Update Nicola:
%  Added the part considering the possible vectorial inputs for both incr_R
%  and nv, in this cases the output will be in a vectorial form giving alle
%  the TC_score 's for all the elements of input vector

if size(incr_R, 2)>1 || size(incr_R, 1)>1 %new
    TC_score = [];
    for ii = 1:size(incr_R, 2)
        ttsscc = (num_vxl*(radius/incr_R(ii))^(1/nv))/num_vxl;
        TC_score(1, ii) = ttsscc;
    end
elseif size(nv, 2)>1 || size(nv, 1)>1
    TC_score = [];
    for ii = 1:size(nv, 2)
        ttsscc = (num_vxl*(radius/incr_R)^(1/nv(ii)))/num_vxl;
        TC_score(1, ii) = ttsscc;
    end
else
    TC_score = (num_vxl*(radius/incr_R)^(1/nv))/num_vxl; %calculate the classic score
end

end




