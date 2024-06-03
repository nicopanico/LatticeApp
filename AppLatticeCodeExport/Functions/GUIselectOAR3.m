function nOAR = GUIselectOAR3(command, strList)
    nOAR = [];
    if nargin < 1 || isempty(command)
        command = 'INIT';
    end

    switch upper(command)
        case 'INIT'
            % Initialization code remains unchanged
            units = 'pixels';
            screenSize = get(0,'ScreenSize');
            w = 800; h = 600;

            hFig = figure('name', 'Select OAR Menu', 'units', units, 'position',[(screenSize(3)-w)/2 (screenSize(4)-h)/2 w h], 'MenuBar', 'none', 'NumberTitle', 'off', 'resize', 'on', 'Tag', 'selectOARgui', 'DoubleBuffer', 'on');

            ud.figure.w = w; ud.figure.h = h;
            uicontrol(hFig, 'style', 'frame', 'units', units, 'position', [10 10 w-20 h-20], 'enable', 'inactive');
            uicontrol(hFig, 'style', 'text', 'units', units, 'position', [15 540 350 40], 'string', 'Select OARs', 'fontsize', 18, 'fontweight', 'bold');

            afX = 30; afW = w - 2*afX; afH = 230; afY = h - 50 - afH;
            ud.af.X = afX; ud.af.W = afW; ud.af.H = afH; ud.af.Y = afY;

            numbOfStrxRaw = 5;
            ud.df.handles = struct(); % Initialize the handles structure
            for i = 1:length(strList)
                strdy = floor((i-1)/numbOfStrxRaw);
                strdx = (i-1) - numbOfStrxRaw* floor((i-1)/numbOfStrxRaw);
                ud.df.handles.strTxt(i) = uicontrol(hFig, 'style', 'text', 'units', units, 'position', [afX+30+130*strdx afY+170-40*strdy 85 25], 'string', strList(i), 'horizontalAlignment', 'left');
                ud.df.handles.strBox(i) = uicontrol(hFig, 'style', 'checkbox', 'units', units, 'position', [afX+10+130*strdx afY+175-40*strdy 20 25], 'value', 0, 'horizontalAlignment', 'left');
            end

            uicontrol(hFig, 'style', 'pushbutton', 'units', units, 'position', [afX+100 afY-230 120 30], 'string', 'Select structures', 'horizontalAlignment', 'left', 'callback', @plotButtonPushed, 'fontweight', 'bold');

            set(hFig, 'userdata', ud);

            % Wait for user selection
            uiwait(hFig);
            nOAR = getappdata(hFig, 'selectedOARs'); % Retrieve selected OARs
            close(hFig); % Close the figure

        case 'SELECTED'
            error('The ''SELECTED'' command is not supported when using ''INIT''.');

        otherwise
            error('Invalid command.');
    end

   function plotButtonPushed(src, event)
        % This function triggers the selection process when the button is pressed
        ud = get(gcf, 'userdata');

        % Find the indices of selected OARs based on the checkbox values
        listStructures = zeros(size(ud.df.handles.strBox));
        for i = 1:length(ud.df.handles.strBox)
            listStructures(i) = get(ud.df.handles.strBox(i), 'value');
        end

        nOAR = find(listStructures);

        % Store selected OARs in the figure's appdata
        setappdata(gcf, 'selectedOARs', nOAR);

        % Resume the uiwait loop
        uiresume;
    end
end