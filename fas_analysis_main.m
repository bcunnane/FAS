%% FAS analysis main
% main script for fiber aligned strain & strain rate analysis
%   selected slice is always #2 as it is in the center of the volume
%   each main line is percent mvc; cycles through percent p
%   each strain subline is strain (1) or strain rate (2); cycles through s
%   there are 3 eigenvectors; cycles through v
%   there are 17 frames; cycles through fr

%% Startup
q(:,:,1) = 'L ';
q(:,:,2) = 'SR';

dti_vecs = squeeze(Data(1).dti_vec(:,:,2,:,:));

for p = 3:-1:1
    data(p).name = ['MG ',char(Data(p).MVC), '% MVC'];
    
    % setup image data
    data(p).mag = squeeze(Data(p).m(:,:,2,:));
    data(p).vx = squeeze(Data(p).vz(:,:,2,:));
    data(p).vy = squeeze(Data(p).vx(:,:,2,:));
    
    % get ROI's
    disp('Draw MG outline')
    data(p).mg_masks = get_adaptive_masks(data(p).mag, data(p).vx, data(p).vy);
    disp('Draw small square ROI outline in MG')
    data(p).roi_masks = get_adaptive_masks(data(p).mag, data(p).vx, data(p).vy);
    
    % get strain data
    data(p).tensors = {squeeze(Data(p).strain.L), squeeze(Data(p).strain.SR)};
    data(p).evs = {squeeze(Data(p).strain.L_vector), squeeze(Data(p).strain.SR_vector)};
end

%% strain and DTI eigenvector (ev) colormaps
% DTI colormaps, set rgb to zxy
% montage(abs(dti_vecs(:,:,[3 1 2],:)), 'Size',[1 3], 'ThumbnailSize',[])

% Strain Colormaps
% for p = 1:length(data)
%     for s = 1:2
%         ev = data(p).evs{s};
%         for v = 1:3
%             ev = squeeze(ev(:,:,:,:,v)); % select specific ev
%             show_strain_ev_colormaps(ev, data(p).mag, data(p).mg_masks);
%             exportgraphics(gcf,[data(p).name,' ',q(:,:,s),' EV',num2str(v),'.png'])
%             close
%         end
%     end
% end
%% get fiber aligned strain
for p = length(data):-1:1
    for s = 2:-1:1
        for v = 3:-1:1
            dti_v = squeeze(dti_vecs(:,:,:,v));
            for fr = 17:-1:1
                E = squeeze(data(p).tensors{s}(:,:,fr,:,:));
                Evv(:,:,fr) = get_fas(E, dti_v);
            end
            data(p).Evv{s,v} = Evv;
        end
    end
end

%% get average fas
for p = length(data):-1:1
    for s = 2:-1:1
        for v = 3:-1:1
            [Evv_aves, Evv_stds] = get_ave_fas(data(p).Evv{s,v}, data(p).roi_masks);
            data(p).Evv_aves{s,v} = Evv_aves;
            data(p).Evv_stds{s,v} = Evv_stds;
        end
    end
end

%% get peak average fas
for p = length(data):-1:1
    for s = 1
        [~,peak_frame] = max(data(p).Evv_aves{s,3});
        for v = 3:-1:1
            data(p).Evv_ave_peaks{s,v} = data(p).Evv_aves{s,v}(peak_frame);
        end
    end
end

%% show ave fas
for p = 2%1:length(data)
    for s = 1%1:2
        plot_name = [data(p).name, ' ',q(:,:,s)];
        show_ave_fas(data(p).Evv_aves(s,:), data(p).Evv_stds(s,:), data(p).mag, data(p).roi_masks, plot_name)
        %exportgraphics(gcf,[plot_name,' ave in ROI.png'])
    end
end

%% show fas colormaps
for p = 2%1:length(data)
    for s = 1%1:2
        if s == 1
            color_limits = [-0.3 0.3];
        elseif s == 2
            color_limits = [-500 500];
        end
        
        for v = 2%1:3
            show_fas_colormaps(data(p).Evv{s,v}, data(p).mag, data(p).mg_masks)
            plot_name = ['fiber aligned colormaps ',data(p).name,' ',q(:,:,s),' proj on EV',num2str(v)];
            caxis(color_limits)
%             exportgraphics(gcf,[plot_name,'.png'])
%             close
        end
    end
end
