function show_roi_fas(D)
% creates plots of average strain in ROI with standard dev error bars

figure
tiledlayout(3,6,'TileSpacing','compact');

for n = 1:length(D)
    for s = 1:2
        % determine strain or strain rate
        if s==1
            y_label = 'Strain';
            y_limits = [-0.1 0.3];
        elseif s==2
            y_label = 'Strain Rate [s^-^1]';
            y_limits = [-750 750];
        end
        
        for v = [3 2 1]
            % create plot
            aves = D(n).Evv_aves{s,v};
            errs = D(n).Evv_stds{s,v};
            nexttile
            errorbar(aves,errs,'o')
            
            % annotate plot
            xlabel('Frame')
            ylim(y_limits)
            if v == 3
                ylabel([D(n).name(end-5:end), newline, y_label])
            else
                ylabel(y_label)
            end            
            if n == 1
                title(['proj on EV',num2str(v)])
            end
        end
    end
end
sgtitle([D(1).age,' ',D(1).name(1:end-7)])

end