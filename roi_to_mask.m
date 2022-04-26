function masks = roi_to_mask(rois, n)
% ROI_TO_MASK converts multipage ROI to multipage mask
%   input ROI of [x, y, frame] and nxn desired matrix size in # of pixels
%   returns mask of [nxn, nxn, frame]

for fr = size(rois, 3):-1:1
    masks(:,:,fr) = poly2mask(rois(:,1,fr), rois(:,2,fr), n, n);
end

end