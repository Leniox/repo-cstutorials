%%This function gets all the files with a certain exetesion from a
%%directory. The files are returned in two cell array vectors, one with the
%%name strings and one with  the respective dates. The sort type argument
%%allows you to sort the file by either date or alphabetical name. The
%%argument for sort the sort_type are: 0 - no sorting; 1 - sort by date;
%%2 - sort by name. Supports the use of wild cards for extension: *.m, *.*,
%%etc...
%%Antonio May 2005
%%function [srt_cell date_cell] = get_files_from_dir (drct, extens, sort_type)
function [srt_cell date_cell] = get_files_from_dir (drct, extens, sort_type)
%%CONSTANTS
NONE = 0;
DATE = 1;
NAME = 2;

if (nargin < 3)
  sort_type = NAME; % default
end

%Values that should be passed in:
% sort_type = 2;
% extens = '*.m';
if (drct(end) ~= '/')
  drct = [drct '/'];
end
% drct = 'I:\ComputerCode\Matlab\';
lst_type = [drct extens];

%Store the file data into the struct
files = dir(lst_type);
m = size(files, 1);
[X{1:m, 1}] = deal(files.name); %Equivalent to X = {files.name}'; 
[X{1:m, 2}] = deal(files.date);

%Sort by the appropiate criteria
switch sort_type
    case NONE
        srt_cell = {X{:,1}}';
        date_cell = {X{:,2}}';
        srti = (1:1:size(srt_cell, 1)); 
    case DATE
        [temp{1:m, 1}] = deal(X{:, 2}); %Here we can use deal or simply: temp = {X{:,2}}';
        temp = datenum(temp);
        [srt_cell srti] = sort(temp);
        date_cell = {X{srti, 2}}';
        srt_cell = {X{srti, 1}}';        
    case NAME
        temp = {X{:,1}}';
        [srt_cell srti] = sort(temp);
        date_cell = {X{srti, 2}}';
    otherwise
        disp(['You have passed an incorrect sort type!!!']);
        disp([num2str(sort_type) ' is not a valid value...']);
        disp(['Returning unsorted files']);
        srt_cell = {X{:,1}}';
        date_cell = {X{:,2}}';
        srti = (1:1:size(srt_cell, 1));
end
return