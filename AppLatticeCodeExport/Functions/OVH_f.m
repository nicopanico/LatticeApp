function [area, ovhcurve] = OVH_f(lattice3D,maskoar, b, CTinfo, zDim, radius, teta, Vrot, tform)

% Reference: Zhou 2016 "An effective calculation method for an overlap volume
% histogram descriptor and its application in IMRT plan retrieval"

nvoverlap = 0; % numero voxel overlap
k = 2;
ovh(1)=0;
ovh(2)=0;
newradius = radius;
tform_1=tform;
tform_1.T=tform.T^(-1); %genera la trasformazione affine 
maskoar = imwarp(maskoar,tform_1,'interp','nearest');
maskoar= imrotate3(maskoar,teta,Vrot',"nearest","crop"); %ruota OARs
nvoar = length(find(maskoar)); % numero voxel oar 
zdimmin=min([size(maskoar,3) zDim]);
while ((nvoverlap < nvoar && ovh(k)>ovh(k-1))||ovh(k)==0)
    newradius = newradius + b;
    dilateptv = generate_spheres_iso(CTinfo, zDim, newradius, lattice3D);
%    dilateptv = imrotate3(dilateptv,-teta,Vrot',"nearest","crop"); %controruota il lattice
%    dilateptv = imwarp(dilateptv,tform,'interp','nearest');
%    nvoverlap = length(find(dilateptv.*maskoar)); % n voxel overlap
    nvoverlap = sum(sum(sum(dilateptv(:,:,1:zdimmin).*maskoar(:,:,1:zdimmin))));
    k = k+1;
    ovh(k) = nvoverlap;
end

ovh = ovh(3:end);
k = k-2;
ovh = ovh/nvoar;
d = [1:k];
d = d*b;

% Distanza pesata per OVH
% area = sum(ovh.*d);

% Area con l'asse Y (metodo trapezi)
area = 0;
for i = 2:length(ovh)
    temp = ((d(i)+d(i-1))*(ovh(i)-ovh(i-1)))/2;
    area = area + temp;
end

ovhcurve = zeros(length(ovh),2);
ovhcurve(:,1) = d;
ovhcurve(:,2) = ovh;
% Area con l'essa X (metodo trapezi)
% area = trapz(ovh,d);

% Plot OVH
% figure('Name','OVH');
% plot(d,ovh)
% xlabel('d (mm)');
% ylabel('OVH');
% grid on

end