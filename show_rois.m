function show_rois(mags, rois)
%SHOW_ROIS displays ROIs on each magnitude image frame in mags
% expects [m, n, frame] for mags and [x, y, frame] for rois
% displays montage of mags ROI as white area

masks = roi_to_mask(rois, size(mags,1));
mags(masks) = max(mags(:));
mags = imtile(mags, 'GridSize', [3 6]);
imshow(mags,[])

end