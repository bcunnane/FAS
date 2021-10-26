function show_fas_colormaps(fas, mag_ims, masks)
% displays fiber aligned strain as green color in ROI on magnitude images

figure

% remove masks from magnitude images
mag_ims(masks) = 0;

% convert magnitude and mask images to rgb format
for fr = size(mag_ims,3):-1:1
    rgb_ims(:,:,:,fr) = repmat(mag_ims(:,:,fr),[1 1 3]);
end

% add FAS colormap data within mask as green color in rgb format
rgb_ims(:,:,2,:) = squeeze(rgb_ims(:,:,2,:)) + (fas .* masks);

% display colormaps
montage(rgb_ims, 'Size',[3 6], 'ThumbnailSize',[])

end