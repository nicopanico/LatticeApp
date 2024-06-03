% function saveLogToFile(app, filename)
%     % Create the Logs directory if it doesn't exist
%     logsFolder = fullfile(app.SaveFolderPath, 'Logs');
%     if ~exist(logsFolder, 'dir')
%         mkdir(logsFolder);
%     end
% % 
%     % Construct the file path for the log file
%     logFileName = filename; % Provisional name
%     fullFilePath = fullfile(logsFolder, logFileName);
% 
%     % Open the file in append mode and write TextArea content
%     fid = fopen(fullFilePath, 'a');
%     fprintf(fid, '%s\n', app.TextArea.Value);
%     fclose(fid);
% 
%     disp(['Log file saved: ', fullFilePath]);
% end
function saveLogToFile(app, fileName)
 % Create the Logs directory if it doesn't exist
    logsFolder = fullfile(app.SaveFolderPath, 'Logs');
    if ~exist(logsFolder, 'dir')
        mkdir(logsFolder);
    end
    % Open the file for writing
    fid = fopen(fullfile(app.SaveFolderPath, 'Logs', [fileName '.txt']), 'w');
    if fid == -1
        error('Unable to open file for writing.');
    end

    % Convert TextArea value to string if it's a cell array
    logContent = app.TextArea.Value;
    if iscell(logContent)
        logContent = char(logContent);
    end

    % Write TextArea value to the file
    fprintf(fid, '%s\n', logContent);

    % Close the file
    fclose(fid);
end