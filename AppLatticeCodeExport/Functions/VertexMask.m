function sphere3D = VertexMask(CTinfo, zDim0, teta, Vrot, vertices, to_evaluate, radius, vq, indOpt)   
    [xDim,yDim,zDim]=size(vq);
    trasl = to_evaluate(indOpt, 2:4);
    righe=vertices(:,1); colonne=vertices(:,2); zeta=vertices(:,3);
    maskReticoloTrasl_3D = false(xDim,yDim,zDim);
    r=righe+(trasl(1)-1);
    c=colonne+(trasl(2)-1);
    z=zeta+(trasl(3)-1);
    r(r>xDim)=xDim;
    c(c>yDim)=yDim;
    z(z>zDim)=zDim;
    maskReticoloTrasl_1D=sub2ind([xDim yDim zDim],r,c,z);
    maskReticoloTrasl_3D(maskReticoloTrasl_1D)=1;        % Reticolo traslato
    maskReticoloTrasl_3D=maskReticoloTrasl_3D==1;
    lattice3D = (maskReticoloTrasl_3D.*vq)==1;   % Reticolo traslato interno al PTV
    sphere3D = generate_spheres_iso(CTinfo, zDim, radius, lattice3D);
    sphere3D=imrotate3(sphere3D,-teta,Vrot',"nearest","crop");
    
    tform = affine3d([1 0 0 0; 0 1 0 0; 0 0 zDim0/size(vq,3) 0; 0 0 0 1]);
    sphere3D=imwarp(sphere3D,tform,'interp','nearest');
end