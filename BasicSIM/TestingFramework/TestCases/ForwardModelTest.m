run('../../CIRLSetup.m')

%% Simulated settings
[ psfpar, psfpari ] = PSFConfigNoAber();
X     = 100;       % discrete lateral size in voxels
Y     = 100;       % discrete lateral size in voxels
Z     = 100;        % discrete axial size in voxels
dXY   = 0.025;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.025;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);  % cycle/um
offs  = 0; % [0, 0, 0];
phi   = [0, 1, 2]*(2*180)/3;
theta = 0; %[0, 60, 120];
um    = 0.8*uc; %[0.8, 0.8, 0.8]*uc;
x0    = 0.326;  % in mm
fL1   = 100;  % in mm
fL2   = 250;  % in mm
fMO   = 160/63;
wm    = ((x0*fL2)/(2*fL1*fMO))*um;
phizDeg   = 46.0;
Nslits = 3;

s = struct('X', X, 'Y', Y, 'Z', Z, 'dXY', dXY, 'dZ', dZ, 'uc', uc, 'offs', offs,'phi', phi,'theta', theta,'um', um,'x0',x0, 'fL1', fL1, 'fL2', fL2, 'fMO', fMO, 'wm', wm, 'phizDeg', phizDeg, 'Nslits', Nslits);

Settings = DataFrame.fromStruct(s);

%% construct the high-resolution point-spread function (PSF)
h  = PSFAgard(Settings);

%% load the high-resolution modulating patterns
[im, jm, ~] = PatternTunable3DNSlits(Settings);

%% obtain the object to test, which is a bead
Radius    = 2/2;
Thickness = 1/2;
Object    = SphericalShell(Settings, Radius, Thickness);

%% Using ForwardModel to get the raw data
g   = ForwardModel(Object, h, im, jm);
g11 = g(:,:,:,1,1); % example of testing the first phase, first orientation raw data

%% using convolution to test the ForwardModel
gConv11 = convn(Object.*jm(:,:,:,1,1,1), h.*im(:,:,:,1,1,1), 'same') +...
          convn(Object.*jm(:,:,:,1,1,2), h.*im(:,:,:,1,1,2), 'same');

%% check that g00 and gConv00 is the same (visually or computationally)
figure;
subplot(121); imagesc(g00(:,:,51)); axis square;
subplot(122); imagesc(gConv00(:,:,51)); axis square;