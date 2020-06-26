%% load the CIRL settings
run("CIRLSetup.m")

%% load the experiment setup (in this case it is simulated setup)
run("SimTunableStarLikeSetup.m");

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

%% load the collected data (in this case simulated data)
ob  = StarLikeSample(3,512,6,20,3,0.6);
gIn = ForwardModel(ob, h, im, jm);
gIn = gIn(1:2:end, 1:2:end, 1:2:end, :,:);
g   = gIn;

%% run the model-based reconstruction and get the restored image
numIt    = 10;       % set the number of iterations
picIn    = numIt;    % picture every 5 interations
reconImg = GradientDescent(@ForwardModel, ...
                           @CostFunction, ...
                           @Gradient, ...
                           @StepSize, ...
                           g, h, im, jm, numIt ,...
                           5e-20 ,-1, -1, picIn);
                       
save('TutSimTunableStarLikeMB.mat', '-v7.3', 'g', 'reconImg');
%% Compare the similarity of the simulated object with restoration object
[MSE, SSIM] = MSESSIM(ob, reconImg);
disp(MSE)
disp(SSIM)
%% load the collected data (in this case reconstructed data)
gIn1 = ForwardModel(reconImg, h, im, jm);
gIn1 = gIn1(1:2:end, 1:2:end, 1:2:end, :,:);
g1   = gIn1;
%% Compare the similarity of the simulation data with restoration simulation data
[MSE, SSIM] = MSESSIM(g, g1);
disp(MSE)
disp(SSIM)