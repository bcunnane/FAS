%% FAS analysis main
%   main script for fiber aligned strain & strain rate analysis
% load('Results.mat')

pcts = ["60","40","30"];

%% get muscle ROI outlines
series = 3;

% mag_ims = squeeze(Data(series).m(:,:,2,:)); %first frame mag im for middle slice (#2)
% 
% disp('ID mg')
% mg_roi = get_roi(mag_ims(:,:,8));
% 
% disp('ID sol')
% sol_roi = get_roi(mag_ims(:,:,8));
%% Strain & strain rate Eigenvector (ev) colormaps
for v = 1
    % arrange ev data for plotting
    ev = squeeze(Data(series).strain.L_vector(:,:,:,:,:,v)); % select ev
    ev = permute(ev,[1,2,4,3]); % [pix pix rgb frames]
    ev = ev(:,:,[3 1 2],:); %set rgb to zxy
    ev = abs(ev);
    
    mg_cmaps = strain_ev_colormaps(ev, mg_roi, mag_ims);
    sol_cmaps = strain_ev_colormaps(ev, sol_roi, mag_ims);
    
    %display
    montage(mg_cmaps, 'Size',[3 6], 'ThumbnailSize',[])
    exportgraphics(gcf,['L MG ',char(pcts(series)),'% MVC EV',num2str(v),'.png'])
    close
    
    montage(sol_cmaps, 'Size',[3 6], 'ThumbnailSize',[])
    exportgraphics(gcf,['L SOL ',char(pcts(series)),'% MVC EV',num2str(v),'.png'])
    close
end
%% investigate force

% figure
% for series = 1:3
%     lambdas = squeeze(Data(series).strain.L_lambda);
%     lambdas = permute(lambdas,[1,2,4,3]);
%     lambdas = lambdas(:,:,[3 1 2],:);
%     
%     subplot(2,2,series)
%     force_plot(lambdas, mg_roi, Data(series).force)
%     title(['\color{white} MG ',char(pcts(series)),'% MVC'])
%     
% end

%% Functions
function cmaps = strain_ev_colormaps(ev,roi,mag_ims)

roi_mask = poly2mask(roi(:,1),roi(:,2),size(ev,1),size(ev,2));
leg_masks = logical(mag_ims);


for c = 1:3
    for fr = 1:17
        im = mag_ims(:,:,fr);
        im(roi_mask) = 0;
        im = im + ev(:,:,c,fr) .* roi_mask .* leg_masks(:,:,fr);
        cmaps(:,:,c,fr) = im;
    end
end

end


function force_plot(lambdas,roi,force)

% get strains
roi_mask = poly2mask(roi(:,1),roi(:,2),size(lambdas,1),size(lambdas,2));
for dim = 3:-1:1
    for fr = 17:-1:1
        data = squeeze(lambdas(:,:,dim,fr));
        strains(dim,fr) = mean(data(roi_mask));
    end
end
total_strain = dot(strains,strains).^(0.5);

yyaxis left
force = force(1:floor(600/16):end);
%plot(force,'--y')
plot(5:17,force(1:end-4),'--y')
ylim([-40 100])
ylabel('Force (N)')

yyaxis right
plot(1:17,strains(1,:),'-r',1:17,strains(2,:),'-g',1:17,strains(3,:),'-c',1:17,total_strain,'-w')
ylim([-.4 1])
ylabel('Strain')

xlabel('Frame #')
ax = gca;
ax.Color = 'k';
ax.XColor = 'w';
ax.YAxis(1).Color = 'w';
ax.YAxis(2).Color = 'w';
set(gcf,'Color','k')
legend('\color{yellow} force','\color{red} \epsilon_z','\color{green} \epsilon_x','\color{cyan} \epsilon_y','\color{white} \epsilon_a_l_l')
end


function animate(ims, name)
% creates animaged gif of rgb images (ims)
% assumes rgb image matrix is [pix, pix, rgb, frames]

dt = .15; %delay time
filename = [name, 'animation.gif'];

for f = 1:size(ims,4)
    im = ims(:,:,:,f);
    [im,map] = rgb2ind(im,256);
    
    % Write to the GIF File
    if f == 1
        imwrite(im,map,filename,'gif','Loopcount',inf);
    else
        imwrite(im,map,filename,'gif','WriteMode','append','DelayTime',dt);
    end
end

end

