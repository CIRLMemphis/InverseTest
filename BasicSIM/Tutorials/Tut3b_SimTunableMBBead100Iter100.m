%% load the CIRL settings
run("../CIRLSetup.m")

%% load the experiment setup (in this case it is simulated setup)
run("SimTunableBead100Setup.m");

%% load the collected data (in this case simulated data)
matFile = CIRLDataPath + "/Simulation/Tunable/SimTunableBead100.mat";
load(matFile, 'g');

%% increase the resolution grid
X     = 2*X;
Y     = 2*Y;
Z     = 2*Z; 
dXY   = dXY/2;
dZ    = dZ/2;

Settings.X = X;
Settings.Y = Y;
Settings.Z = Z;
Settings.dXY = dXY;
Settings.dZ = dZ;
%% construct the high-resolution point-spread function (PSF)
h  = PSFAgard(Settings);

%% load the high-resolution modulating patterns
[im, jm, ~] = PatternTunable3DNSlits(Settings);

%% run the model-based reconstruction and get the restored image
numIt    = 10;       % set the number of iterations
picIn    = numIt;    % picture every 5 interations
reconImg = GradientDescent(@ForwardModel, ...
                           @CostFunction, ...
                           @Gradient, ...
                           @StepSize, ...
                           g, h, im, jm, numIt ,...
                           5e-20 ,-1, -1, picIn);
