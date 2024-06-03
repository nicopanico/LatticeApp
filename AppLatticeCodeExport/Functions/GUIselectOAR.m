
function GUIselectOAR(command, strList)

% global listStructures
listStructures=[];
if ~exist('command')
    command = 'INIT';
end

hFig = findobj('Tag', 'selectOARgui');

%If old figure exists, refresh it.
if isempty(hFig) && ~strcmpi(command, 'INIT')
    error('selectOARgui no longer exists. Callback failed.');
    return;
elseif ~isempty(hFig) && strcmpi(command, 'INIT')
    figure(hFig);
    return;
end

switch upper(command)
    case 'INIT'
        units = 'pixels';
        screenSize = get(0,'ScreenSize');
        w = 800; h = 600;

        %Initial size of figure in pixels. Figure scales fairly well.
        hFig = figure('name', 'Select OAR Menu', 'units', units, 'position',[(screenSize(3)-w)/2 (screenSize(4)-h)/2 w h], 'MenuBar', 'none', 'NumberTitle', 'off', 'resize', 'on', 'Tag', 'selectOARgui', 'DoubleBuffer', 'on');

        ud.figure.w = w; ud.figure.h = h;
        uicontrol(hFig, 'style', 'frame', 'units', units, 'position', [10 10 w-20 h-20], 'enable', 'inactive');
        uicontrol(hFig, 'style', 'text', 'units', units, 'position', [15 540 350 40], 'string', 'Select OARs', 'fontsize', 18, 'fontweight', 'bold');
        
        %Set up add frame
        afX = 30; afW = w - 2*afX; afH = 230; afY = h - 50 - afH;
        ud.af.X = afX; ud.af.W = afW; ud.af.H = afH; ud.af.Y = afY;
        
        %Add checkboxes and tag for all the structures.
        numbOfStrxRaw = 5;
        for i=1:length(strList)
            strdy = floor((i-1)/numbOfStrxRaw);
            strdx = (i-1) - numbOfStrxRaw* floor((i-1)/numbOfStrxRaw);
            ud.df.handles.strTxt = uicontrol(hFig, 'style', 'text', 'units', units, 'position', [afX+30+130*strdx afY+170-40*strdy 85 25], 'string', strList(i), 'horizontalAlignment', 'left');
            ud.df.handles.strBox(i) = uicontrol(hFig, 'style', 'checkbox', 'units', units, 'position', [afX+10+130*strdx afY+175-40*strdy 20 25], 'value', 0, 'horizontalAlignment', 'left');
        end
        
        % SELECT ALL
        uicontrol(hFig, 'style', 'pushbutton', 'units', units, 'position',[afX+675 afY+150 70 25], 'string', 'Select all', 'horizontalAlignment', 'center', 'callback', 'selectOARgui(''SELECTALL'')');
        
        %Add plot button and tag.
        uicontrol(hFig, 'style', 'pushbutton', 'units', units, 'position', [afX+100 afY-230 120 30], 'string', 'Select structures', 'horizontalAlignment', 'left', 'callback', 'GUIselectOAR(''SELECTED'')','fontweight', 'bold');
        
        set(hFig, 'userdata', ud);
%         listStructures = zeros(size(strList));
       
        
  
        
    case 'SELECTED'
%         units = 'pixels';
%         h = 600; dfX = 10; afH = 230; afY = h - 10 - afH; dfY = 10; dfH = afY - 10 - dfY;
%         fieldW = [0 150 220 220 180];
        ud = get(hFig, 'userdata');
        
        for i=1:length(ud.df.handles.strBox)
            listStructures(i) = get(ud.df.handles.strBox(i),'value');
        end
        
        nOAR = find(listStructures);
        assignin('caller', 'nOAR', nOAR);
        return;
        
    case 'SELECTALL'
        ud = get(hFig, 'userdata');
%         strList = ud.df.handles.strBox;
        sumStructSelect = 0;
        for i=1:length(ud.df.handles.strBox)
            sumStructSelect = sumStructSelect + get(ud.df.handles.strBox(i),'value');
        end
        % do nothing if no structures selected
        if (sumStructSelect == length(ud.df.handles.strBox)) 
            valueToSet = 0;
        else
            valueToSet = 1;
        end
        for i=1:length(ud.df.handles.strBox)
            set(ud.df.handles.strBox(i), 'value', valueToSet);
        end
        nOAR = find(listStructures);
        assignin('caller', 'nOAR', nOAR) ;    
        return;
        
end
      
end