function rtMask = get_3D_mask(path1, path2, nPTV)
RT_info = dicominfo(path2);
rtContours = dicomContours(RT_info);
plotContour(rtContours);
%referenceInfo = imref3d([512 512 128], );
%referenceInfo = imref3d([512 512 128]);
% referenceInfo.XIntrinsicLimits = [0 512];
% referenceInfo.YIntrinsicLimits = [0 512];
% referenceInfo.ZIntrinsicLimits = [0 128];
[V, spatial] = dicomreadVolume(path1);
close;
%contourIndex = nPTV;
rtMask = createMask(rtContours, nPTV, spatial);
volshow(rtMask);

rtMask = double(rtMask);
end





