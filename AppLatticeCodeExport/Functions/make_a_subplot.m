function make_a_subplot()

% New scripts to make plots for OVH representation for different lattice
% spheres radius..
% Takes the folder containing the chosen patients and do the subplot
% containing the chosen cases
% @Nicola 15-12-2023
vertices_data = [796 174	100	53	24; 221	51	28	15	7; 217	47	26	12	7];
volume_lat_data = [2.8	2.8	2.8	2.9	2.6
2.7	2.9	2.7	2.8	2.7
2.8	2.8	2.6	2.3	2.8
2	2.1	2.3	2.3	3.2
];
data_dir = uigetdir;
files = dir(fullfile(data_dir));
for i = 3:length(files)
    current_dir = fullfile(data_dir, files(i).name);
    dir_files = dir(fullfile(current_dir));
    subplot(1,3,i-2);
    list_lines = ["-","--",":","-.","-"];
    for j = 3:length(dir_files)
        ff = open(fullfile(current_dir,dir_files(j).name));
        ovh1_radius = ff.ovhf{1}(:,1);
        ovh1_data =  ff.ovhf{1}(:,2);

        plot(ovh1_radius, ovh1_data, list_lines(j-2),LineWidth=1.2);
        
        hold on
    end 
    title_label = ["(GTV=3272cc, $R_{AV}$=28.8)","(GTV=929cc, $R_{AV}$=41)","(GTV=911cc, $R_{AV}$=54.2)", ...
        "(GTV=788.34cc, $R_{AV}$=45.6)"];
    which_data = {dir_files(3:end).name};
    title(strcat("Pat",{' '},string(i-2),{' '},title_label(i-2)), 'FontSize',12,'Interpreter','latex',...
        'FontWeight','bold');
    xlabel("Distance (mm)",'FontSize',12);
    ylabel("OVH",'FontSize',12);
    % gigi = string(files(i).name);
    % to_save = strcat("C:\Users\nicop\Desktop\Lattice Patient\OVH_data_for_plots\",gigi,".fig");
    % saveas(gcf, to_save);
    % close;
    gg = string({
        strcat("3mm (Vx=", num2str(vertices_data(i-2,1)),',', ' $V_v/GTV$=', num2str(volume_lat_data(i-2,1)), ')'), ...
        strcat("5mm (Vx=", num2str(vertices_data(i-2,2)),',', ' $V_v/GTV$=', num2str(volume_lat_data(i-2,2)), ')'), ...
        strcat("6mm (Vx=", num2str(vertices_data(i-2,3)),',', ' $V_v/GTV$=', num2str(volume_lat_data(i-2,3)), ')'), ...
        strcat("7.5mm (Vx=", num2str(vertices_data(i-2,4)),',', ' $V_v/GTV$=', num2str(volume_lat_data(i-2,4)), ')'), ...
        strcat("9.5mm (Vx=", num2str(vertices_data(i-2,5)),',', ' $V_v/GTV$=', num2str(volume_lat_data(i-2,5)), ')')
        });

    % Convert gg to a string array
    
    
    legend(gg,'Location','southoutside','Interpreter','latex','FontSize',14);
    hold off;
end
sgtitle("Patient-specific behaviour of the OVH");
end