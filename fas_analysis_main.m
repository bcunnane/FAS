%% FAS analysis main
% main script for fiber aligned strain & strain rate analysis
%   each struct entry is a subject with % mvc; loop cycles through n
%   each %MVC has strain (1) & strain rate (2); loop cycles through s
%   there are 3 DTI eigenvectors; loop cycles through v
%   there are 17 frames; loop cycles through fr

%% get fiber aligned strain (FAS)
for n = length(data):-1:1
    for s = 2:-1:1
        for v = 3:-1:1
            dti = squeeze(data(n).dti(:,:,:,v));
            for fr = 17:-1:1
                T = squeeze(data(n).T{s}(:,:,fr,:,:));
                Evv(:,:,fr) = get_fas(T, dti);
            end
            data(n).Evv{s,v} = Evv;
        end
    end
end

%% get average & std FAS in ROI
data_order = [1 2 3; 4 5 6];
for n = length(data):-1:1
    for s = 2:-1:1
        for v = 3:-1:1
            % calculate average & std FAS in ROI
            [Evv_aves, Evv_stds] = get_roi_fas(data(n).Evv{s,v}, data(n).roi);
            data(n).Evv_aves{s,v} = Evv_aves;
            data(n).Evv_stds{s,v} = Evv_stds;
            
            % identify frame of peak strain projection on DTI principal ev
            if s == 1 && v == 3
                [~,data(n).peak_fr] = max(abs(Evv_aves));
            end
            all_Evv_aves(:,data_order(s,v),n) = Evv_aves;
        end
    end
end

%% display results
for n = 1%:3:length(data)
    show_roi_fas(data(n:n+2))
    show_fas_colormaps(data(n:n+2))
end

%% create table
