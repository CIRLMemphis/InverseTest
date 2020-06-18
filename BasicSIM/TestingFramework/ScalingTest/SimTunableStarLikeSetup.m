[ psfpar, psfpari ] = PSFConfigNoAber();
X     = 256;       % discrete lateral size in voxels
Y     = 256;       % discrete lateral size in voxels
Z     = 256;        % discrete axial size in voxels
dXY   = 0.04;     % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.04;     % axial voxel scaling in microns
uc    = 2*psfpar.NA/psfpari.v(1);   % cycle/um
offs  = [0, 0, 0];                  % offset from the standard values of phi
phi   = [0, 1, 2]*(2*180)/3;        % lateral phase
theta = [0, 60, 120];               % orientation
um    = [0.8, 0.8, 0.8]*uc;         % lateral modulating frequency
x0    = 0.326;  % in mm
fL1   = 100;    % in mm
fL2   = 250;    % in mm
fMO   = 160/63;
wm    = ((x0*fL2)/(2*fL1*fMO))*um;  % axial modulating frequency
phizDeg   = 153.0;                   % axial phase
Nslits    = 3;


s = struct('X', X, 'Y', Y, 'Z', Z, 'dXY', dXY, 'dZ', dZ, 'uc', uc, 'offs', offs,'phi', phi,'theta', theta,'um', um,'x0',x0, 'fL1', fL1, 'fL2', fL2, 'fMO', fMO, 'wm', wm, 'phizDeg', phizDeg, 'Nslits', Nslits);

Settings = DataFrame.fromStruct(s);

%% get the pattern and check
zBF = 1 + Z/2;
%p  = psfpar.initialize(psfpar, 'Vectorial', 200);
%h  = PSFLutz(X, Z, dXY, dZ, p);
h  = PSFAgard( Settings );
[im, jm, ~] = PatternTunable3DNSlits(Settings);
vz = squeeze(im(1+Y/2,1+X/2,:,1,1,2));
vz = vz./max(vz(:));
hz = squeeze(h (1+Y/2,1+X/2,:));
hz = hz./max(hz(:));
figure;  plot(vz, 'DisplayName', 'v(z)'); 
hold on; plot(hz, 'DisplayName', 'h(z)'); 
xlabel('z'); ylabel('value');

jm2 = squeeze(jm(1+Y/2,:,zBF,1,1,2));
figure;  plot(jm2, 'DisplayName', 'jm(2)'); 
xlabel('x'); ylabel('value');