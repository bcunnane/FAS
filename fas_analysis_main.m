%% FAS analysis main
%   main script for fiber aligned strain & strain rate analysis

%load('Results.mat')

% cycle through eigenvector numbers, v
for v = 1:3
    
    % record strain data used
    strain_name = sprintf('SR_vector EV%d',v);
    
    % get masks for middle slice (#2)
    masks = squeeze(Data(1).mask(:,:,2,:));
    
    for fr = 17:-1:1
        % assumes eigen vector matrix is:
        %   x1   x2   x3
        %   y1   y2   y3
        %   z1   z2   z3
        
        % select single frame, fr, and desired eigenvector, v
        ev = squeeze(Data(1).strain.SR_vector(:,:,:,fr,:,v));
        
        % transform image frame coordinates to scanner frame coordinates
        ev = ev(:,:,[3 1 2]);
        
        ev = abs(ev);
        
        % apply mask to each color
        for c = 1:3
            ev(:,:,c) = ev(:,:,c) .* masks(:,:,fr);
        end
        
        % collect all colormap image frames into single matrix
        all_frs(:,:,:,fr) = ev;
        
    end
    
    %display and save colormaps images
    figure('Name',strain_name)
    montage(all_frs, 'Size',[3 6], 'ThumbnailSize',[])
    exportgraphics(gcf,[strain_name,'.png'])
    close
end
