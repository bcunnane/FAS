%% FAS analysis main
%   main script for fiber aligned strain & strain rate analysis
%load('Results.mat')

%% Strain (St) & Strain Rate (SR) colormaps

% generate colormaps
source = 'SR'; %strain data source
ev_labels = ["x1","x2","x3";"y1","y2","y3";"z1","z2","z3"];
for n = 1%:length(Data)
    % trim ev matrix
    data = squeeze(Data(n).strain.SR_vector); % change strain data source
    
    % create colormaps
    num_frs = size(data,3);
    pct_mvc = char(Data(n).MVC);
    for fr = 1:num_frs
        name = sprintf('%s %s%% MVC Frame %d of %d', source, pct_mvc, fr, num_frs);
        ev_colormap(squeeze(data(:,:,fr,:,:)), ev_labels, name)
    end
end

% organize images
mkdir(source)
movefile('*.png',source)

%% functions
function ev_colormap(evs, labels, name)
% expects eigenvectors (evs) matrix as [pix, pix, 3 vectors, 3 directions]
% assumes eigen vector matrix is:
%   x1   x2   x3
%   y1   y2   y3
%   z1   z2   z3
% but montage function plots as:
%   1    2    3
%   4    5    6
%   7    8    9
% ev order is therefore altered so that the montage image matches the ev 
% matrix convention

% plot colormap montage
evs = abs(evs(:,:,:));
evs = evs(:,:,[1 4 7 2 5 8 3 6 9]); % change ev order so montage matches matrix
montage(evs, 'ThumbnailSize', [])
colormap('jet')
colorbar

% add text labels
npix = size(evs, 1);
x = npix .* [0:2] + 3;
y = npix .* [1:3] - 9;
x = x([1 1 1 2 2 2 3 3 3]);
y = y([1 2 3 1 2 3 1 2 3]);
labels = labels(:);
for k = 1:9
    text(x(k), y(k), labels(k), 'Color', 'w')
end
title(name)

% save figure
filename = [name,'.png'];
exportgraphics(gcf, filename)
close

end