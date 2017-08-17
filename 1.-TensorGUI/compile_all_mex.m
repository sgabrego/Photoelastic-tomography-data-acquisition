% Tested on Windows 10 with 'MinGW64 Compiler (C++)'.
% MATLAB_VERSION = 2016a
mex openCamera.cpp CXXFLAGS='$CXXFLAGS -fpermissive' 'C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\Lib\uc480_64.lib'
mex loadParameters.cpp 'C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\Lib\uc480_64.lib'