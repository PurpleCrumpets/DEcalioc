
close all


for j = 1:size(results,2)
  resultsLoop = results(j);
  lengthResults = size(resultsLoop{1},2);

  for i = 1:lengthResults
    outputLoop(i,1) = cell2mat({resultsLoop{1}.time}(1,i));
    outputLoop(i,2) = cell2mat({resultsLoop{1}.angle_av}(1,i));
    outputLoop(i,3) = cell2mat({resultsLoop{1}.angle_nnl}(1,i));
  end

  figure(j)
  plot(outputLoop(:,1),outputLoop(:,2),outputLoop(:,1),outputLoop(:,3))
  legend('angle av','angle nnl')

end


%results1 = results(1);
%lengthResults = size({results{1}.angle_av},2);