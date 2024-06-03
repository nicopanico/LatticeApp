


revvq = interp3(X,Y,Z,vq,X3,Y3,Z3,'nearest');
revvq(isnan(revvq))=0;
revvq = logical(revvq);



meanA = mean(vq(:));
centerOfMassX2 = mean(vq(:) .* X(:)) / meanA;
centerOfMassY2 = mean(vq(:) .* Y(:)) / meanA;
centerOfMassZ2 = mean(vq(:) .* Z(:)) / meanA;
X1=X-centerOfMassX2;
Y1=Y-centerOfMassY2;
Z1=Z-centerOfMassZ2;

% Rotazione inversa per tornare al riferimento iniziale
kk=[X1(:) Y1(:) Z1(:)];
Q = inv(W);
XYZ2=(Q*kk')';
X2=reshape(XYZ2(:,1),size(X1));
Y2=reshape(XYZ2(:,2),size(X1));
Z2=reshape(XYZ2(:,3),size(X1));


% Traslazione inversa per tornare al riferimento iniziale
X3=X2+centerOfMass1(1);
Y3=Y2+centerOfMass1(2);
Z3=Z2+centerOfMass1(3);

% Lattice ruotato
lattice = interp3(X,Y,Z,maskLattice_3D,X3,Y3,Z3,'nearest'); % Lattice ruotato
lattice(isnan(lattice))=0;
% scatter3(X(lattice(:)==1),Y((lattice(:)==1)),Z((lattice(:)==1)))
lattice = logical(lattice);

% >>>>>>>PROBLEMA CODICE
scatter3(X(maskLattice_3D(:)==1),Y((maskLattice_3D(:)==1)),Z((maskLattice_3D(:)==1)))
figure
scatter3(X(lattice(:)==1),Y((lattice(:)==1)),Z((lattice(:)==1)))
figure
scatter3(X(vq(:)==1),Y((vq(:)==1)),Z((vq(:)==1)))
revvq = interp3(X,Y,Z,vq,X3,Y3,Z3,'nearest');
revvq(isnan(revvq))=0;
revvq = logical(revvq);
figure
scatter3(X(revvq(:)==1),Y((revvq(:)==1)),Z((revvq(:)==1)))





%%%%%%%%%%%%%%%%%%%%%%%%%%% BOTTI
aa=[X1(maskLattice_3D==1),Y1(maskLattice_3D==1),Z1(maskLattice_3D==1)];
bbb=Q*aa'+centerOfMass1';
figure
scatter3(bbb(1,:),bbb(2,:),bbb(3,:))


%%%%%%%%%%%%%%%%%%%%%%%%%%%

% XYZ meshgrid

kk=[X(:) Y(:) Z(:)];
Q = inv(W);
XYZ1=(Q*kk')';
X1=reshape(XYZ1(:,1),size(X));
Y1=reshape(XYZ1(:,2),size(X));
Z1=reshape(XYZ1(:,3),size(X));

X2=X1+centerOfMass1(1);
Y2=Y1+centerOfMass1(2);
Z2=Z1+centerOfMass1(3);

ltt = interp3(X,Y,Z,maskLattice_3D,X2,Y2,Z2,'nearest'); % Lattice ruotato
ltt(isnan(ltt))=0;
figure
scatter3(X(ltt(:)==1),Y((ltt(:)==1)),Z((ltt(:)==1)))


