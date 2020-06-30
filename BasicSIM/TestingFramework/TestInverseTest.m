run('CIRLSetup.m')

[ psfpar, psfpari ] = PSFConfigNoAber();
X     = 200;                        % discrete lateral size in voxels
Y     = 200;                        % discrete lateral size in voxels
Z     = 200;                        % discrete axial size in voxels
dXY   = 0.025;                      % lateral voxel scaling in microns ---- for 20X lens (6.4/20)....for 60X lens (6.4/63)
dZ    = 0.025;                      % axial voxel scaling in microns
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
phizDeg   = 46.0;                   % axial phase
Nslits    = 3;

numIt  = 10;
Radius = 2/2;
Thickness = 1/2;
s = struct('X', X, 'Y', Y, 'Z', Z, 'dXY', dXY, 'dZ', dZ, 'uc', uc, 'offs', offs,'phi', phi,'theta', theta,'um', um,'x0',x0, 'fL1', fL1, 'fL2', fL2, 'fMO', fMO, 'wm', wm, 'phizDeg', phizDeg, 'Nslits', Nslits);

Settings              = DataFrame.fromStruct(s);
Settings.PAgard       = @PSFAgard;
Settings.Pattern3D    = @PatternTunable3DNSlits;
Settings.Radius       = Radius;
Settings.Thickness    = Thickness;
Settings.CostFunction = @CostFunction;
Settings.Gradient     = @Gradient;
Settings.StepSize     = @StepSize;
Settings.numIt        = numIt;

% Call the InverseTest

Metrics = InverseTest(Settings, @SphericalShell, @ForwardModel, @GradientDescent);
disp(Metrics)
