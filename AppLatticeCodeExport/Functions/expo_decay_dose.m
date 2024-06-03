function expo_d = expo_decay_dose(x, R)
%Function to measure the exponential decay based on the Radius
%the function reproduces and approximate the dose decrease based on the 
%increment of the Radius ( distance froma  certain pixel)
%ex: if a voxel distance from the source is 3R the decay of the dose that
%the voxel will feel is 1/e^(2R)
%INPUT:
%      x == the number of radius increment from the source
%      R == Radius (mm) of the spherical source (lattice vertex in this
%      case)
%OUTPUT:
%      expo_d = value of the decrease ranging from 1 to 0 (1 max, 0 min)
%@Nicola 2023


lambda = 1;%set to 1 for the moment it has to be tuned based on the clincal data

expo_d = 1*exp(-lamba*(xR - R));

end

