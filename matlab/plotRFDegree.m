function plotRFDegree(netType)
    h = figure;
    plotTitle = 'Degree RF Plot';
    subplot(3,2,1);
    fileName = strcat('indian_', netType, '.mat');
    [r, n] = plotDegreeRF(fileName);
    loglog(r,n, '.');
    xlabel('indian');
    hold on;
    subplot(3,2,2);
    fileName = strcat('italian_', netType, '.mat');
    [r, n] = plotDegreeRF(fileName);
    loglog(r,n, 'k.');
    xlabel('italian');
    subplot(3,2,3);
    fileName = strcat('spanish_', netType, '.mat');
    [r, n] = plotDegreeRF(fileName);
    loglog(r,n, 'r.');
    xlabel('spanish');
    subplot(3,2,4);
    fileName = strcat('mexican_', netType, '.mat');
    [r, n] = plotDegreeRF(fileName);
    loglog(r,n, 'g.');
    xlabel('mexican');
    subplot(3,2,5);
    fileName = strcat('chinese_', netType, '.mat');
    [r, n] = plotDegreeRF(fileName);
    loglog(r,n, 'm.');
    xlabel('chinese');
    subplot(3,2,6);
    fileName = strcat('french_', netType, '.mat');
    [r, n] = plotDegreeRF(fileName);
    loglog(r,n, 'c.');
    xlabel('french');
    annotation('textbox', [0 0.9 1 0.1], ...
                    'String', plotTitle, ...
                    'EdgeColor', 'none', ...
                    'HorizontalAlignment', 'center');
    savefig(h, strcat(plotTitle, '.fig'));
end
function [rank, numDegreesWithRank] = plotDegreeRF(matFile)
     load(matFile);
     data = degree;
     mulFactor = 1000;
     numNodesWithDeg = zeros(ceil(max(abs(data))*mulFactor)+1, 1);
     for i = 1:numel(data)
         deg = ceil(abs(data(i,1))*mulFactor);
         numNodesWithDeg(deg+1) = numNodesWithDeg(deg+1) + 1;
     end
     rank = sort(unique(numNodesWithDeg), 'descend');
     numDegreesWithRank = zeros(numel(rank),1);
     for i=1:numel(numNodesWithDeg)
         deg = i;
         freq = numNodesWithDeg(i);
         rankId = find(rank == freq);
         numDegreesWithRank(rankId) = numDegreesWithRank(rankId)+1;
     end
end