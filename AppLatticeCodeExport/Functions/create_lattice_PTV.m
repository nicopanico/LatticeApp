function [lattice3D, tform] = create_lattice_PTV(ind, to_evaluate, vq, vertices, zDim0, i)
%function to create the Lattice inside the PTV, taking the index of a
%certain disposition contained in ind (dispositions with max vertices inside
%(PTV)
% @Nicola 26'07'2023
% -update1


[xDim,yDim,zDim] = size(vq);

righe = vertices(:, 1); colonne = vertices(:, 2); zeta = vertices(:, 3);
trasl = to_evaluate(ind(i), 2:4);
maskReticoloTrasl_3D = false(xDim, yDim, zDim);
r = righe + (trasl(1)-1);
c = colonne+(trasl(2)-1);
z = zeta+(trasl(3)-1);
r(r>xDim) = xDim;
c(c>yDim) = yDim;
z(z>zDim) = zDim;
maskReticoloTrasl_1D=sub2ind([xDim yDim zDim],r,c,z);
maskReticoloTrasl_3D(maskReticoloTrasl_1D)=1;        % Reticolo traslato
maskReticoloTrasl_3D=maskReticoloTrasl_3D==1;
lattice3D = (maskReticoloTrasl_3D.*vq)==1;   % Reticolo traslato interno al PTV

tform = affine3d([1 0 0 0; 0 1 0 0; 0 0 zDim0/size(vq,3) 0; 0 0 0 1]);



end

