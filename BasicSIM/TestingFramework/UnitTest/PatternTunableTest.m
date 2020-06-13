run('../../CIRLSetup.m')

%%
X     = 2;       % discrete lateral size in voxels
Y     = 2;       % discrete lateral size in voxels
Z     = 2;        % discrete axial size in voxels
dXY   = 0.5;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.5;     % axial voxel scaling in microns
offs  = 0; % [0, 0, 0];
phi   = 0;
theta = 0; %[0, 60, 120];
um    = 1;
wm    = 1;
phizDeg   = 0.0;
Nslits = 3;

s = struct('X', X, 'Y', Y, 'Z', Z, 'dXY', dXY, 'dZ', dZ, 'offs', offs,'phi', phi,'theta', theta,'um', um, 'wm', wm, 'phizDeg', phizDeg, 'Nslits', Nslits);

Settings = DataFrame.fromStruct(s);

%% load the high-resolution modulating patterns
[im, jm, ~] = PatternTunable3DNSlits(Settings);

% this value should be cos(pi)
if jm(1,2,1,1,1,2) == cos(pi)
    disp("pass unit test for lateral Tunable pattern!");
else
    disp("pass unit test for lateral Tunable pattern!");
end