% Dopo il calcolo normale, ne eseguo un altro (dai dati nel WS) per
% prendere la configurazione peggiore

[~, indOVH] = min(sum(integ_ovh,2)); % prendo la configurazione (i) che ha la somma degli OVH sugli OAR minima
indOpt = ind(indOVH);

maskSphere_cell = VertexMask(CTinfo, zDim, teta, Vrot, vertices, to_evaluate, radius, vq, indOpt);
[contourOut, infoOut, number] = exportDicom2(PatientID, CTinfo, zDim, path, maskSphere_cell);

figure('Name','PTV and Lattice structure worst');
plotContour(contourOut, [nPTV number]) % Visualizza la struttura
grid on

figName = sprintf('%s%s%s%s%s',PatientID, '_', 'contourOut', '_', 'worst.png');
saveas(gcf, figName)