function masks = get_adaptive_masks(images, vx, vy, type)
% prompts user to draw region of interest (ROI) on first image frame
% tracks ROI motion over subsequent frames
% returns matrix of mask of each ROI for each frame
% type (p) polygone ROI (s) 7x7 square ROI

% initialize
RES = 1.1719;
START_FRAME = 1;

npix = size(vx,1);
num_frames = size(vx,3);
dt = ones(num_frames-1,1)*0.136;

% get ROI on first frame
if type == 'p'
    figure('Name','Draw Polygon ROI','NumberTitle','off')
    imshow(images(:,:,1),[])
    polygon = drawpolygon();
    roi = polygon.Position;
    %roi = [roi;roi(1,:)]; %close roi by including first point again
elseif type == 's'
    figure('Name','Select top left corner of 7x7 square ROI','NumberTitle','off')
    imshow(images(:,:,1),[])
    roi = ginput(1);
    roi(2,:) = roi(1,:) + [7 0];
    roi(3,:) = roi(1,:) + [7 7];
    roi(4,:) = roi(1,:) + [0 7];
end
close

% track ROI motion and get ROIs xs and ys for each image frame
[xs, ys]= track2dv4(roi(:,1),roi(:,2),vx,vy,dt,RES,START_FRAME);

% reshape ROIs into single matrix [x, y, fr]
for fr = num_frames:-1:1
    rois(:,1,fr) = xs(:,fr);
    rois(:,2,fr) = ys(:,fr);
end

% create masks from ROIs
for fr = num_frames:-1:1
    masks(:,:,fr) = poly2mask(rois(:,1,fr), rois(:,2,fr), npix, npix);
end

end
