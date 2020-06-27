function Metrics = InverseTest(Settings, SimulationFct, Forward, Backward)

Object = SimulationFct(Settings);

figure; imagesc(Object(:,:,1+(Settings.Z)/2)); axis square;

%% call â€œPSFAgardâ€? and â€œPatternTunable3DNSlitsâ€?
func1 = Settings.PAgard;
h  = func1(Settings);

func2 = Settings.Pattern3D;
[im, jm, ~] = func2(Settings);

rawData = Forward(Object, h, im, jm);
rawData = rawData(1:2:end, 1:2:end, 1:2:end, :, :);
numIt   = Settings.numIt;
picIn   = numIt;
disp(size(rawData));

estimatedOb = Backward(Forward,Settings.CostFunction,Settings.Gradient,Settings.StepSize,rawData, h, im, jm, numIt ,5e-20 ,-1, -1, picIn); 

% normalize the restoration
norOb       = estimatedOb/sum(estimatedOb(:))*sum(Object(:));

[MSE, SSIM] = MSESSIM(Object, norOb);
Metrics.MSE = MSE;
Metrics.SSIM = SSIM;
%% compare Object vs estimatedOb by plotting using imagesc
figure;
subplot(1,2,1); imagesc(Object(:,:,1+(Settings.Z)/2));
axis square; xlabel('x'); ylabel('z'); colorbar; 
subplot(1,2,2); imagesc(estimatedOb(:,:,1 + (Settings.Z)/2));
axis square; xlabel('x'); ylabel('z'); colorbar; 

end

