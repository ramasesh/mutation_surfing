figure
hold on

plot(1:nBins,centroidHisto10/max(centroidHisto10))%,1:nBins,mutantHisto10/max(mutantHisto10))

plot(1:nBins,centroidHisto20/max(centroidHisto20)+1)%,1:nBins,mutantHisto20/max(mutantHisto20)+1)

plot(1:nBins,centroidHisto30/max(centroidHisto30)+2)%,1:nBins,mutantHisto30/max(mutantHisto30)+2)

plot(1:nBins,centroidHisto40/max(centroidHisto40)+3)%,1:nBins,mutantHisto40/max(mutantHisto40)+3)

plot(1:nBins,centroidHisto50/max(centroidHisto50)+4)%,1:nBins,mutantHisto50/max(mutantHisto50)+4)

plot(1:nBins,centroidHisto60/max(centroidHisto60)+5)%,1:nBins,mutantHisto60/max(mutantHisto60)+5)

plot(1:nBins,centroidHisto70/max(centroidHisto70)+6)%,1:nBins,mutantHisto70/max(mutantHisto70)+6)

plot(1:nBins,centroidHisto80/max(centroidHisto80)+7)%,1:nBins,mutantHisto80/max(mutantHisto80)+7)

set(gcf,'color','white')