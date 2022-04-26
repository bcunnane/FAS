function rois = track_roi(roi, vx, vy)
%TRACK_ROI tracks motion of first-frame ROI over subsequent frames
%   assumes input ROI is for first frame and is [x,y]
%   returns ROIs matrix of [x, y, frame]

% initialize
RES = 1.1719;
START_FRAME = 1;

num_frames = size(vx,3);
dt = ones(num_frames-1,1)*0.136;

% track ROI motion and get ROIs xs and ys for each image frame
[xs, ys]= track2dv4(roi(:,1),roi(:,2),vx,vy,dt,RES,START_FRAME);

% reshape ROIs into single matrix [x, y, fr]
for fr = num_frames:-1:1
    rois(:,1,fr) = xs(:,fr);
    rois(:,2,fr) = ys(:,fr);
end

end