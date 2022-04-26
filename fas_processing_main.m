%% Manager: FAS Processing
% manages the processing of raw FAS data inputs
% expects current directory to contain strain tensor data files
%% Process data file
% selected slice is always #2 as it is in the center of the volume

% .name = subject & MVC
% .age = young or senior
% .m = VEPC magnitude image
% .dti = DTI eigenvectors in image frame coords
% .str = (1) strain tensor, L (2) strain rate tensor, SR
% .mg = MG muscle roi for all frames
% .sq = square 7x7 ROI in MG muscle for all frames

k = -2:0;
files = dir('19*.mat');
[~,age,~] = fileparts(pwd);
for n = length(files):-1:1
    
    % get overall subject data
    load(files(n).name)
    disp('Identify MG muscle outline')
    mg = get_roi(Data(1).m(:,:,1),'p');
    disp('Identify square ROI in MG')
    sq = get_roi(Data(1).m(:,:,1),'s');
    
    % get MVC specific data
    for p = [3 2 1]
        data(3*n+k(p)).name = [files(n).name(1:end-4),' ',Data(p).MVC{:},'%MVC'];
        data(3*n+k(p)).age = age;
        data(3*n+k(p)).m = squeeze(Data(p).m(:,:,2,:));
        data(3*n+k(p)).dti = squeeze(Data(1).dti_vec(:,:,2,:,:));
        data(3*n+k(p)).str = {squeeze(Data(p).strain.L); squeeze(Data(p).strain.SR)};
        data(3*n+k(p)).mg = track_roi(mg, squeeze(Data(p).vx_sm(:,:,2,:)), squeeze(Data(p).vz_sm(:,:,2,:)));
        data(3*n+k(p)).sq = track_roi(sq, squeeze(Data(p).vx_sm(:,:,2,:)), squeeze(Data(p).vz_sm(:,:,2,:)));
    end
    clear 'Data'
end

