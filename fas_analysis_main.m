%% FAS analysis main
%   main script for fiber aligned strain & strain rate analysis

%load('Results.mat')

for n = 1:length(Data)
    ev_colormaps(Data(n).dti_vec, char(Data(n).MVC))
end

%% functions
function ev_colormaps(ev_data, pct_MVC)
% creates & saves DTI eigen vector (ev) colormaps in current directory
% expects ev_data matrix as [pix, pix, slices, 3 vectors, 3 directions]

% re-arrange eigen vector data
all_evs=[];
for k = 1:3
    ev = squeeze(ev_data(:,:,:,:,k)); % select only 1 ev
    ev = permute(ev,[1,2,4,3]); % swap slice & ev locations in matrix
    ev = ev(:,:,[1,3,2],:); % reorder ev directions from xyz to xzy
    ev = abs(ev);
    
    all_evs = cat(4,all_evs,ev); % compile all slices into 1 matrix
end

% display colormaps with thumbnails as original image size
montage(all_evs, 'ThumbnailSize', [])

% add text labels
dirs = 'XZY';
npix = size(all_evs, 1);
for i = 1:3
    for j = 1:3
        x = npix .* [0:2] + 3;
        y = npix .* [1:3] - 9;
        ev_name = ['ev',num2str(j),'  ',dirs(i)];
        text(x(i), y(j), ev_name, 'Color', 'w')
    end
end
text(3,12,[pct_MVC,'% MVC'], 'Color', 'w')

% save figure
filename = [pct_MVC,'% MVC colormaps.png'];
exportgraphics(gcf, filename)
close
end