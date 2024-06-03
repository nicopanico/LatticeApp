function D = pseudo_dose_exp(xradius, radius, lambda)
% Function to evaluate the pseudo dose decrease in the lattice following
% the exponential model
% INput:   
        % xradius = increased radius in mm
        % radius = starting radius
        % lambda = exponential coefficient
% OUTput:
        % D = pseudo-dose value normalized between 1 and 0 
% @Nicola 12'09'2023


D = exp(-lambda*(xradius-radius));

end