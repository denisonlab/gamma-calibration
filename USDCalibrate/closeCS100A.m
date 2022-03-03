%function closeCS100A()
%
% Use this function to shutdown serial connections previously established to
% interface with the Minolta CS100A photometer.
%
% usage:  closeCS100A
%
% see also:  openCS100A    readCS100A

global CS100; %global struction used to manage Minolta CS100A I/O operations
if ( isfield(CS100,'port') )
    serialobjs=instrfind;
    if ~isempty(serialobjs)
        fclose(serialobjs);
        delete(serialobjs);
    end
end
%destroy Global CS100 structure
clear global CS100;
