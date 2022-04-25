%% Manager: FAS Processing
% manages the processing of raw FAS data inputs
%% Process data file
% selected slice is always #2 as it is in the center of the volume

% .name = subject & MVC
% .age = young or senior
% .m = VEPC magnitude image
% .vx = VEPC x velocity in image frame coords
% .vy = VEPX y velocity in image frame coords
% .dti = DTI eigenvectors in image frame coords
% .T = (1) strain tensor, L (2) strain rate tensor, SR
% .EV = (1) strain eigenvector (2) strain rate eigenvector
% .mg = MG muscle masks for all frames
% .sol = Soleus muscle masks for all frames
% .roi = square 7x7 ROI in MG muscle masks for all frames

files = dir('*.mat');
[~,age,~] = fileparts(pwd);
for n = 2%:length(files)
    
    % process data files
    load(files(n).name)
    for p = 1:3
        temp(p).name = [files(n).name(1:end-4),' ',Data(p).MVC{:},'%MVC'];
        temp(p).age = age;
        temp(p).m = squeeze(Data(p).m(:,:,2,:));
        temp(p).vx = squeeze(Data(p).vz_sm(:,:,2,:));
        temp(p).vy = squeeze(Data(p).vx_sm(:,:,2,:));
        temp(p).dti = squeeze(Data(1).dti_vec(:,:,2,:,:));
        temp(p).T = {squeeze(Data(p).strain.L); squeeze(Data(p).strain.SR)};
        temp(p).EV = {squeeze(Data(p).strain.L_vector); squeeze(Data(p).strain.SR_vector)};
    end
    
    % get masks
    disp('Identify MG muscle')
    temp(1).mg = get_adaptive_masks(temp(1).m, temp(1).vx, temp(1).vy,'p');
    disp('Identify Sol muscle')
    temp(1).sol = get_adaptive_masks(temp(1).m, temp(1).vx, temp(1).vy,'p');
    disp('Identify ROI')
    temp(1).roi = get_adaptive_masks(temp(1).m, temp(1).vx, temp(1).vy,'s');
    
    temp(2).mg = temp(1).mg;
    temp(2).sol = temp(1).sol;
    temp(2).roi = temp(1).roi;
    temp(3).mg = temp(1).mg;
    temp(3).sol = temp(1).sol;
    temp(3).roi = temp(1).roi;
    
    % append temp file to main data file
    data = [data; temp];
end

