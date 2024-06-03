function [PatientID, radius, dVertex, check_target, mode, case_name, how] = extract_input(answer)

PatientID = answer{1}; % Patient name                     
radius = str2num(answer{2}); % mm, raggio sfere (Duriseti 7.5)
if str2num(answer{3}) == 0; 
    xd=radius*8; yd=radius*8; zd = radius*8;
else
    xd = str2num(answer{3}); yd = str2num(answer{3}); zd = str2num(answer{3});
end

dVertex = [xd, yd, zd]; % vertex distance
check_target = str2num  (answer{4});  % option to perform target coverage check (1 = yes, 0 = no)
mode = answer{5};   % 'target' for target coverage or 'max' for standard method
case_name = answer{6};  % name of the case to save final Dicom (will be displayed at the beginning)
how = answer{7}; % Per definire che modalità usare per la scelta della disposizone con gli OVH (solo per paper)
end
