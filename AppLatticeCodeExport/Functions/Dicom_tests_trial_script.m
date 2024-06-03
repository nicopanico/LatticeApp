%Open Dicom Files
current_dir = pwd;
patient_dir = strcat(current_dir,'\767-23');

DicomRS = dicominfo(strcat(patient_dir,'\RS.767-23'));

DicomLattice = dicominfo(strcat(patient_dir,'\STR_Lattice_767-23_30-06-23'));

%try to get infos about the ROI, dose and grid
contour = dicomContours(DicomRS); %ROI extracted from the DicomData

%plot the ROI selected

%target (gross tumor volume)
ROI_list = ["GTV", "mask", "PTV parete torac"];
plot_dicom_multi_ROI(contour,ROI_list);


%importing the lattice file
lattice_contour = dicomContours(DicomLattice); %structures of the lattice Dicom
plot_dicom_ROI(lattice_contour,'Lung_R');
