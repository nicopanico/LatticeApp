function indmax = printResults(to_evaluate, mode,app)

% Restituisce 'indmax' che contiene gli indici del vettore to_evaluate con
% valore massimo (cioè se ad esempio 5 traslazioni con max numero di
% vertici 5, ind contiene le posizioni relative a quelle 5 traslazioni)
% Stampa nel Command Window un riepilogo del numero di vertici per traslazioni trovati.

%Update: added the part for the target covering
        %Now the function has 2 mode: the max for the normal vertices
        %number maximization inside target
        %or 'target' taking the max number of vertices and the max-1 for
        %the target covering optimization process
% @Nicola 27'07'2023

% Initialize the cell Array
resultsText = {};
%standard part made by @Domenico and @Andrea
if strcmp(mode,'max')
    maxVal = max(to_evaluate(:,1)); % max numero vertici in PTV
    for i = 1:maxVal
        ind = find(to_evaluate(:,1)==i);
        if i==1
            str = sprintf("\nFound %d translation with %d vertex within the mask\n", length(ind), i);
        else
            str = sprintf("Found %d translations with %d vertices within the mask\n\n", length(ind), i);
        end
        resultsText{end+1} = str;
    end
    indmax = find(to_evaluate(:,1)==maxVal);
    if length(indmax) == 1
        indmax = find(to_evaluate(:,1) == maxVal | to_evaluate(:,1) == (maxVal - 1));
    end


%Part added by @Nicola
elseif strcmp(mode, 'target')
    maxVal = max(to_evaluate(:, 1));
    for i = 1:maxVal
        ind = find(to_evaluate(:,1)==i);
        if i==1
            fprintf("\nFound %d translation with %d vertex within the mask\n", length(ind), i);
        else
            fprintf("Found %d translations with %d vertices within the mask\n", length(ind), i);
        end
    end
    indmax = find(to_evaluate(:, 1) == maxVal | to_evaluate(:, 1) == maxVal-1); %takes also the lattices with max-1 vertices
end 

resultsText = string(resultsText);
% Converts the Cell Array into a string concatenating them
resultsText = strjoin(resultsText, '\n');
updateProgress(app, resultsText);
end
