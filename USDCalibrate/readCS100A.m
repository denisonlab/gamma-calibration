function [luminance,cie_x,cie_y,status] = readCS100A
%
%Collect measurement data from Minolta CS100A photometer over serial port.
%User must establish a serial connection using openCS100A.m prior to first
%attempt to use readCS100A.m
%
%usage:
%  [luminance, x, y, status] = readCS100A;
%   luminance = luminance reading (cd/m2 or ftL; check meter settings)
%       cie_x = CIE 1031 x-chromaticity coordinate
%       cie_y = CIE 1931 y-chromaticity coordinate
%      status = 0 if successful
%              -1 if no previos connection to CS100A established
%              -2 if meter turned-off or timed-out after initial connection
%              -3 if serial timeout error
%              otherwise, check CS100A manual for error code desscriptions
%
%  IMPORTANT NOTE:
%  Must call openCS100A.m to establish a persistent COM1 connection to
%  the Minolta CS100A meter prior to using readCS100A for the first time.
%
%  Good programming practice mandates a call to closeCS100A to remove the
%  persistent COM1 connection when finished using readCS100A in your
%  script.


global CS100; %global structure used to coordinate CS100A I/O operations
luminance=0; cie_x=0; cie_y=0; status=0;

%exit if connection to meter not previously established
if (isfield(CS100,'port'))
    pins=CS100.port.Pinstatus;  %read COM1 input status lines
    if(strcmp(pins.ClearToSend,'off'))
        status = -2;
        return;      %exit if COM1 connection to meter has been broken
    end
else
    status = -1;
    return;          %exit if no previous connection to meter established
end


%request luminance reading from meter (Send 'MES<CR\LF>' string over serial port)
fprintf(CS100.port,'MES');

%collect data returned from meter over serial port
[line,nchars]=fscanf(CS100.port);

%parse input data
%find location of first BLANK char
j=min(findstr(line,' '));
%fetch characters following first blank and convert to number
%val=str2num(line(j+1:end));
val=str2num(line(3:end));
%test for NULL data
if isempty(val)
    status = -3;  %set error condition if bad data retruned by meter
else
    status = val(1);     %else, parse the photometeric data and return
    luminance = val(2);
    cie_x = val(3);
    cie_y = val(4);
end
