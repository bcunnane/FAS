function roi = get_roi(image)
% returns ROI coordinates as [x, y]
imshow(image,[])
polygon = drawpolygon();
roi = polygon.Position;
roi = [roi;roi(1,:)]; %close roi by including first point again
close all
end