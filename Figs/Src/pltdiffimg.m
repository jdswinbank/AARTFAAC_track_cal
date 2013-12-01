% Script to plot the difference image statistics
% pep/29Nov13
diffstat = load ('../Data/SB001_LBA_OUTER_SPREAD_1ch_1_convcal.bin.diffimg');

%% Column descriptions
%% Integtime rawpairmean rawpairstd diffpairmean diffpairstd sqrt(BT) accrawimgmean accrawimgstd accdiffimgmean accdiffimgstd
% NOTE: Normalizing with largest variance to match theoretical curve.
loglog (diffstat(:,1), diffstat(:,6), 'k-'); % Theoretical curve
hold on;
loglog (diffstat(:,1), diffstat(:,8), 'r*-'); % Raw image integrated std.
hold on;
loglog (diffstat(:,1), diffstat(:,10), 'b*-'); % Difference integrated image
grid;
title ('Noise region std Vs. integration time');
xlabel ('Integration time(secs)');
ylabel ('Normalized noise std.');
legend ('Theoretical thermal', 'Raw image', 'Difference Image');
set(gca,'FontSize', 16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize', 16, 'fontWeight','bold')
print (gcf, '../diffimg.png', '-dpng');