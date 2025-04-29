function  fwhelloworld(jsonConfigFile)
% fwhelloworld - A function to be compiled into a Flywheel gear that
%                parses and saves the operating environment provided by
%                the Flywheel manifest. It is mean to aid developers 
%                craft new gears.
%
% Usage:  fwhelloWwrld(configFile)
%
%         configFile: This is the locations of a config.json file generated 
%                     by Flywheel that provides all the information the 
%                     gear should need to run. If run locally, it is
%                     required. If run as a gear within Flywheel's
%                     execution engine, it will be read from its defaul
%                     location.
%
% fwhelloworld is meant to aid MATLAB developers write Flywheel gears. This
% function should be compiled (i.e. mcc -m fwhelloworld.m), packaged with 
% companion Flywheel manifest and dockerfile files, and built into a
% Flywheel gear (i.e. fw-beta gear build <path to gear files>).
%
% The compiled gear will read in the config.json file provided by Flywheel,
% parse it into a MATLAB struct, makes it human readable, and write it to 
% the output folder for analysis later. It will also save a .mat file with 
% the relevant parts of the MATLAB workspace, again for later analysis.
% These outputs are meant to assist a developer easily find and use the
% information needed for functionality. Finally, it includes verbose
% logging using a custom log function that writes timestamped log updates 
% to both STDIO that can be viewed in realtime during gear execution and to
% a log file.

% Author: Jeffrey Luci, jeffrey.luci@rutgers.edu
% https://github.com/jeffreyluci/MATLAB-Flywheel_Gears/tree/main/fwhelloworld
% VERSION HISTORY:
% 20250429: Initial Release

% Mark exact start time for accurate logging
startTime = tic;
logFileTime = char(datetime('now', ...
                            'TimeZone', 'local', ...
                            'Format',   'd-MMM-y HH-mm-ss Z'));

% Set up logging service
logFileName = sprintf('fwHelloWorld_%s.txt', strrep(logFileTime, ' ', '-'));
logFileLocation = ['/flywheel/v0/output/', logFileName];
logFid = fopen(logFileLocation, 'wt');
% First entry into log is manual for formatting. All future use logText
% function at the end of fwHelloWorld
fwrite(logFid, [logFileTime, ': fwHelloWorld started', newline], 'char');

% Parse config.json to get input info and options
logText('Searching for config.json ...');
if exist('jsonConfigFile', 'var')
    jsonFID = fopen(jsonConfigFile, 'rt');
    logText('config.json file provided as argument.');
else
    jsonFID = fopen('/flywheel/v0/config.json', 'rt');
end
if jsonFID == -1
    logText('config.json file not found.');
    disp('config.json file not found.');
    return;
else
    logText('config.json file found: /flywheel/v0/config.json');
end
logText('reading config.json file ...');
jsonText = char(fread(jsonFID, inf, 'uint8')');
fclose(jsonFID);
logText('parsing config.json file ...');
jsonConfigStruct = jsondecode(jsonText); %#ok<NASGU>
jsonOutputFileText = jsonencode(jsonText, 'PrettyPrint', true);

% Make config.json file human-readable and write it to the output folder
logText('writing config.json file to /flywheel/v0/output');
outJsonFid = fopen('/flywheel/v0/output/config.json', 'wt');
fwrite(outJsonFid, jsonOutputFileText, 'char');
fclose(outJsonFid);

% Save entire workspace for later analysis
logText('saving workspace in /flywheel/v0/output/matlaboutput.mat');
save('/flywheel/v0/output/matlabWorkspace.mat');

% Record finish time and total execution time
timeSpent = num2str(toc(startTime));
logText('fwHelloWorld execution finished.');
logText(['Total time spent in execution: ', timeSpent, ' sec.']);

fclose(logFid);



    function logText(text)
        % Log function that accepts a character string as an argument and
        % logs it with a timestamp in both a text file in the output folder
        % and to STDIO for realtime monitoring
        timestamp = char(datetime('now', ...
                                  'TimeZone', 'local', ...
                                  'Format',   'd-MMM-y HH:mm:ss Z'));
        fwrite(logFid, [timestamp, ': ', text, newline]);
        disp([timestamp, ': ', text]);
    end


end
