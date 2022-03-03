function [status] = openCS100A()
%
% open persistent COM1 serial port connection to Minolta CS100A photometer
% usage:
%    status = openCS100A
%       status = 0 if successful
%              = -1 if serial.fopen() fails
%              = -2 if COM1 CTS input not asserted (no meter detected)
%              = otherwise see CS100A operating manual
%
% openCS100A must be called prior to using readCS100A.m
% call closeCS100A.m when finished using the photometer

%first, destroy ALL previously established MATLAB serial port connections
global CS100; %global structure used to coordinate Minolta meter commands
if isfield(CS100,'port')
    serialobjs=instrfind;
    if ~isempty(serialobjs)
        fclose(serialobjs);
        delete(serialobjs);
    end
end

status=0; %default return status = OK

%Create COM1 serial port object using Minolta default protocol settings
CS100.port=serial('COM1','BaudRate',4800,'databits',7,'parity','even',...
      'stopbits',2,'terminator','CR/LF','FlowControl','hardware','timeout',5);
  
%now, connect the serial port object to hardware device
try
    fopen(CS100.port);
catch
    status = -1; %Set error status if connection unsuccessful and exit
    return;
end

%Test state of COM1 CTS-handshake input pin
%CTS will  be asserted ('on') if CS100A is connected in COMM mode
%Otherwise, exit with warning message
%This step is needed to prevent MATLAB from "hanging" during meter I/O
pins = CS100.port.Pinstatus; %read state of CD,CTS,DSR and RI COM1 input pins
if( strcmp(pins.ClearToSend,'off') )  %exit if CS100A not enabled
    %warning message
    disp('Warning: CS100A photometer could not be detected')
    disp('Either CS100A in not connected properly to the COM1 port, or')
    disp('It has not been configured for COMMUNICATION mode operation');
    disp('(i.e., Hold down F button while moving power switch to "On" position)');
    %kill COM1 connections
    serialobjs=instrfind;
    if ~isempty(serialobjs)
        fclose(serialobjs);
        delete(serialobjs);
    end
    %destroy global CS100 control structure
    clear global CS100;
    %update return status
    status = -2;
end


return;

%initialize meter (Send 'MES,00<CR\LF>' string over serial port)
fprintf(CS100.port,'MES,00','async');
%collect data returned from meter over serial port (e.g., 'ER00')
[line,nchars]=fscanf(CS100.port);
%parse status parm from data line returned from meter
val = str2num(line(3:end));
status = val(1);
