function [results, averageOutput] = getAngle(projectName,angleModel)
  %
  % getAngle.m
  %
  % function to create a sequence of masks from particle images produced by
  % LIGGGHTS and obtain the angle of repose for each image. The change in the
  % angle of repose is plotted with time.
  %
  % Requires parallel package
  % 
  % Tim Churchfield
  %
  % Last Edited: 13/11/2019
  %
  %% Variable Dictionary





  % ----------------------------------------------------------------------------
  %% Preparation
  
  % Set Paths
  global pathProject

  % create anaylsis Directory
  if ~exist(fullfile(pathProject,'analysis'), 'dir');
     mkdir(pathProject,'analysis');
  end
  
  % remove old angleRepose.txt file if it exists
  command = ['[ -f ', fullfile(pathProject,'analysis',...
    [projectName, '_angleRepose.txt']), ' ] && echo "1" || echo "0"'];
  [~,str] = system(command);
  str = str2num(str);
  
  if str == 1
    command = ['rm ', fullfile(pathProject,'analysis',...
      [projectName, '_angleRepose.txt'])];
    [~,~] = system(command);
  end
  
  % obtain number of cores assigned to job 
%  nPROC = getPROC(pathProject);
  nPROC = 2;

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

  % sort images chronologically 
  imageStruct = sortImageStruct(imageStruct);
  imageStructName = {imageStruct.name};

  % obtain list of time-steps
  timesteps = {imageStruct.name};  
  timesteps = regexp(timesteps,['(?<=image_)\d*(?=\.',imageType,')'],'match')';
  timesteps = str2double(cat(1,timesteps{:}));
  
  % obtain image resolution (memory preallocation purposes)
  info = imfinfo(fullfile(pathProject,'images',imageStruct(1).name));


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Create Masks
  
  % get imaging time steps
  imagingTS = getImagingTS(projectName);
  
  for k = 1:length(imagingTS)/2
    
    startEndImaging = [str2num(imagingTS{2*k-1}); str2num(imagingTS{2*k})]; 
    startImagingRow = find(timesteps >= startEndImaging(1));
    endImagingRow   = find(timesteps <= startEndImaging(2));
    startImagingRow = min(startImagingRow);
    endImagingRow   = max(endImagingRow);
    numRows = endImagingRow-startImagingRow+1;
    
    % Create Sequence of Masks
    vidmasks = zeros(info.Height,info.Width,numRows,'int8'); % Reduce mem req
    
    for i = startImagingRow:endImagingRow
      l = 1+i-startImagingRow;
      vidmasks(:,:,l) = createMask(imageStructName(i));
    end 
    
  %  imageStructNamePar = imageStructName(startImagingRow:endImagingRow);
  %  vidmasks3 = pararrayfun(nPROC, @createMask, imageStructNamePar);
  %  vidmasks4 = parcellfun(nPROC, @createMask, imageStructNamePar);

    % Save vidmasks
    tail = ['_vidmasks_',num2str(k),'.mat'];
    save('-mat7-binary',fullfile(pathProject,'analysis',[projectName tail]),...
      'vidmasks');

      
    %% Get Angle of Repose
    
    % get frame rate
    frameRate = getFrameRate(pathProject);

    % obtain curve properties
    results(k) = {curveProperties(vidmasks,frameRate,angleModel)};

    % calculate average angles of repose 
    angle_av = sum([results{k}.angle_av])/length(results{k});
    if strcmpi(angleModel,'noModel') || strcmpi(angleModel,'n')
      averageOutput(k) = angle_av;
    else    
      angle_nnl = sum([results{k}.angle_nnl])/length(results{k});
      averageOutput(k) = {[angle_av;angle_nnl]};
    end 

    % save angle of repose results
    tail = '_angleRepose.txt';
    if exist('angle_nnl','var')
      save(fullfile(pathProject,'analysis',[projectName tail]),'angle_av','angle_nnl','-ascii','-append');
    else 
      save(fullfile(pathProject,'analysis',[projectName tail]),'angle_av','-ascii','-append');
    end 

    
  end

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Remove images to save space
  
  command = ['cd ' fullfile(pathProject, 'images'), ' ; find . -name "*.', imageType, '" -type f -delete'];
%  [~,~] = system(command);
  
  
endfunction


%  disp('Saving results of curveProperties function to file...');
  %  tail = '_curveProperties.mat';
  %  save('-mat7-binary',fullfile(pathProject,'analysis',[projectName tail]),'results');
    % Save results to text file for calibration
  %  save('myFile.txt', 'excel', '-ASCII','-append');
  %  save('-mat7-binary',fullfile(pathProject,'analysis',[projectName tail]),'vidmasks');
    
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