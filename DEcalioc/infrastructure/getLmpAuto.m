function getLmpAuto(model, folderName) 
  
  % getLmpAuto.m
  %
  % Function to copy the LIGGGHTS executable file (lmp_auto) from the SRC
  % directory and place it the current simulation directory.
  %
  %
  % Tim Churchfield
  %
  % Last edited: 25/10/2019
  
  
  
  global path;

  % ['find */src/lmp_auto -exec cp {} ', path_hypnos_sim projectname, '/ \;'];

  system(['cd ~/ ; find */src/lmp_auto -exec cp {} ', path, 'optim/', model, '/',...
    folderName, '/ \;'];
    
    
%    system(['cd ~/ ; find */src/lmp_auto -exec cp {} ', '~/GitHub/test2/DEcalioc/DEcalioc/optim/Lift100/0001alq_26338', '/ \;'];
%
%    '~/GitHub/test2/DEcalioc/DEcalioc/optim/Lift100/0001alq_26338'

  
  
endfunction