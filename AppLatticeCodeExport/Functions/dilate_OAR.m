function [expand_mask, varargout] = dilate_OAR(path, nOAR, constMarg)

% Function to create the dilated OARs mask in order to check wheter an OAR
% is near the target and so an extra amrgin to the GTV needs to be added in
% the mask creation
% INput:
        % path = path of the Dicom
        % nOAR =  list containing the selected OARs
        % constMarg = margin consttant added, based on the clinical
        % protocol it may vary from 10mm to 15mm
% OUTput:
        % expand_mask = dilated mask of the OARs, if nOAR cointains more
        % than one OAR the final mask will contain both the expansion of
        % the OARs togheter

% @Nicola 12-10-23


% Create the masks of the OARs (they are always from 0 to 2, selected by the doctor a priori)

if isempty(nOAR)
    expand_mask = zeros(512, 512, 128); %case of no OAR selected (i.e. GTV in the leg or isolated from other OARs)
else
    %Case in which the OARs are selected
    if length(nOAR) == 1
        varargout{1} = get_3D_mask(path{1,1}, path{1,2}, nOAR(1));

        [X,Y,Z] = ndgrid(-10:10, -10:10, -10:3:10);
        % Sphere inside the filter to perform the operation
        nhood = sqrt(X.^2 + Y.^2 + Z.^2) <= constMarg;
        expand_mask = imdilate(varargout{1}, nhood);
    elseif length(nOAR) == 2
        %create the 2 masks
        varargout{1} = get_3D_mask(path{1,1}, path{1,2}, nOAR(1));
        varargout{2} = get_3D_mask(path{1,1}, path{1,2}, nOAR(2));

        %perform the expansion for both OAR
        [X,Y,Z] = ndgrid(-10:10, -10:10, -10:3:10);
        % Sphere inside the filter to perform the operation
        nhood = sqrt(X.^2 + Y.^2 + Z.^2) <= constMarg;

        expand_mask1 = imdilate(varargout{1}, nhood);
        expand_mask2 = imdilate(varargout{2}, nhood);

        expand_mask = expand_mask2 + expand_mask1;
    end
end



        
