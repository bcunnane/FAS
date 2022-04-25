function show_fas_colormaps(D)
% displays 3x6 montage of Fiber Aligned strain and strain rate as 
% colormap overlaid on magnitude images

figure
tiledlayout(1,2,'TileSpacing','compact');
for s = 1:2
    % determine strain or strain rate
    if s == 1
        plot_title = 'Strain';
        color_limits = [-0.3 0.3];
    elseif s == 2
        plot_title = 'Strain Rate';
        color_limits = [-500 500];
    end
    
    % get fiber aligned strain colormaps as tile image
    fas = [];
    mask = [];
    mag = [];
    for n = 1:3
        % get FAS images
        for v = [3 2 1]
            fas = cat(3,fas,squeeze(D(n).Evv{s,v}(:,:,D(n).peak_fr)));
        end
        
        % get mask & magnitude images
        mask = cat(3,mask,repmat(D(n).mg(:,:,D(n).peak_fr),[1,3]));
        mag = cat(3,mag,repmat(D(n).m(:,:,D(n).peak_fr),[1,3]));
    end
    
    % convert to image tiles
    fas = imtile(fas,'GridSize', [3 3]);
    mask = imtile(mask,'GridSize', [3 1]);
    mag = imtile(mag,'GridSize', [3 1]);
    mag = repmat(mag,[1,1,3]); % convert to RGB image
    
    % display magnitude image as background
    nexttile
    imshow(mag,[])
    hold on
    
    % overlay FAS colormap
    h = imshow(fas,[]);
    h.AlphaData = mask;
    colormap('jet')
    colorbar
    set(gca,'visible','off')
    caxis(color_limits)
    title(plot_title)
    
end
sgtitle([D(1).age,' ',D(1).name(1:end-7)])

end