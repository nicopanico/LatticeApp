function GUIselectOAR_new(command, strList)
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
        assignin('caller', 'nOAR', nOAR);
       
        
        
    case 'SELECTED'
        % Get the handles of all checkboxes directly from the current figure
        hFig = gcf; % Get the handle of the current figure
        ud = get(hFig, 'userdata');
        
        listStructures = zeros(size(ud.df.handles.strBox));
        for i = 1:length(ud.df.handles.strBox)
            listStructures(i) = get(ud.df.handles.strBox(i),'value');
        end
        
        nOAR = find(listStructures);
        % Handle selected OARs here, for example, display them or perform further processing
        disp('Selected OARs:');
        disp(nOAR);
        assignin('caller', 'nOAR', nOAR);
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

        % Assign the selected OAR indices to a variable in the caller workspace
        assignin('caller', 'nOAR', nOAR);

        % Close the current figure
        close(gcf);
        uiresume;
    end
end