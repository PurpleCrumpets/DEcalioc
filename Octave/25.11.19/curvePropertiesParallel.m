function results = curvePropertiesParallel(vidmasks, framerate, model,fr) 
  
  first_frame = 1;
  
  % convert imageStructName to string 
  if isa(framerate,'cell')
    framerate = cell2mat(framerate);
  end

  if isa(model,'cell')
    model = char(model);
  end

  if isa(fr,'cell')
    fr = cell2mat(fr);
  end
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  masks = cell2mat(vidmasks);
  %  masks = vidmasks(:,:,fr);
  
  results.time = (fr-1)/framerate;
  drum = drumCircle(masks);
  results.xdrum = drum(1);
  results.ydrum = drum(2);
  results.rdrum = drum(3);
  [a_repose, ~, ~, ~, R2] = angle_of_repose_img(masks);
  results.angle_av = a_repose;
  results.R2lin = R2;
  
  if ~strncmpi(model,'noModel',1)
      
      if first_frame
          first_frame = 0;
          param = findFreeSurface(masks, model);
      else
          param = findFreeSurface(masks, model, param);
      end

      if strncmpi(model,'threeAngles',1)
          
          [~, derived] = threeAngles(param,[]);
          results.angle1 = derived(1);
          results.angle_nnl = derived(2);
          results.angle2 = derived(3);
          results.radius1 = derived(19);
          results.radius2 = derived(20);      
          
      else % model: 'lineTwoCircles'
          
          [~, derived] = lineTwoCircles([],param);
          results.angle_nnl = derived(1);
          results.radius1 = param(5);
          results.radius2 = param(6);            
          
      end
      
      results.param = param;
      
  end
  
endfunction