% ---------------------------------------------------------
% 1D mask array for a specified VOI structure
% ---------------------------------------------------------
% P Dvorak 2018
% ---------------------------------------------------------
% Reconstruct given VOI structure 3D mask matrix stored in a DICOM
% RTSTRUCT file. Requires referenced DICOM image series to derive 3D mask
% matrix parameters. Searches through the image files in current folder and if CT, MR or PT
% then sorts them by ImagePositionPatient. Last point on the line
% connecting ImagePositionPatient points is the OriginXYZ. This is used to
% convert XYZ coordinates of contour points in matrix indices IJK.
% Reconstructed ContourGroups are expected CLOSED_PLANAR so a poly-mask is created.
% From this poly-mask are extracted linear indices of ones forming a given planar
% structure (area beloging to a given structure on a given slice). The linear indices
% are stored as the function output.
% ---------------------------------------------------------
%
% INPUT:
% - DICOM RTSTRUCT filename as a string
% - StructureIndex: index of a desired structure in the sequence of VOIs
%                   stored
%
% OUTPUT:
% - 1D array of linear indices indicating a given VOI structure 1D mask
% ---------------------------------------------------------
%
% Syntax: RSdicom2mask(RSfilename,StructureIndex)
% ---------------------------------------------------------
%
% Dependent user-functions:
% - none
% ---------------------------------------------------------
%
%         Version: 1/2018
% Version History: none
% ---------------------------------------------------------

function [mask1D, mask3D] = RSdicom2mask_VT(dcmFilesPath,StructureIndex,RSfilename, offCTx,offCTy)

if (nargin<4)
    offCTx=0;
    offCTy=0;
end

disp('Reconstructing contour data from DICOM......   ');

%getting information about the reference image set

dcmFiles = dir(dcmFilesPath);
disp('Extracting DICOM information...');

