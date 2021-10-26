function [roi_aves, roi_stds] = get_ave_fas(Evv, masks)
% computes average and standard dev fiber aligned strain in ROI region

% get mean and std data
for fr = size(Evv,3):-1:1
    % get ROI data
    mask_frame = masks(:,:,fr);
    Evv_frame = Evv(:,:,fr);
    roi_data = Evv_frame(mask_frame);
        
    % calculate mean and std
    roi_aves(fr) = mean(roi_data);
    roi_stds(fr) = std(roi_data);
end

end