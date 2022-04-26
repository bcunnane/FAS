function [roi_aves, roi_stds] = get_roi_fas(Evv, rois)
% computes average and standard dev fiber aligned strain in ROI region

masks = roi_to_mask(rois, size(Evv,1));

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