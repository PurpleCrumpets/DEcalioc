function nPROC = getPROC(pathProject) 
  %
  % nPROC.m
  %
  % Function to obtain the number of processing cores assigned for a job
  % submission. This is achieved by reading the job.sh or job.script file and
  % finding the line beginning with 'mpirun -np ' and extracting then number of
  % processing cores from this line.
  % 
  % Tim Churchfield
  %
  % Last Edited: 06/11/2019
  %
  %% Variable Dictionary
  % pathJob - path to job.sh or job.script
  % fileID  - output from fopen to test if file successfully opened
  % str     - string containg line of text from a line within job.sh/job.script
  % nPROC   - number of processing cores assigned to job 


  % Open file
  pathJob = fullfile(pathProject,'job.sh');
  fileID = fopen(pathJob,'r');

  if fileID == -1
    pathJob = fullfile(pathProject,'job.script');
    fileID = fopen(pathJob,'r');
  end
  
  str = fgets(fileID);   

  % Processors
  frewind(fileID); % Reset read position in file
  while ~startsWith(str,'mpirun -np ')
      str = fgets(fileID);
  end
  nPROC = sscanf(str,'mpirun -np %d');

  % Close data.head
  fclose(fileID);

endfunction