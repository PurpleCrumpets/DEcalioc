function output = sortImageStruct(imageStruct) 

% sortImageStruct.m
% 
% Function to reorder structure of image files by natural sort order.
%
% Tim Churchfield
%
% Last edited: 14/10/2019


%% Function Input Variables
% imageStruct - structure of image files produced from 'dir' command


%% Function Output Variables
% output      - structure of image files order by natural sort order 


%% Obtain image file extension
numFiles = length(imageStruct);
ext = cell(numFiles,1);
for i = 1:numFiles
    [~,~,ext{i}] = fileparts(imageStruct(i).name);
end

test = sum(strcmp(ext,ext(1)))/numFiles;
if test == 1
    ext = char(ext(1));
else
    warning('Multiple image file extensions found!')
    return
end


%% Obtain time steps from image file names
timesteps = char(imageStruct.name);
timesteps = timesteps;
timesteps = cellstr(timesteps);
% Remove file type
timesteps = strtok(timesteps(:),'.');
% Remove 'image_' from file time step
for i = 1:numFiles
    timesteps(i) = substr(timesteps(i){1},7);
end

% Convert output to double
timesteps = str2double(timesteps);

%% Sort ImageStruct by timestep 
[~,timesteps_order] = sort(timesteps);
output = imageStruct(timesteps_order);


return