function nPROC = getPROC(pathProject) 
  %
  % getPROC.m
  %
  % Function to obtain the number of processing cores assigned for a job
  % submission. This is achieved by reading the job.sh or job.script file and
  % finding the line beginning with 'mpirun -np ' and extracting then number of
  % processing cores from this line.
  % 
  % Tim Churchfield
  %
  % Last Edited: 13/11/2019
  %
  % ----------------------------------------------------------------------------
  %% Variable Dictionary
  %
  % -- Inputs --
  %
  % pathProject - Absolute path to project directory
  % 
  %
  % -- Outputs --
  %
  % nPROC       - Number of processing cores assigned to job 
  %
  %
  % -- Other --
  %
  % pathJob     - Absolute path to job.sh script
  % fileID      - Output from fopen to test if file successfully opened
  % str         - Text from a line within job.sh/job.script
  %
  %
  % ----------------------------------------------------------------------------
  %% Execution
  
  % Open file
  pathJob = fullfile(pathProject,'job.sh'); % job.sh
  fileID = fopen(pathJob,'r');

  if fileID == -1
    pathJob = fullfile(pathProject,'job.script'); % job.script
    fileID = fopen(pathJob,'r');
  end
  
  str = fgets(fileID);   

  % obtain number of assigned processors
  frewind(fileID); % Reset read position in file
  while ~startsWith(str,'mpirun -np ')
      str = fgets(fileID);
  end
  nPROC = sscanf(str,'mpirun -np %d');

  % Close file
  fclose(fileID);

endfunction