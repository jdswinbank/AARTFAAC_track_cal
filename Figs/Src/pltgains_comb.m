% Script to plot the estimated gains from a format generated by pltcalsol.m
% pep/29Nov13

% fname = '../Data/SB002_LBA_OUTER_SPREAD_1ch_8_convcalsol.bin.gains';
fname = '../Data/combined_SB002_2_convcalsol.bin.gains';
gtseries = load (fname);
t_first = gtseries(1,1);
num = mjdsec2datenum (t_first);
%% col = {'b*', 'm*', 'r*', 'k*', 'g*', 'y*', 'w*', 'c*'};
col = {'b*', 'mx', 'r+', 'ks', 'gd', 'yv', 'w^', 'c<'};


subplot (211);
antoff=23;
colind = 1;
xrng = [1:size(gtseries, 1)];
% NOTE: Dawn data has one whole station missing! Hence the -96
for ant=2:96:576-96 % Plot only one antenna per station
% for ant=2:96:576 % Plot only one antenna per station
	%%%% USE THIS plot command ONLY FOR DAWN DATA
	plot (gtseries (xrng,(antoff+ant)), char(col(colind)));
	% plot ((gtseries (:,1)-t_first)/86400.+num, gtseries (:,(antoff+ant)), char(col(colind)));
	hold on;
	colind = colind + 1;
	fprintf (1, 'Ant: %d, mean ph: %f, var phase: %f\n', ant, mean(gtseries(:,(antoff+ant))), std (gtseries (:, (antoff+ant))));
end;
xlabel (sprintf ('UTC past %s, 00:00:00', datestr(num, 1))); ylabel ('Phase (rad)');
axis tight; grid on;

% Comment for dawn time data.
% datetick ('x', 13, 'keepticks'); % Print HH:MM:SS legend on the time axis.
set(gca,'FontSize', 16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize', 16, 'fontWeight','bold')

subplot (212);
colind = 1;
% NOTE: Dawn data has one whole station missing! Hence the -96
for ant=3:96:576-96 % Plot only one antenna per station
% for ant=3:96:576 % Plot only one antenna per station
	%%%% USE THIS plot command ONLY FOR DAWN DATA
	plot (gtseries (xrng,(antoff+ant)), char(col(colind)));
	% plot ((gtseries (:,1)-t_first)/86400.+num, gtseries (:,(antoff+ant)), char(col(colind)));
	hold on;
	fprintf (1, 'Ant: %d, mean gain: %f, var gain: %f\n', ant, mean(gtseries(:,(antoff+ant))), std (gtseries (:, (antoff+ant))));
	colind = colind + 1;
end;
%%% USE THIS axis setting ONLY FOR DAWN DATA
% NOTE: Removed the first minute data due to an inconsistent phase, pep/19Dec13
set (gca, 'XTick', [101, 201, 301, 401, 501, 601, 701]);
set (gca, 'XTickLabel', {'03:43', '03:52', '04:01', '04:06', '04:15', '04:28', '04:34'});

% set (gca, 'XTick', [101, 201, 301, 401, 501, 601, 701, 801]);
% set (gca, 'XTickLabel', {'03:34:16', '03:43:11', '03:52:10', '04:01:13', '04:06:29', '04:15:30', '04:28:58', '04:34:21'});
xlabel (sprintf ('UTC past %s, 00:00:00', datestr(num, 1))); ylabel ('Amplitude (arbit)');
axis tight; grid on;

% Comment datetick for dawn time data
% datetick ('x', 13, 'keepticks'); % Print HH:MM:SS legend on the time axis.

samexaxis ('join');
p=mtit('Estimated gain phase and amplitude.  ',...
	   'xoff',-.07,'yoff',.015);
set(gca,'FontSize', 16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize', 16, 'fontWeight','bold')
[pathstr, name, ext] = fileparts (fname);	

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2.5 2.5 10 10]); % last 2 are width/height.

% print('-depsc2', '-painters', plotfname_eps);

print (gcf, strcat (strrep (strcat (name, ext), '.', '_'), '.eps'), '-depsc', '-r300'); 
% print (gcf, '../SB002_LBA_OUTER_SPREAD_1ch_8_convcalsol.bin.gains.png', '-dpng');
