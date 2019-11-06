function uploadDir(model, folderName) 
  
  % uploadDir.m
  %
  % Function to read in the bash script bashScript3.sh and edit the required
  % sections to successfully upload the current directory to the cluster.
  %
  %
  % Tim Churchfield
  %
  % Last edited: 04/11/2019
  
  
  global path clusterDir;
  myDirectory = [path, 'optim/', model, '/', folderName];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Create model subdirectory
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Change file permissions, Linux compatability of bashScript2.sh
  system(['cd ', path, 'optim/', model, '/', folderName, ';',...
    ' chmod 755 bashScript2.sh; sed -i ''s/\r//g'' bashScript2.sh']);
    
  % open bashScript2.sh
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript2.sh'], 'r');

  % Read bashScript2.sh into cell A
  i = 1;
  tline = fgetl(fd);
  A{i} = tline;
  while ischar(tline)
    i = i+1;
    tline = fgetl(fd);
    A{i} = tline;
  end
  
  % Close bashScript2.sh
  fclose(fd);
  
  % Change cluster directory (line 4)
  A{4} = strrep(A{4},'clusterDir',clusterDir);
  
  % Change model name (line 5)
  A{5} = strrep(A{5},'model',model);
  
  % Write cell A into bashScript2.sh 
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript2.sh'], 'w'); 

  for i = 1:numel(A)
      if A{i+1} == -1
          fprintf(fd,'%s', A{i});
          break
      else
          fprintf(fd,'%s\n', A{i});
      end
  end
  
  % Close bashScript2.sh
  fclose(fd); 
  
  % call bashScrip2.sh
  [out1,~] = system(["ssh church70@hypnos5 'bash -s' < ", myDirectory, "/bashScript2.sh"]);
  if out1 ~= 0
    uiwait(warndlg('Failed to make model directory on cluster'));
    return
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% upload folderName subdirectory
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
  % Change file permissions, Linux compatability of bashScript3.sh
  system(['cd ', path, 'optim/', model, '/', folderName, ';',...
    ' chmod 755 bashScript3.sh; sed -i ''s/\r//g'' bashScript3.sh']);
    
  % open bashScript3.sh
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript3.sh'], 'r');

  % Read bashScript3.sh into cell A
  i = 1;
  tline = fgetl(fd);
  A{i} = tline;
  while ischar(tline)
    i = i+1;
    tline = fgetl(fd);
    A{i} = tline;
  end
  
  % Close bashScript3.sh
  fclose(fd);
  
  % Change directory to be copied and target destination (line 4)
  A{4} = strrep(A{4},'myDirectory',myDirectory);
  A{4} = strrep(A{4},'clusterDir',clusterDir);
  A{4} = strrep(A{4},'model',model);
  
  % Write cell A into bashScript3.sh 
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript3.sh'], 'w'); 

  for i = 1:numel(A)
      if A{i+1} == -1
          fprintf(fd,'%s', A{i});
          break
      else
          fprintf(fd,'%s\n', A{i});
      end
  end
  
  % Close bashScript3.sh
  fclose(fd);
  
  % call bashScript3.sh
  [out1,out2] = system([myDirectory, "/bashScript3.sh"]);
  if out1 ~= 0
    uiwait(warndlg('Failed to upload project directory to cluster'));
    return
  end
  
  
endfunction