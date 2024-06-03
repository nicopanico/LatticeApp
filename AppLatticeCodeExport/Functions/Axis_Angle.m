function [Vrot,teta]=Axis_Angle(W)
[V,D] = eig(W);
Vrot=V*(~imag(D*[1 1 1]')); %trova l'asse di rotazione
teta=acos(trace(D.*(~(~imag(D))))/2)*180/pi; % trova l'angolo di rotazione in deg 
%imrotate3(norot,teta,Vrot,"nearest","crop");
end