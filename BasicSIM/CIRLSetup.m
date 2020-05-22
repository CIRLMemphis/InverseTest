clear;
clc;

% folder containing the experimental .mat data
CIRLDataPath = "C:\Users\battu\Documents\MATLAB\CIRLData";

% folder containing the source code
CIRLSrcPath  = "C:\Users\battu\Documents\MATLAB\BasicSIM";

% folder containing the generated reports, default to
% "CIRLSrcPath\GeneratedReport"
CIRLReportPath = CIRLSrcPath + "\GeneratedReport";

% load all scripts in the src path
addpath(genpath(CIRLSrcPath));