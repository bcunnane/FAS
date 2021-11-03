function show_fas_colormaps(fas, mags, masks)
% displays strain with colormap over magnitude images
% displayed as 3x6 montage

% rearange data as tiles instead of frames
fas = imtile(fas,'GridSize', [3 6]);
mags = imtile(mags,'GridSize', [3 6]);
masks = imtile(masks,'GridSize', [3 6]);

% display background image as rgb
mags_rgb = repmat(mags,[1,1,3]);
imshow(mags_rgb)
set(gca,'visible','off')
hold on

% display foreground image with colormap
h = imshow(fas,[]);
h.AlphaData = masks;
colormap('jet')
colorbar
set(gca,'visible','off')

end