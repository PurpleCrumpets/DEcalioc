function results = curveProperties(vidmasks,framerate,model)

  % Calculates the properties of the rotating drum that do not depend on the
  % type of particles, for a given sequence of masks according to the chosen
  % model.

  % vidmasks: uint8 H x W x F matrix with values corresponding to colors:
  % 1: red, 2: white, 0: background (black)

  % (F: number of frames)

  % framerate: in frames per second

  % model: character, the nonlinear model chosen to describe the top free
  % curve analytically
  % Available models:
  %   - 'noModel': The top free surface is described by a first order
  %       polynomial. The function angle_of_repose_img.m is used.
  %   - 'threeAngles': The top free surface is described by three consecutive
  %       straight lines, smoothed at their intersections. The function
  %       threeAngles.m is used.
  %   - 'lineTwoCircles': The top free surface is described by one straight
  %       line and two tangent circles on either side. The function
  %       lineTwoCircles.m is used.

  % results: structure with F elements, containing the following fields:
  %   - time: double, the time of the corresponding frame (s)
  %   - xdrum: the x-coordinate of the drum center (pixels)
  %   - ydrum: the y-coordinate of the drum center (pixels)
  %   - rdrum: the radius of the drum (pixels)
  %   - angle_av: double, the average dynamic angle of repose, based on a
  %       first order approximation of the free surface (degrees)
  %   - R2lin: the coefficient of determination of the linear fit
  % Additional fields if a model different from 'noModel' is chosen
  %   - param: double vector, the parameters of the nonlinear model
  %   - angle_nnl: double, the dynamic angle of repose in the middle section
  %       of the drum, as calculated by the nonlinear model (degrees)
  % Additional fields if 'threeAngles' model is chosen
  %   - angle1, angle2: double, the dynamic angles from left to right
  %       (degrees)
  %   - radius1, radius2: double, the radii of curvature, from left to right
  %       (pixels)
  % Additional fields if 'lineTwoCircles' model is chosen
  %   - radius1, radius2: double, the radii of curvature, from left to right
  %       (pixels)

  %% Check model validity
  if strncmpi(model,'noModel',1)
      model = 'noModel';
  elseif strncmpi(model,'threeAngles',1)
      model = 'threeAngles';
  elseif strncmpi(model,'lineTwoCircles',1)
      model = 'lineTwoCircles';
  else
      error('Invalid model.')
  end

  %% Calculate results
  F = size(vidmasks,3);         

  %% Obtain number of cores assigned to job 
  %nPROC = getPROC(pathProject);
  nPROC = 2;

  % resize vidmasks 
  vidmasks = num2cell(vidmasks,[1 2]);
  vidmasks =  permute(vidmasks,[1 3 2]);

  framerateParallel(1:F) = {framerate};
  modelParallel(1:F)     = {model};
  frParallel             = num2cell(1:F);


  %% Parallel loop
  results = pararrayfun (nPROC, @curvePropertiesParallel, vidmasks, framerateParallel, modelParallel, frParallel);

  %% Serial Loop
%  for fr = F:-1:1
%    results(fr) = curvePropertiesParallel(vidmasks(fr), framerate, model, fr);
%  end


endfunction