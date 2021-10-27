function show_fas_colormaps(fas, masks)
% shows images in a 3x6 montage

% rearange data as tiles instead of frames
fas = imtile(fas,'GridSize', [3 6]);
masks = imtile(masks,'GridSize', [3 6]);

% show fas data with colormap and make outside of mask transparent
fas = fas .* masks;
h_fas = imagesc(fas);
h_fas.AlphaData = masks;
colormap('jet')
colorbar
set(gca,'visible','off')

end