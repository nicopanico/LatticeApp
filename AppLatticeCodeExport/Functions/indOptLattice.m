function maskLattice_3D = indOptLattice(CTinfo, zDim, vertices, to_evaluate, vq, ind)

xDim=double(CTinfo.Width); yDim=double(CTinfo.Height); zDim = double(zDim);
righe=vertices(:,1); colonne=vertices(:,2); zeta=vertices(:,3); % Reticolo originale (non traslato)
trasl = to_evaluate(ind, 2:4);  % Prendo la traslazione ind

% Righe,colonne,zeta del reticolo traslato
maskReticoloTrasl_3D = false(xDim,yDim,zDim);
r=righe+(trasl(1)-1);
c=colonne+(trasl(2)-1);
z=zeta+(trasl(3)-1);
r(r>xDim)=xDim;
c(c>yDim)=yDim;
z(z>zDim)=zDim;

% Costruisco Lattice (Reticolo*PTV), il PTV ruotato (vq)
maskReticoloTrasl_1D=sub2ind([xDim yDim zDim],r,c,z);
maskReticoloTrasl_3D(maskReticoloTrasl_1D)=1;        % Reticolo traslato
maskLattice_3D = maskReticoloTrasl_3D.*vq;   % Reticolo traslato interno al PTV

end