n=0;
for i=3:length(dcmFiles)
    if dcmFiles(i).bytes>0
        fileInfo = dicominfo(fullfile(dcmFiles(i).folder,dcmFiles(i).name));
        Modality=fileInfo.Modality;
            if (string(Modality)=='CT')|(string(Modality)=='RTSTRUCT')|(string(Modality)=='PT')|(string(Modality)=='MR')
                SliceLocationFile(n+1,:) = [i,fileInfo.ImagePositionPatient'];
                n = n+1;
            end
     end
end
disp('OK');

if size(SliceLocationFile,1)>1
    for i=1:size(SliceLocationFile,1)
        SliceLocationFile(i,5)=(SliceLocationFile(i,2:4)-SliceLocationFile(1,2:4))/(SliceLocationFile(2,2:4)-SliceLocationFile(1,2:4))*norm(SliceLocationFile(2,2:4)-SliceLocationFile(1,2:4));
    end
else
    sliceLocationFile(1,5)=0;
end

SliceLocation = sortrows(SliceLocationFile,5);

NoOfCTs = size(SliceLocation,1);

%fileInfo = dicominfo(strcat(dcmFiles(3).folder,'\',dcmFiles(3).name));

CTinfo1=dicominfo(fullfile(dcmFiles(SliceLocation(end,1)).folder,dcmFiles(SliceLocation(end,1)).name)); 
if CTinfo1.ImagePositionPatient(3)<0
    CTinfo2=dicominfo(fullfile(dcmFiles(SliceLocation(end-1,1)).folder,dcmFiles(SliceLocation(end-1,1)).name));
else
    CTinfo1=dicominfo(fullfile(dcmFiles(SliceLocation(1,1)).folder,dcmFiles(SliceLocation(1,1)).name));
    CTinfo2=dicominfo(fullfile(dcmFiles(SliceLocation(2,1)).folder,dcmFiles(SliceLocation(2,1)).name));
end
%CTinfo1=dicominfo(strcat(dcmFiles(SliceLocation(end,1)).folder,'\',dcmFiles(SliceLocation(1,1)).name)); 
%CTinfo2=dicominfo(strcat(dcmFiles(SliceLocation(end-1,1)).folder,'\',dcmFiles(SliceLocation(2,1)).name));

OriginXYZ1=CTinfo1.ImagePositionPatient;
OriginXYZ2=CTinfo2.ImagePositionPatient;

CTx0=OriginXYZ1(1)-offCTx;
CTy0=OriginXYZ1(2)-offCTy;
CTz0=OriginXYZ1(3);
CTrows=CTinfo1.Rows; %number of rows of a CT image...will be same for VOI matrix
CTcolumns=CTinfo1.Columns; %number of columns of a CT image...will be same for VOI matrix
PixelSize=CTinfo1.PixelSpacing(1); %pixel size from CT image to convert DICOM coordinates to voxel coordinates/SQUARE PIXEL EXPECTED!
SliceSpacing = norm(OriginXYZ2-OriginXYZ1);%assuming constant within the series

%END: getting information about the reference image set


RS=dicominfo(RSfilename);

for CTsliceIndex=1:NoOfCTs
    structureMask{CTsliceIndex}=[];
end                                     

ContourGroupDATA_Structure={};

if length(fieldnames(eval(['RS.ROIContourSequence.Item_',num2str(StructureIndex)])))>2
    
    ContourGroupXCTslice=zeros(length(fieldnames(eval(['RS.ROIContourSequence.Item_',num2str(StructureIndex),'.ContourSequence']))),2);

    for ContourGroupIndex=1:length(fieldnames(eval(['RS.ROIContourSequence.Item_',num2str(StructureIndex),'.ContourSequence'])))
        ContourGroupDATA=eval(['RS.ROIContourSequence.Item_',num2str(StructureIndex),'.ContourSequence.Item_',num2str(ContourGroupIndex),'.ContourData']); %StructureIndex-th structure, ContourGroupIndex-th...
        ContourGroupDATA_Voxels=zeros(eval(['RS.ROIContourSequence.Item_',num2str(StructureIndex),'.ContourSequence.Item_',num2str(ContourGroupIndex),'.NumberOfContourPoints']),3);

        for CountourPointNo=1:eval(['RS.ROIContourSequence.Item_',num2str(StructureIndex),'.ContourSequence.Item_',num2str(ContourGroupIndex),'.NumberOfContourPoints'])
            ContourGroupDATA_Voxels(CountourPointNo,1)=round((ContourGroupDATA(3*CountourPointNo-2,1)-CTx0)/PixelSize);
            ContourGroupDATA_Voxels(CountourPointNo,2)=round((ContourGroupDATA(3*CountourPointNo-1,1)-CTy0)/PixelSize);
            ContourGroupDATA_Voxels(CountourPointNo,3)=1+round((ContourGroupDATA(3*CountourPointNo,1)-CTz0)/SliceSpacing);
        end %CountourPointNo

        ContourGroupDATA_Structure{ContourGroupIndex}=ContourGroupDATA_Voxels;
        ContourGroupXCTslice(ContourGroupIndex,:)=[ContourGroupIndex,ContourGroupDATA_Voxels(1,3)];

    end %ContourGroupIndex
    
    mask1D=[];

    for CTsliceIndex=1:NoOfCTs

        [I]=find(ContourGroupXCTslice(:,2)==CTsliceIndex);

        if length(I)>0

            mask2Dslice=zeros(CTrows,CTcolumns);
            for i=1:length(I)
                ContourGroupDATA_CT=ContourGroupDATA_Structure{I(i)};
                ContourMask=roipoly(mask2Dslice,ContourGroupDATA_CT(:,1),ContourGroupDATA_CT(:,2));
                mask2Dslice=mask2Dslice+ContourMask;
            end %i

            mask2Dslice(mask2Dslice>1)=0;

            [II,JJ]=find(mask2Dslice==1);

            mask1Dnew=[mask1D;sub2ind([CTrows,CTcolumns,NoOfCTs],II,JJ,CTsliceIndex*ones(size(II)))];

            %clear mask1D;

            mask1D=mask1Dnew;
            mask3D=zeros([CTrows,CTcolumns,NoOfCTs]);
            mask3D(mask1D)=1;
%             mask3D = logical(mask3D);

            clear mask1Dnew;

        end %if
    end %CTsliceIndex
    
else %if
    disp('No ContourSequence available for this structure');
end %if

