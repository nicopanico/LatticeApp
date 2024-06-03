function answer = give_input();
% Set the input data by the User
% The function opens the an interface where to insert the input param.
% manually
% The parameters to insert are PatID, radius, spacing, target check, mode,
% and the save name
% the default values for the inputs are:
  % patID = ''
  % radius = 7.5mm
  % spacing = 60mm (7.5 * 8)
  % check tareget =  0 --> doesn't consider target
  % mode = 'max' --> only OVH performed on the disposition with MAX
          % vertices
  % save name = 'Standard_case' --> only parameters that has to be changed
               % since the save name is taken casually
  % @Nicola 13-12-2023

% Define paramters to be inserted  
prompt = {'Enter \bf PatientID:','Enter \bf Spheres Radius',...
    'Enter \bf Lattice Spacing (Insert 0 to have spacing rescaled on radius)',...
    'Enter \bf Target Check','Enter \bf mode','Enter \bf Save Name',...
    'Enter \bf OVH method (Best as Default value)'};
% Options for the windows
opts.('Resize') = 'on';
opts.('WindowStyle') = 'normal';
opts.('Interpreter') = 'tex';

dlgtitle = ('Input Parameters');
fieldsize = [1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50]; %
definput = {'', '7.5', '0', '0', 'max', 'Standard_case','best'};
answer = inputdlg(prompt,dlgtitle,fieldsize,definput,opts);
end

