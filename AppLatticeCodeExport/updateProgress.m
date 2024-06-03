% function updateProgress(app, message)
%     % Get the current content of the TextArea
%     currentContent = app.TextArea.Value;
% 
%     % Append the new message to the current content, along with a newline character
%     updatedContent = strcat(currentContent, char(message), newline);
% 
%     % Update the TextArea with the new content
%     app.TextArea.Value = updatedContent;
% 
%     % Ensure immediate update of the UI
%     drawnow;
% end
% function updateProgress(app, message)
%     % Get the current content of the TextArea
%     currentContent = app.TextArea.Value;
% 
%     % Append the new message to the current content, along with a newline character
%     updatedContent = sprintf('%s%s\n', currentContent, message);
% 
%     % Update the TextArea with the new content
%     app.TextArea.Value = updatedContent;
% 
%     % Ensure immediate update of the UI
%     drawnow;
% end
function updateProgress(app, message)
    % Convert message to a string if it's a cell array
    if iscell(message)
        message = char(message);
    end

    % Add the message to the array messages
    app.Messages{end+1} = message;
    
    % Clear the current content of the TextArea
    app.TextArea.Value = '';

    % Get the current content of the TextArea
    currentContent = app.TextArea.Value;

    % Append the new message to the current content, along with a newline character
    updatedContent = strcat(currentContent, message, newline);

    % Update the TextArea with the new content
    app.TextArea.Value = updatedContent;

    % Ensure immediate update of the UI
    drawnow;
end