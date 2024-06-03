classdef goLatticeApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        StartButton      matlab.ui.control.Button
        FolderButton     matlab.ui.control.Button
        SaveFolderButton matlab.ui.control.Button
        FolderPath       string
        SaveFolderPath   string
        TextArea         matlab.ui.control.TextArea % New text area for displaying progress
        LogFileNameField  matlab.ui.control.EditField
        % LogFileNameLabel matlab.ui.control.Label
        SaveLogButton matlab.ui.control.Button
        StopButton matlab.ui.control.Button % Button to stop the app
        FigurePanel       matlab.ui.container.Panel % Panel to display figures
        ClearButton    matlab.ui.control.Button % Pulsante per cancellare il contenuto della TextArea
        SaveMessagesButton matlab.ui.control.Button % Aggiunta la proprietà SaveMessagesButton
        SavePlotsButton  matlab.ui.control.Button % Button to trigger saving of plots


    end
    properties (Access = public)
        Messages = {};  % Array to memorize the messages of the textArea
        saveResultsFlag = false; % Flag to control saving of results
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartButton
        function StartButtonPushed(app, ~)
            if isempty(app.FolderPath)
                errordlg('Please select a folder first.', 'Folder Not Selected');
                return;
            end
            if isempty(app.SaveFolderPath)
                errordlg('Please select a saving folder first.', 'Saving Folder Not Selected');
                return;
            end
            % Call the Lattice function with progress update
            updateProgress(app,char(sprintf('\nLattice optimization started...\n')));
            Lattice(app.FolderPath, app.SaveFolderPath,app);
            updateProgress(app,char(sprintf('\nLattice optimization completed.\n')));
            % Close the GUI
            % delete(app.UIFigure);
        end

        % Button pushed function: SavePlotsButton
        function SavePlotsButtonPushed(app, ~)
            % Set saveResultsFlag to true when SavePlotsButton is clicked
            app.saveResultsFlag = true;
        end

        % Button pushed function: FolderButton
        function FolderButtonPushed(app, ~)
            app.FolderPath = uigetdir();
        end

        % Button pushed function: SaveFolderButton
        function SaveFolderButtonPushed(app, ~)
            app.SaveFolderPath = uigetdir();
        end
        % Button pushed function: SaveLogButton
        % function SaveLogButtonPushed(app, ~)
        %     % Get the file name from the EditField
        %     fileName = app.LogFileNameField.Value;
        %     % Call saveLogToFile to save the log
        %     saveLogToFile(app, fileName);
        % end
        function StopButtonPushed(app, ~)
            % Implement the logic to stop the app from running
            % For example, you can close the main figure window
            close(app.UIFigure);
        end
        function ClearButtonPushed(app, ~)
            % Cancella il contenuto della TextArea
            app.TextArea.Value = '';
        end
        function SaveMessagesButtonPushed(app, ~)
            if isempty(app.Messages)
                errordlg('There are no messages to save.', 'Empty Messages');
                return;
            end
            % Chiama il metodo saveMessagesToFile per salvare i messaggi
            app.SaveMessagesToFile();
        end



    end

