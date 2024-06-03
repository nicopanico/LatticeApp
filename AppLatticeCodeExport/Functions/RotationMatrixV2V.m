function R = RotationMatrixV2V(u1,u2)

% u1 = [2 4 6]';
% u2 = [6 2 4]';

% z-y-z
th1 = atan2d(u1(2),u1(1));
M1z = RRz(-th1);
th2 = atan2d(u2(2),u2(1));
M2z = RRz(-th2);
v1 = M1z*u1;
v2 = M2z*u2;
b = atan2d(v2(1),v2(3));
a = atan2d(v1(1),v1(3));
My = RRy(b-a);
R = M2z'*My*M1z
R*u1  
% z-x-z
th1 = atan2d(u1(2),u1(1));
M1z= RRz(90-th1);
th2 = atan2d(u2(2),u2(1));
M2z= RRz(90-th2);
v1 = M1z*u1;
v2 = M2z*u2;
b = atan2d(v2(3),v2(2));
a = atan2d(v1(3),v1(2));
Mx = RRx(b-a);
R = M2z'*Mx*M1z
% R*u1  
          

end