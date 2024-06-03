
% INPUT PATIENT ID PROCESSED

PatientID = '1000-21'; % >>>>> OK Matlab >>>>> OK Eclipse
nSTR = 31;
%  OAR: Aorta, BronchialTree_L, Arteria Polmonare
%  Lattice

PatientID = '1193-21'; % >>>>> OK Matlab (8 config, era 1)
nSTR = 12;
% OAR: Great Vessels

PatientID = '690-22'; % Una sola configurazione Lattice (anche con Trasl 2)
nSTR = 19; 
% radius = 6.8;
% OAR: Trachea ed Esofago

PatientID = '880-22'; % NON fatto, ha mask nel braccio, lontano OARs

PatientID = '477-20'; % >>>> OK Matlab (3 config, era 1) >>>> OK Eclipse
% mask = GTVboostMASK;
% OAR: Cuore ed Esofago

PatientID = '592-06'; % >>>> Paziente del 15/09/2022 presentato a Bologna e Roma
% OAR: KidneyR e Duodeno

PatientID = '141-10'; % >>>>> OK Matlab >>>>> OK Eclipse
% OAR: Stomaco e Cuore

PatientID = '600-20'; % >>>>> OK Matlab >>>> OK Eclipse
% OAR: Bowel

PatientID = '808-22'; % >>>>> OK Matlab ma 1 sola config (anche con tral 1)
% radius = 5;
% OAR: Lung L, Spinal Cord

PatientID = '1392-21'; % >>>>> OK Matlab, OK Eclipse
% OAR: Genitalia, Femore

PatientID = '212-22';


%%%% DA FARE
PatientID = '1267-21';

PatientID = '1147-22'; % Paziente nuovo del 20/10/2022
% OAR Cauda Equina

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STANDARD input data (Duriset lattice):
radius = 7.5;  % 7.5mm -> diameter=1.5cm
xd = radius*8; % 7.5*8 = 60mm