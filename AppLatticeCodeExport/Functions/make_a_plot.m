function make_a_plot()

% New scripts to make plots for OVH representation for different lattice
% spheres radius..
% The script takes as input the folder containing all the patients
% Folders with OVH_data.mat from the script LatV.m
% Then makes the plot containing the OVH curves for different sphere radius
% to compare them for the same patient
% @Nicola 15-12-2023
data_dir = uigetdir;
files = dir(fullfile(data_dir));
for i = 3:length(files)
    current_dir = fullfile(data_dir, files(i).name);
    dir_files = dir(fullfile(current_dir));
    for j = 3:length(dir_files)
        ff = open(fullfile(current_dir,dir_files(j).name));

        ovh1_radius = ff.ovhf{1}(:,1);
        ovh1_data =  ff.ovhf{1}(:,2);

        plot(ovh1_radius, ovh1_data, '--');
        hold on
    end 
    which_data = {dir_files(3:end).name};
    gg = string(which_data);
    legend(gg,'Location','eastoutside','Interpreter','none');
    gigi = string(files(i).name);
    to_save = strcat("C:\Users\nicop\Desktop\Lattice Patient\OVH_data_for_plots\",gigi,".fig");
    saveas(gcf, to_save);
    close;
    hold off;
end
end
        
        

