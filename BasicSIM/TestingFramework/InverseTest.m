function InverseTest(Settings, SimulationFct, Forward, Backward)

Radius = 2/2;
Thickness = 1/2;
Object = SimulationFct(Settings, Radius, Thickness);

figure; imagesc(Object(:,:,1+(Settings.Z)/2)); axis square;

% call “PSFAgard” and “PatternTunable3DNSlits”
h  = PSFAgard(Settings);

[im, jm, ~] = PatternTunable3DNSlits(Settings);

rawData = Forward(Object, h, im, jm);

numIt = 10;
picIn = numIt;
disp(size(rawData));

%estimatedOb = Backward(rawData);
estimatedOb = Backward(@ForwardModel,@CostFunction,@Gradient,@StepSize,rawData, h, im, jm, numIt ,5e-20 ,-1, -1, picIn); 

                           
% compare Object vs estimatedOb by plotting using imagesc
% imshowpair(Object,estimatedOb,'diff')
figure;
subplot(1,2,1); imagesc(Object(:,:,1+(Settings.Z)/2));
axis square; xlabel('x'); ylabel('z'); colorbar; 
subplot(1,2,2); imagesc(estimatedOb(:,:,1 + (Settings.Z)/2));
axis square; xlabel('x'); ylabel('y'); colorbar; 
end

