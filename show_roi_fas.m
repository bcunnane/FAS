function show_ave_fas(aves, errs, mag_ims, masks, plot_name)
% creates plots of average strain in ROI with standard dev error bars
% also shows the ROI on the magnitude image for the first frame

figure('Position',[560 50 840 630])
sgtitle([plot_name,' ave in ROI'])

if contains(plot_name,'L ')
    y_label = 'Strain';
    y_limits = [-0.2 0.4];
elseif contains(plot_name,'SR')
    y_label = 'Strain Rate';
    y_limits = [-1000 1000];
end

% strain plots
for v = 1:3
    subplot(2,2,v)
    errorbar(aves{v},errs{v},'o')
    title(['Proj on EV',num2str(v)])
    xlabel('Frame #')
    
    ylabel(y_label)
    ylim(y_limits)
end

% ROI
im = mag_ims(:,:,1);
mask = masks(:,:,1);
im(mask) = max(im(:));
subplot(2,2,4)
imshow(im,[])


end
