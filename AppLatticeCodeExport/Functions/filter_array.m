function best_ones = filter_array(best_ones, mode, varargin)
%function in order to filter the results based on criteria defined in
%'mode', any further filter can be added by adding a new case to the switch

% 'mean' --> filters the array based on the mean and sd of the sample, any
%    values lower than mean - sd get filtered out and removed

% 'mean_2' --> filters all the values based on the mean and sd, any values
%    lower then mean + sd get filtered out and removed (sugegsted for example
%    with large samples when you want to be more restrictive, it makes no
%    sense to use it with small samples)


% @Nicola 31'07'2023

switch mode
    case 'mean'
        ones_mean = mean(best_ones(varargin{1}, varargin{2}));
        ones_sd = std(best_ones(varargin{1}, varargin{2}));

        controll = (ones_mean-ones_sd);
        best_ones(best_ones(varargin{1}, varargin{2}) < controll, :) = [];

    case 'mean_2'
        ones_mean = mean(best_ones(varargin{1}, varargin{2}));
        ones_sd = std(best_ones(varargin{1}, varargin{2}));

        controll = (ones_mean + ones_sd); %takes the ones that are greater than the whole sample mean + sd
        best_ones(best_ones(varargin{1}, varargin{2}) < controll, :) = [];
        % @Nicola 01-09-2023

    case 'min_incr'
        % takes the cases with the lower number of radius increments to
        % cover the entire mask
        % @Nicola 04-09-23

        min_incr = min(best_ones(varargin{1}, varargin{2}));

        %select only the ones which have the minimun number of radius
        %increment to cover the mask
        best_ones = best_ones(best_ones(varargin{1}, varargin{2}) == min_incr, :); 


end


end