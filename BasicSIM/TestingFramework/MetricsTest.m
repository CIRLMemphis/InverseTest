function [MSE, SSIM] = MetricsTest(Settings, SimulationFct)
%   Detailed explanation goes here

Object = SimulationFct(Settings);
[MSE, SSIM] = MSESSIM(Object, Object);
end
