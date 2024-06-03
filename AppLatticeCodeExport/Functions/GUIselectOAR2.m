function nOAR = GUIselectOAR2(command, strList)
    % Initialize nOAR
    nOAR = [];
    
    % Initialize listStructures
    listStructures = zeros(1, numel(strList));
    
    if nargin < 1
        command = 'INIT';
    end

    hFig = findobj('Tag', 'selectOARgui');

    % If old figure exists, refresh it.
    if isempty(hFig) && ~strcmpi(command, 'INIT')
        error('selectOARgui no longer exists. Callback failed.');
        return;
    elseif ~isempty(hFig) && strcmpi(command, 'INIT')
        figure(hFig);
        return;
    end

    switch upper(command)
        case 'INIT'
            % ... (your existing code for initialization)
            
        case 'SELECTED'
            ud = get(hFig, 'userdata');

            for i = 1:numel(ud.df.handles.strBox)
                listStructures(i) = get(ud.df.handles.strBox(i), 'value');
            end

            nOAR = find(listStructures);
            % You may use assignin if needed, but it's not necessary in this case
            assignin('caller', 'nOAR', nOAR);

        case 'SELECTALL'
            ud = get(hFig, 'userdata');
            sumStructSelect = 0;

            for i = 1:numel(ud.df.handles.strBox)
                checkboxValue = get(ud.df.handles.strBox(i), 'value');
                sumStructSelect = sumStructSelect + checkboxValue;
                listStructures(i) = checkboxValue;
            end

            % do nothing if no structures selected
            if sumStructSelect == numel(ud.df.handles.strBox)
                valueToSet = 0;
            else
                valueToSet = 1;
            end

            for i = 1:numel(ud.df.handles.strBox)
                set(ud.df.handles.strBox(i), 'value', valueToSet);
            end

            nOAR = find(listStructures);
            return;
            % You may use assignin if needed, but it's not necessary in this case
            % assignin('caller', 'nOAR', nOAR);
    end
end