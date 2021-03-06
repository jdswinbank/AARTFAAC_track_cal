% Script to generate plots of the residual phase between calibrated and model visibility
% as functions of visibility power, bline length etc.
% Works using data internal to a calibration routine.
% pep/03Feb14

fid = fopen ('~/WORK/AARTFAAC/Reobs/11Jul12/LBA_OUTER_BAND_SPREAD/SB002_LBA_OUTER_SPREAD_1ch.bin', 'rb');
[acc, tacc, freq] = readms2float (fid, -1, -1, 288);
flagant = [51, 239, 273];

dbstop in pelican_sunAteamsub.m at 354 %%%% NOTE: Script does not go further than this!
sol = pelican_sunAteamsub (acc, tacc, freq, eye(288), flagant, 4, 1, [], [], 'poslocal_outer.mat');

%%%%%%%%%%% Within program trace %%%%%%%%%%%%
% We work only on upper triangles to remove artificial symmetry in plotted parameters.
triumask = triu (ones (length (acc)),1);
uacccal = acccal (triumask == 1); % Calibrated visibility upper triangle
uRAteam = RAteam (triumask == 1); % Model visibility upper triangle
uaccres = uacccal - uRAteam;      % Residual visibility upper triangle
uuvdist = calim.uvdist (triumask == 1);  % baseline length upper triangle

% Residual visibility
% urespwr = abs (uaccres);
% uresph = angle (uaccres);

% What about 
urespwr = abs(uacccal) - abs(uRAteam);
uresph = angle (uacccal) - angle (uRAteam);
% Limit phases to values between -pi and pi
phwrapmask = uresph > pi;
uresph (phwrapmask == 1) = uresph(phwrapmask == 1) - 2*pi; % All values >pi
phwrapmask = uresph < -pi;
uresph (phwrapmask == 1) = uresph(phwrapmask == 1) + 2*pi; % All values >pi

% To sort based on residual visibility power
[sortrespwr, sortrespwrind] = sort (urespwr(:), 1, 'ascend');

% To sort based on calibrated visibility power
[sortcalpwr, sortcalpwrind] = sort (uacccal(:), 1, 'ascend');

% To sort based on baseline length 
[sortbline, sortblineind] = sort (uuvdist(:), 1, 'ascend');

%%%%%%%%%% Residual visibility plots
% Plot Residual visiblity power as a function of increasing residual visibility power.
figure;
subplot (211); plot (urespwr (sortrespwrind), '.'); ylabel ('Residual visibility power');
subplot (212); plot (uresph  (sortrespwrind), '.'); ylabel ('Residual visibility phase');
xlabel ('Visibility (inc. residual visibility power)');
samexaxis ('join', 'YLabelDistance', 1.0);
p = mtit ('Calibrated - model visibility amp/ph, as func. of residual vis. power');

% Plot Residual visiblity power as a function of increasing calibrated visibility power.
figure;
subplot (211); plot (urespwr (sortcalpwrind), '.'); ylabel ('Residual visibility power');
subplot (212); plot (uresph  (sortcalpwrind), '.'); ylabel ('Residual visibility phase');
xlabel ('Visibility (inc. calibrated visibility power)');
samexaxis ('join', 'YLabelDistance', 1.0);
p = mtit ('Calibrated - model visibility amp/ph, as func. of calib. vis. power');

% Plot Residual visiblity power as a function of increasing baseline length.
figure;
subplot (211); plot (urespwr (sortblineind), '.'); ylabel ('Residual visibility power');
subplot (212); plot (uresph  (sortblineind), '.'); ylabel ('Residual visibility phase');
xlabel ('Visibility (inc. baseline length)');
samexaxis ('join', 'YLabelDistance', 1.0);
p = mtit ('Calibrated - model visibility amp/ph, as func. of baseline length.');

% Generate plot of just residual phase as a function of inc. bline length for paper.
figure;
plot (uuvdist (sortblineind), uresph  (sortblineind), '.'); ylabel ('Residual visibility phase (rad)');
xlabel ('Visibility length (m)');
title ('Residual visibility phase after model subtraction on a single timeslice');

% Generate plot of just residual phase as a function of inc. cal. vis. power for paper
figure;
plot (uresph  (sortcalpwrind), '.'); ylabel ('Residual visibility phase (rad)');
xlabel ('Calibrated visibility power (arbit.)');
title ('Residual visibility phase, ~60 MHz');
axis tight; grid on;
set(gca,'FontSize', 16,'fontWeight','bold')
set(findall(gcf,'type','text'),'FontSize', 16, 'fontWeight','bold')
print ('selfcal_ph_behaviour_new.eps', '-depsc', '-r300');
