function editBashScripts(model, folderName) 
  
  % editBashScripts.m
  %
  % Function to read in the bash script bashScript4.sh and edit the required
  % sections to successfully submit the job.sh script to the cluster.
  %
  %
  % Tim Churchfield
  %
  % Last edited: 04/11/2019
  
  
  global path clusterDir;
  myDirectory = [path, 'optim/', model, '/', folderName];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% bashScript4.sh
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Change file permissions, Linux compatability of bashScript4.sh
  system(['cd ', path, 'optim/', model, '/', folderName, ';',...
    ' chmod 755 bashScript4.sh; sed -i ''s/\r//g'' bashScript4.sh']);
    
  % open bashScript4.sh
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript4.sh'], 'r');

  % Read bashScript4.sh into cell A
  i = 1;
  tline = fgetl(fd);
  A{i} = tline;
  while ischar(tline)
    i = i+1;
    tline = fgetl(fd);
    A{i} = tline;
  end
  
  % Close bashScript4.sh
  fclose(fd);
  
  % Change cluster directory (line 3)
  A{3} = strrep(A{3},'clusterDir',clusterDir);
  
  % Change model name (line 3)
  A{3} = strrep(A{3},'model',model);
  
  % Change folder name (line 3)
  A{3} = strrep(A{3},'folderName',folderName);
  
 
  % Write cell A into bashScript4.sh 
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript4.sh'], 'w'); 

  for i = 1:numel(A)
      if A{i+1} == -1
          fprintf(fd,'%s', A{i});
          break
      else
          fprintf(fd,'%s\n', A{i});
      end
  end
  
  % Close bashScript4.sh
  fclose(fd); 
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% bashScript5.sh
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  % Change file permissions, Linux compatability of bashScript5.sh
  system(['cd ', path, 'optim/', model, '/', folderName, ';',...
    ' chmod 755 bashScript5.sh; sed -i ''s/\r//g'' bashScript5.sh']);
    
  % open bashScript5.sh
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript5.sh'], 'r');

  % Read bashScript5.sh into cell A
  i = 1;
  tline = fgetl(fd);
  A{i} = tline;
  while ischar(tline)
    i = i+1;
    tline = fgetl(fd);
    A{i} = tline;
  end
  
  % Close bashScript5.sh
  fclose(fd);
  
  % Change cluster directory (line 3)
  A{3} = strrep(A{3},'clusterDir',clusterDir);
  
  % Change model name (line 3)
  A{3} = strrep(A{3},'model',model);
  
  % Change folder name (lines 3,4)
  A{3} = strrep(A{3},'folderName',folderName);
  A{4} = strrep(A{4},'folderName',folderName);
  
 
  % Write cell A into bashScript5.sh 
  fd = fopen([path, 'optim/', model, '/', folderName, '/bashScript5.sh'], 'w'); 

  for i = 1:numel(A)
      if A{i+1} == -1
          fprintf(fd,'%s', A{i});
          break
      else
          fprintf(fd,'%s\n', A{i});
      end
  end
  
  % Close bashScript5.sh
  fclose(fd);
  
  
  
  
  
  
endfunction