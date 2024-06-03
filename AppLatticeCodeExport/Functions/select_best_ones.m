function best_ones = select_best_ones(best_ones, cases, filter_mode, varargin)
%Function to select and filter the final array based on the specific
%requirements that the user have on the selection of plans
%Inputs: best_ones == array of the all dispositions
       % cases ==  number of cases that wanted to be selected
       % filter_mode == modality of filters to use in the fucntion
       % filter_array
       % varargin == containing the additional informations for the filter
       % function
   % @Nicola 01'09'23

% Added the case in which the Nmax and Nmax-1 are less than 5 in total (can
% happen for some cases), in this case takes all the dispositions with max
% and max-1 vertices
% @Nicola 25/08/23

if size(best_ones,1) < cases
    best_ones = best_ones(1:size(best_ones,1), :);
else
    best_ones = best_ones(1:cases, :);
end

%check if there are some outliers, can happen if a patient has a mask which
%is particularly weird
best_ones = filter_array(best_ones,filter_mode, varargin{1}, varargin{2}); 


% Update: created as a table and display it while perfomring the
% optimization to make the user see the five best results in a compact and
% clear way- @Nicola 31'07'2023
names = ["n.verteices", "number of incr.", "increased radius", "TCS", "index"];

best_ones = array2table(best_ones, 'VariableNames',names);
fprintf('Best solutions for target covering based on TCS score:\n');
display(best_ones);
end


