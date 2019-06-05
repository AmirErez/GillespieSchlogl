% SIMULATESCHLOGL1CELL_COMPILE   Generate MEX-function SimulateSchlogl1cell_mex
%  from SimulateSchlogl1cell.
% 
% Script generated from project 'SimulateSchlogl1cell.prj' on 04-Jun-2019.
% 
% See also CODER, CODER.CONFIG, CODER.TYPEOF, CODEGEN.

%% Create configuration object of class 'coder.MexCodeConfig'.
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.ReportPotentialDifferences = false;

%% Define argument types for entry-point 'SimulateSchlogl1cell'.
ARGS = cell(1,1);
ARGS{1} = cell(5,1);
ARGS{1}{1} = coder.typeof(0,[1 2]);
ARGS{1}{2} = coder.typeof(0);
ARGS_1_3 = struct;
ARGS_1_3.s = coder.typeof(0);
ARGS_1_3.K2 = coder.typeof(0);
ARGS_1_3.K = coder.typeof(0);
ARGS_1_3.a = coder.typeof(0);
ARGS_1_3.N = coder.typeof(0);
ARGS{1}{3} = coder.typeof(ARGS_1_3);
ARGS{1}{4} = coder.typeof(0);
ARGS{1}{5} = coder.typeof(0);

%% Invoke MATLAB Coder.
codegen -config cfg SimulateSchlogl1cell -args ARGS{1} -nargout 3

