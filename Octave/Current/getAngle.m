function [averageOutput, results] = getAngle(projectName,angleModel,imagingTS)
%
% getAngle.m
%
% Script to create a sequence of masks from particle images produced by
% LIGGGHTS and obtain the angle of repose for each image. The change in the
% angle of repose is plotted with time.
%
% Requires parallel package
%
% mention flaw in terms of reading image types when building structure
% 
% Tim Churchfield
%
% Last Edited: 06/11/2019
%
%% Variable Dictionary



%% Set Paths
global pathProject


%% Obtain List of Images from Directory

% image types
imageType = {'ppm'; 'jpeg'; 'png'};


for i = 1:size(imageType,1)
    imageStruct = dir(fullfile(pathProject,'images',['*.', imageType{i}]));
    numFiles = length(imageStruct);

    if numFiles ~= 0
        imageType = imageType{i};
        break 
    end
end

if isempty(imageStruct)
    warning('No images found...')
    return
end 


%% Sort Images Chronologically 
imageStruct = sortImageStruct(imageStruct);


%% Obtain Image Resolution (memory preallocation purposes)
info = imfinfo(fullfile(pathProject,'images',imageStruct(1).name));


%% Obtain number of cores assigned to job 
%nPROC = getPROC(pathProject);
nPROC = 2;

imageStructName = {imageStruct.name};

%% Create Anaylsis Directory
if ~exist(fullfile(pathProject,'analysis'), 'dir')
   mkdir(pathProject,'analysis')
end

% Select images of interest 
%for j = 1:length(imagingTS)/2
for j = 1:1
  startImaging = char(imagingTS(2*j-1)); 
  endImaging = char(imagingTS(2*j));
  startImagingRow = find(strcmp(imageStructName, ['image_', startImaging, '.', imageType]));
  endImagingRow = find(strcmp(imageStructName, ['image_', endImaging, '.', imageType]));
  numRows = endImagingRow-startImagingRow+1;
  
  %% Create Sequence of Masks
  vidmasks = zeros(info.Height,info.Width,numRows,'int8'); % Reduce mem req
  
  for i = startImagingRow:endImagingRow
    vidmasks(:,:,i) = createMask(imageStructName(i));
  end 
  
%  imageStructNamePar = imageStructName(startImagingRow:endImagingRow);
%  vidmasks3 = pararrayfun(nPROC, @createMask, imageStructNamePar);
%  vidmasks4 = parcellfun(nPROC, @createMask, imageStructNamePar);

  %% Save vidmasks
  disp('Saving vidmasks to MAT file...');
  tail = ['_vidmasks.mat',num2str(j)];
  save('-mat7-binary',fullfile(pathProject,'analysis',[projectName tail]),'vidmasks');


  %% Get Frame Rate
  frameRate = getFrameRate(pathProject);


  %% Obtain Curve Properties
  results = curveProperties(vidmasks,frameRate,angleModel);

  % calculate average angles of repose 
  angle_av = sum([results.angle_av])/length(results);
  
  if strcmpi(angleModel,'noModel') || ~strcmpi(angleModel,'n')
    averageOutput = angle_av;
  else    
    angle_nnl = sum([results.angle_nnl])/length(results);
    averageOutput = [angle_av;angle_nnl];
  end
  
  % Save results
%  disp('Saving results of curveProperties function to file...');
%  tail = '_curveProperties.mat';
%  save('-mat7-binary',fullfile(pathProject,'analysis',[projectName tail]),'results');

end


  
  
  
  
  
  
  
  

%%% Plot Results
%
%% Get plot colours
%%colors = distinguishable_colors(8); % makecform not implemented in Octave image package yet
%
%% Create plot
%if strcmpi(dispFig,'yes') || strcmpi(dispFig,'y')
%    angleFigure = figure('Position', get(0, 'Screensize')); 
%else
%    angleFigure = figure('Position', get(0, 'Screensize'),...
%        'visible', 'off');
%end
%
%hold on
%%plot([results.time],[results.angle_av],'Color',colors(1,:))
%%plot([results.time],[results.angle_nnl],'Color',colors(2,:));
%plot([results.time],[results.angle_av])
%
%if strcmpi(angleModel,'threeAngles') || strcmpi(angleModel,'lineTwoCircles') ...
%  || strcmpi(angleModel,'t') || strcmpi(angleModel,'l')
%  plot([results.time],[results.angle_nnl]);
%  legend('Average','Non-linear');
%else
%  legend('Average');
%end
%
%% Labels and title
%xlabel('Time (s)')
%ylabel('Dynamic Angle of Repose (�)')
%
%%projectTitle = insertBefore(projectName,"_","\");
%projectTitle = projectName;
%title([projectTitle ': Dynamic Angle of Repose with Time']);
%set(gca,'XMinorTick','on','YMinorTick','on')
%
%%% Save Figure
%
%% Save png file
%saveas(angleFigure, fullfile(pathProject,'analysis',...
%    [projectName '_anglePlot_1']), 'png');
%
%% Make .fig visable when re-opening upon saving
%set(angleFigure, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
%saveas(angleFigure, fullfile(pathProject,'analysis',...
%    [projectName '_anglePlot']), 'fig'); 


%disp('Dynamic Angle of Repose Figure Saved!');

endfunction