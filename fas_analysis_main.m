%% FAS analysis main
% main script for fiber aligned strain & strain rate analysis
%   selected slice is always #2 as it is in the center of the volume 

series = 2;
pcts = ["60","40","30"];
mag_ims = squeeze(Data(series).m(:,:,2,:));
% mg_roi = get_roi(mag_ims(:,:,8));
mg_mask = poly2mask(mg_roi(:,1),mg_roi(:,2),256,256);

%% Strain & strain rate Eigenvector (ev) colormaps
for v = 1:3
    % arrange ev data for plotting
    ev = squeeze(Data(series).strain.SR_vector(:,:,:,:,:,v)); % select ev
    ev = permute(ev,[1,2,4,3]); % [pix pix rgb frames]
    ev = ev(:,:,[3 1 2],:); %set rgb to zxy
    ev = abs(ev);
    
    mg_cmaps = ev_colormaps(ev, mg_mask, mag_ims);
    
    %display
    montage(mg_cmaps, 'Size',[3 6], 'ThumbnailSize',[])
    exportgraphics(gcf,['SR MG ',char(pcts(series)),'% MVC EV',num2str(v),'.png'])
    close
end

%% fiber aligned strain
% change coordinates from xyz to zxy
L = change_tensor_coords(Data(series).strain.L);
SR = change_tensor_coords(Data(series).strain.SR);

% align to DTI fibers
v = 3;
dti_vec = squeeze(Data(series).dti_vec(:,:,2,:,v));
dti_vec = dti_vec(:,:,[3 1 2]);
for fr = 17:-1:1
    E(:,:,fr) = align_to_fibers(squeeze(L(:,:,fr,:,:)), dti_vec);
    E_mg(:,:,fr) = E(:,:,fr) .* mg_mask;
end

% for fr = 17:-1:1
%     subplot(3,6,fr)
%     edges = [-.5:.025:-.2];
%     histogram(E_mg(E_mg~=0),edges)
% end
%% Functions

function new_tensor = change_tensor_coords(old_tensor)

old_tensor = squeeze(old_tensor);
old_tensor = old_tensor(:,:,:,[9 7 8 3 1 2 6 4 5]); % set xyz to zxy
new_tensor = reshape(old_tensor,256,256,17,3,3);

end


function E = align_to_fibers(F,v)

FT = F(:,:,[1 4 7 2 5 8 3 6 9]); %transpose

% reshape for matrix multiplication
F = reshape(F,256*256,3,3);
F = permute(F,[2 3 1]);

FT = reshape(FT,256*256,3,3);
FT = permute(FT,[2 3 1]);

v = reshape(v,256*256,3,1);
v = permute(v,[2 3 1]);

% align strain in direction of vector
C = pagemtimes(FT,F);
Cv = pagemtimes(C,v);
E = .5 * (sum(v .* Cv) - 1);
E = reshape(E,256,256);

end


function cmaps = ev_colormaps(ev,roi_mask,mag_ims)

for c = 1:3
    for fr = size(mag_ims,3):-1:1
        im = mag_ims(:,:,fr);
        im(roi_mask) = 0;
        im = im + (ev(:,:,c,fr) .* roi_mask);
        cmaps(:,:,c,fr) = im;
    end
end

end
