function imagingTS = getImagingTS(projectName)
  
  % set path
  global pathProject
  
  
  % open imaging_ts.txt
  fd = fopen([pathProject, 'images/imaging_ts.txt'], 'r');

  % Read job.sh into cell A
  i = 1;
  tline = fgetl(fd);
  imagingTS{i} = tline;
  while ischar(tline)
    i = i+1;
    tline = fgetl(fd);
    imagingTS{i} = tline;
  end
  
  imagingTS = imagingTS(1:end-1);
  
  % Close imaging_TS.txt
  fclose(fd);