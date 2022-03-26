function Plot3D_Model(Title,height,radius)

figure('Name', Title, 'color', 'white','NumberTitle','off');
for g = 0:1:2*radius+1
for i = 0:1:height
   gridplot1 = plot3([g g], [0 2*radius+1], [i, i], 'Color', [0.5 0.5 1], 'LineWidth', 0.1, 'LineStyle','-');
   hold on
end
end

for g = 0:1:2*radius+1
for i = 0:1:height
   gridplot2 = plot3([0 2*radius+1], [g g], [i, i], 'Color', [0.5 0.5 1], 'LineWidth', 0.1, 'LineStyle','-');
   hold on
end
end

for g1 = 0:1:2*radius+1
for g2 = 0:1:2*radius+1
   gridplot3 = plot3([g1 g1], [g2 g2], [0 height], 'Color', [0.5 0.5 1], 'LineWidth', 0.1, 'LineStyle','-'); 
   hold on
end
end

[Xc,Yc,Zc] = cylinder(radius);
Zc(2, :) = height;
silinder = mesh(Xc+radius+0.5,Yc+radius+0.5,Zc,'FaceColor',[1 0.25 0],'FaceAlpha',0.3 ,'EdgeColor','none');

daspect([1 1 1]);
view(3), axis vis3d
camproj perspective, rotate3d on
end