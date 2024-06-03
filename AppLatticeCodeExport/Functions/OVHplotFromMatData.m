
function OVHplotFromMatData()



myDir = uigetdir(pwd, 'Select a folder');
files = dir(fullfile(myDir, '*.mat'));
ll = 1;
while ll <= 2;
    for i = 1:length(files);
        name = files(i).name;
        load(fullfile(files(i).folder, files(i).name));
        sum_array = (sum(integ_ovh,2));
        idx = find(sum(integ_ovh,2)==max(sum_array));

        hold on
        p = plot(ovhf{idx,ll}(:,1), ovhf{idx,ll}(:,2));
    end
    name_list = ["Classic","Disp0","Disp_1","Disp_2","Disp_3"];
    legend(name_list,'Interpreter','none','Location','eastoutside');
    xlabel('Spheres Radius (mm)');
    ylabel('Organ overlapping (%)');
    name = sprintf('%s%s%s','OVH','_', string(ll));
    name_2 = sprintf('%s%s%s','OVH','_', string(ll),'.png');

    saveas(gcf,name);
    saveas(gcf,name_2);

    close;
    ll = ll + 1;
end






end
