function show_strain_ev_colormaps(ev, mag_ims, masks)
% returns matrix of strain colormap data in mask region on magnitude images
% cmap matrix is [mpix npix rgb frames]

% arrange ev data into colormap format
ev = permute(ev,[1,2,4,3]); % [pix pix rgb frames]
ev = ev(:,:,[3 1 2],:); %set rgb to zxy
ev = abs(ev);

% remove masks from magnitude images
mag_ims(masks) = 0;

% convert magnitude and mask images to rgb format
for fr = size(mag_ims,3):-1:1
    rgb_ims(:,:,:,fr) = repmat(mag_ims(:,:,fr),[1 1 3]);
    rgb_masks(:,:,:,fr) = repmat(masks(:,:,fr),[1 1 3]);
end

% add ev colormap data to magnitude images
cmaps = rgb_ims + (ev .* rgb_masks);
montage(cmaps, 'Size',[3 6], 'ThumbnailSize',[])

end