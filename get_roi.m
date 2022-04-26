function roi = get_roi(images, type)
% prompts user to draw region of interest (ROI) on first image frame
% type is (p) polygone ROI or (s) 7x7 square ROI

if type == 'p'
    figure('Name','Draw Polygon ROI','NumberTitle','off')
    imshow(images(:,:,1),[])
    polygon = drawpolygon();
    roi = polygon.Position;
elseif type == 's'
    figure('Name','Select top left corner of 7x7 square ROI','NumberTitle','off')
    imshow(images(:,:,1),[])
    roi = ginput(1);
    roi(2,:) = roi(1,:) + [6 0];
    roi(3,:) = roi(1,:) + [6 6];
    roi(4,:) = roi(1,:) + [0 6];
end
close

end