%     % App initialization
%     methods (Access = private)
% 
%         % Create UIFigure and components
%         function createComponents(app)
%             % Create UIFigure
%             app.UIFigure = uifigure;
%             app.UIFigure.Position = [100 100 400 300];
%             app.UIFigure.Name = 'Lattice App';
% 
%             % Create StartButton
%             app.StartButton = uibutton(app.UIFigure, 'push');
%             app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
%             app.StartButton.Position = [150 250 100 40]; % Aumenta l'altezza per far spazio all'icona
%             app.StartButton.Text = ''; % Rimuovi il testo
%             app.StartButton.Icon = 'Square_grid_graph.svg.png'; % Imposta l'icona del pulsante
%             app.StartButton.IconAlignment = 'center'; % Allinea l'icona al centro del pulsante
%             app.StartButton.BackgroundColor = [0.1 0.7 0.3]; % Imposta il colore di sfondo del pulsante
% 
% 
% %             % Create StartButton
% %             app.StartButton = uibutton(app.UIFigure, 'push');
% %             app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
% %             app.StartButton.Position = [150 250 100 22];
% %             app.StartButton.Text = 'Start Lattice';
% 
%             % Create FolderButton
%             app.FolderButton = uibutton(app.UIFigure, 'push');
%             app.FolderButton.ButtonPushedFcn = createCallbackFcn(app, @FolderButtonPushed, true);
%             app.FolderButton.Position = [50 250 80 22];
%             app.FolderButton.Text = 'Select PatFolder';
% 
%             % Create SaveFolderButton
%             app.SaveFolderButton = uibutton(app.UIFigure, 'push');
%             app.SaveFolderButton.ButtonPushedFcn = createCallbackFcn(app, @SaveFolderButtonPushed, true);
%             app.SaveFolderButton.Position = [250 250 100 22];
%             app.SaveFolderButton.Text = 'Select SaveFolder';
% 
%             % Create TextArea
%             app.TextArea = uitextarea(app.UIFigure);
%             app.TextArea.Position = [50 50 300 180];
%             app.TextArea.Value = '';
%             app.TextArea.Editable = 'on';
% 
%              % Create LogFileNameLabel
%             % app.LogFileNameLabel = uilabel(app.UIFigure);
%             % app.LogFileNameLabel.Position = [50 20 80 22];
%             % app.LogFileNameLabel.Text = 'Log File Name:';
% 
%             % % Create LogFileNameField
%             % app.LogFileNameField = uieditfield(app.UIFigure, 'text');
%             % app.LogFileNameField.Position = [140 20 100 22];
%             % app.LogFileNameField.Value = 'LogFile1';
% 
%             % % Create SaveLogButton
%             % app.SaveLogButton = uibutton(app.UIFigure, 'push');
%             % app.SaveLogButton.ButtonPushedFcn = createCallbackFcn(app, @SaveLogButtonPushed, true);
%             % app.SaveLogButton.Position = [250 20 100 22];
%             % app.SaveLogButton.Text = 'Save Log';
% 
%             % Button to stopApp
%             app.StopButton = uibutton(app.UIFigure, 'push');
%             app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
%             app.StopButton.Position = [250 200 100 22];
%             app.StopButton.Text = 'Stop App';
%             
%             app.FigurePanel = uipanel(app.UIFigure);
%             app.FigurePanel.Title = 'Figure Panel';
%             app.FigurePanel.Position = [360 50 230 280]; % Adjust position and size as needed
% 
%             app.ClearButton = uibutton(app.UIFigure, 'push');
%             app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
%             app.ClearButton.Position = [150 200 100 22];
%             app.ClearButton.Text = 'Clear AppLog';
% 
%             app.SaveMessagesButton = uibutton(app.UIFigure, 'push');
%             app.SaveMessagesButton.ButtonPushedFcn = @(~,~) SaveMessagesButtonPushed(app);
%             app.SaveMessagesButton.Position = [220 20 120 22];
%             app.SaveMessagesButton.Text = 'Save Messages';
%             
%             app.LogFileNameField = uieditfield(app.UIFigure, 'text');
%             app.LogFileNameField.Position = [50 20 150 22];
%             app.LogFileNameField.Value = 'log_file.txt'; % Nome predefinito del file
% 
% 
%             % Create SavePlotsButton
%             app.SavePlotsButton = uibutton(app.UIFigure, 'push');
%             app.SavePlotsButton.ButtonPushedFcn = createCallbackFcn(app, @SavePlotsButtonPushed, true);
%             app.SavePlotsButton.Position = [50 200 100 22];
%             app.SavePlotsButton.Text = 'SavePlots';
% 
% 
%         end
%     end

