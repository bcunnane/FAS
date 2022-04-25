%% strain and DTI eigenvector (ev) colormaps
% DTI colormaps, set rgb to zxy
% montage(abs(dti_vecs(:,:,[3 1 2],:)), 'Size',[1 3], 'ThumbnailSize',[])

% Strain Colormaps
for p = 3%1:length(data)
    for s = 1%:2
        ev = data(p).evs{s};
        for v = 1%:3
            ev_v = squeeze(ev(:,:,:,:,v)); % select specific ev
            show_strain_ev_colormaps(ev_v, data(p).mag, data(p).mg_masks);
%             exportgraphics(gcf,['senior ',data(p).name,' ',q(:,:,s),'strain EV',num2str(v),'.png'])
%             close
        end
    end
end