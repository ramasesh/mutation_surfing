figure
axis off
subplot(8,1,8) 
plot(1:nBins,centroidHisto10/max(centroidHisto10),1:nBins,mutantHisto10/max(mutantHisto10))

subplot(8,1,7) 
plot(1:100,centroidHisto20/max(centroidHisto20),1:100,mutantHisto20/max(mutantHisto20))

subplot(8,1,6) 
plot(1:nBins,centroidHisto30/max(centroidHisto30),1:nBins,mutantHisto30/max(mutantHisto30))

subplot(8,1,5) 
plot(1:nBins,centroidHisto40/max(centroidHisto40),1:nBins,mutantHisto40/max(mutantHisto40))

subplot(8,1,4) 
plot(1:nBins,centroidHisto50/max(centroidHisto50),1:nBins,mutantHisto50/max(mutantHisto50))

subplot(8,1,3) 
plot(1:nBins,centroidHisto60/max(centroidHisto60),1:nBins,mutantHisto60/max(mutantHisto60))

subplot(8,1,2) 
plot(1:nBins,centroidHisto70/max(centroidHisto70),1:nBins,mutantHisto70/max(mutantHisto70))
a = axes;
set(a,'xticklabel',[]);

subplot(8,1,1) 
plot(1:nBins,centroidHisto80/max(centroidHisto80),1:nBins,mutantHisto80/max(mutantHisto80))
set(gcf,'color','white')