methods (Access = private)

    % Create UIFigure and components
    function createComponents(app)
        % Create UIFigure
        app.UIFigure = uifigure;
        app.UIFigure.Position = [100 100 600 400];
        app.UIFigure.Name = 'Lattice App';
        app.UIFigure.Color = [1, 1, 1]; % Imposta lo sfondo trasparente
        
        % Create StartButton
        app.StartButton = uibutton(app.UIFigure, 'push');
        app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
        app.StartButton.Position = [250 300 100 40];
        app.StartButton.BackgroundColor = [1 1 1];  % White background
        app.StartButton.FontSize = 14;
        app.StartButton.FontColor = [0 0 0];  % Black text
        app.StartButton.FontName = 'Times New Roman';  % Times New Roman font
        app.StartButton.Text = 'Start Lattice';

        % Create FolderButton
        app.FolderButton = uibutton(app.UIFigure, 'push');
        app.FolderButton.ButtonPushedFcn = createCallbackFcn(app, @FolderButtonPushed, true);
        app.FolderButton.Position = [50 300 150 40];
        app.FolderButton.Text = 'Select PatFolder';
        app.FolderButton.FontSize = 14;
        app.FolderButton.FontColor = [0 0 0];  % Black text
        app.FolderButton.BackgroundColor = [1 1 1];
        app.FolderButton.FontName = 'Times New Roman';  % Times New Roman font

        % Create SaveFolderButton
        app.SaveFolderButton = uibutton(app.UIFigure, 'push');
        app.SaveFolderButton.ButtonPushedFcn = createCallbackFcn(app, @SaveFolderButtonPushed, true);
        app.SaveFolderButton.Position = [400 300 150 40];
        app.SaveFolderButton.Text = 'Select SaveFolder';
        app.SaveFolderButton.FontSize = 14;
        app.SaveFolderButton.FontColor = [0 0 0];  % Black text
        app.SaveFolderButton.BackgroundColor = [1 1 1];
        app.SaveFolderButton.FontName = 'Times New Roman';  % Times New Roman font

        % Create TextArea
        app.TextArea = uitextarea(app.UIFigure);
        app.TextArea.Position = [50 80 500 200];
        app.TextArea.Value = '';
        app.TextArea.Editable = 'on';
        app.TextArea.FontSize = 14;
        app.TextArea.FontName = 'Times New Roman';  % Times New Roman font

        % Button to stopApp
        app.StopButton = uibutton(app.UIFigure, 'push');
        app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
        app.StopButton.Position = [400 240 150 40];
        app.StopButton.Text = 'Stop App';
        app.StopButton.FontSize = 14;
        app.StopButton.FontColor = [0 0 0];  % Black text
        app.StopButton.BackgroundColor = [1 1 1];
        app.StopButton.FontName = 'Times New Roman';  % Times New Roman font

        % Create ClearButton
        app.ClearButton = uibutton(app.UIFigure, 'push');
        app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
        app.ClearButton.Position = [400 190 150 40];  % New position
        app.ClearButton.Text = 'Clear AppLog';
        app.ClearButton.FontSize = 14;
        app.ClearButton.FontColor = [0 0 0];  % Black text
        app.ClearButton.BackgroundColor = [1 1 1];
        app.ClearButton.FontName = 'Times New Roman';  % Times New Roman font

        % Create SaveMessagesButton
        app.SaveMessagesButton = uibutton(app.UIFigure, 'push');
        app.SaveMessagesButton.ButtonPushedFcn = @(~,~) SaveMessagesButtonPushed(app);
        app.SaveMessagesButton.Position = [50 20 150 40];
        app.SaveMessagesButton.Text = 'Save Messages';
        app.SaveMessagesButton.FontSize = 14;
        app.SaveMessagesButton.FontColor = [0 0 0];  % Black text
        app.SaveMessagesButton.BackgroundColor = [1 1 1];
        app.SaveMessagesButton.FontName = 'Times New Roman';  % Times New Roman font

        % Create LogFileNameField
        app.LogFileNameField = uieditfield(app.UIFigure, 'text');
        app.LogFileNameField.Position = [220 20 200 40];
        app.LogFileNameField.Value = 'log_file.txt';
        app.LogFileNameField.FontSize = 14;
        app.LogFileNameField.FontName = 'Times New Roman';  % Times New Roman font

        % Create SavePlotsButton
        app.SavePlotsButton = uibutton(app.UIFigure, 'push');
        app.SavePlotsButton.ButtonPushedFcn = createCallbackFcn(app, @SavePlotsButtonPushed, true);
        app.SavePlotsButton.Position = [400 20 150 40];
        app.SavePlotsButton.Text = 'Save Plots';
        app.SavePlotsButton.FontSize = 14;
        app.SavePlotsButton.FontColor = [0 0 0];  % Black text
        app.SavePlotsButton.BackgroundColor = [1 1 1];
        app.SavePlotsButton.FontName = 'Times New Roman';  % Times New Roman font

    end
end

    % App creation
    methods (Access = public)
        function SaveMessagesToFile(app)

            saveFolder = app.SaveFolderPath;
            % Crea il nome del file incluso il percorso della cartella di salvataggio
            filename = fullfile(saveFolder, app.LogFileNameField.Value);

            if isempty(filename)
                % Se l'utente non ha inserito un nome, utilizza un nome predefinito
                filename = 'log_file.txt';
            end

            % Salva l'array Messages in un file di testo
            writecell(app.Messages, filename);
        end

        % Constructor
        function app = goLatticeApp
            app.FolderPath = '';
            app.SaveFolderPath = '';
            createComponents(app);
            % Show the UI
            app.UIFigure.Visible = 'on';
        end
    end
end
