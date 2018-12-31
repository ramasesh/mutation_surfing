% Range-expansion simulation
% Vinay Ramasesh, 4/26/2015


tic
close all

Nr = 25; %grid size, number of rows
Nc = 100; %grid size, number of columns
Ns = 10; %max number of individuals who can exist in a given cell
mu = 1.8; %mean number of babies an individual has
%Mutation details:

mutantRow = 0;
mutantCol = 0;
popInMutantDeme = 0;

%MIGRATION THRESHOLDS:
pMig = 0.4; %probability of migration
%interior cell thresholds
intMigLeft = pMig/4;
intMigRight = 2*pMig/4;
intMigUp = 3*pMig/4;
intMigDown = pMig;
%outer row/col cell thresholds
extMig1 = pMig/3;
extMig2 = 2*pMig/3;
extMig3 = pMig;
%corner cell thresholds
corMig1 = pMig/2;
corMig2 = pMig;


for mutateLoc = 30:10:80
    
    successCount = 0;
    saveCount = 0;
    
    for numSim = 1:1000
        
        %Create the earth
        earthNorm = zeros(Nr,Nc);
        earthMutants = zeros(Nr,Nc);
        
        %Randomly populate with one individual:
        startLoc = randi([1 Nr]);
        earthNorm(startLoc,1) = 1;
        
        %is the simulation done, and was it successful?
        isDone = 0;
        isSuccess = 0;
        
        %has the mutation happened?
        haveMutated = 0;
        
        %where is the wavefront?
        wavefront = zeros(Nr,1);
        wavefront(startLoc) = 1;
        
        %evolve:
        while(not(isDone))
            isSuccess = 0;
            %have babies
            earthNorm = poissrnd(mu*earthNorm);
            
            %migrate
            earthNormTemp = zeros(size(earthNorm));
            %migrate the interior
            for i = 2:(Nr-1)
                for j = 2:(Nc-1)
                    for k = 1:earthNorm(i,j)
                        mig = rand;
                        if mig < intMigLeft
                            earthNormTemp(i,j-1) = earthNormTemp(i,j-1)+1;
                        elseif mig < intMigRight
                            earthNormTemp(i,j+1) = earthNormTemp(i,j+1)+1;
                            %maybe update wavefront?
                            if j+1 > wavefront(i)
                                wavefront(i) = j+1;
                            end
                        elseif mig < intMigUp
                            earthNormTemp(i-1,j) = earthNormTemp(i-1,j)+1;
                            %maybe update wavefront?
                            if j > wavefront(i-1)
                                wavefront(i-1) = j;
                            end
                        elseif mig < intMigDown
                            earthNormTemp(i+1,j) = earthNormTemp(i+1,j)+1;
                            %maybe update wavefront?
                            if j > wavefront(i+1)
                                wavefront(i+1) = j;
                            end
                        else
                            earthNormTemp(i,j) = earthNormTemp(i,j)+1;
                        end
                    end
                end
            end
            %migrate the left side
            for i = 2:(Nr-1)
                for k = 1:earthNorm(i,1)
                    mig = rand;
                    if mig < extMig1 %go Up
                        earthNormTemp(i-1,1) = earthNormTemp(i-1,1)+1;
                        %maybe update wavefront?
                        if 1 > wavefront(i-1)
                            wavefront(i-1) = 1;
                        end
                    elseif mig < extMig2 %go Right
                        earthNormTemp(i,2) = earthNormTemp(i,2)+1;
                        %maybe update wavefront?
                        if 2 > wavefront(i)
                            wavefront(i) = 2;
                        end
                    elseif mig < extMig3 %go Down
                        earthNormTemp(i+1,1) = earthNormTemp(i+1,1)+1;
                        %maybe update wavefront?
                        if 1 > wavefront(i+1)
                            wavefront(i+1) = 1;
                        end
                    else %stay
                        earthNormTemp(i,1) = earthNormTemp(i,1)+1;
                    end
                end
            end
            %migrate the right side
            for i = 2:(Nr-1)
                for k = 1:earthNorm(i,Nc)
                    mig = rand;
                    if mig < extMig1 %go Up
                        earthNormTemp(i-1,Nc) = earthNormTemp(i-1,Nc)+1;
                        %maybe update wavefront?
                        if Nc > wavefront(i-1)
                            wavefront(i-1) = Nc;
                        end
                    elseif mig < extMig2 %go Left
                        earthNormTemp(i,Nc-1) = earthNormTemp(i,Nc-1)+1;
                    elseif mig < extMig3 %go Down
                        earthNormTemp(i+1,Nc) = earthNormTemp(i+1,Nc)+1;
                        %maybe update wavefront?
                        if Nc > wavefront(i+1)
                            wavefront(i+1) = Nc;
                        end
                    else %stay
                        earthNormTemp(i,Nc) = earthNormTemp(i,Nc)+1;
                    end
                end
            end
            %migrate the top side
            for i = 2:(Nc-1)
                for k = 1:earthNorm(1,i)
                    mig = rand;
                    if mig < extMig1 %go Left
                        earthNormTemp(1,i-1) = earthNormTemp(1,i-1)+1;
                    elseif mig < extMig2 %go Down
                        earthNormTemp(2,i) = earthNormTemp(2,i)+1;
                        %maybe update wavefront?
                        if i > wavefront(2)
                            wavefront(2) = i;
                        end
                    elseif mig < extMig3 %go Right
                        earthNormTemp(1,i+1) = earthNormTemp(1,i+1)+1;
                        %maybe update wavefront?
                        if i+1 > wavefront(1)
                            wavefront(1) = i+1;
                        end
                    else %stay
                        earthNormTemp(1,i) = earthNormTemp(1,i)+1;
                    end
                end
            end
            %migrate the bottom side
            for i = 2:(Nc-1)
                for k = 1:earthNorm(end,i)
                    mig = rand;
                    if mig < extMig1 %go Left
                        earthNormTemp(end,i-1) = earthNormTemp(end,i-1)+1;
                    elseif mig < extMig2 %go Up
                        earthNormTemp(end-1,i) = earthNormTemp(end-1,i)+1;
                        %maybe update wavefront?
                        if i > wavefront(end-1)
                            wavefront(end-1) = i;
                        end
                    elseif mig < extMig3 %go Right
                        earthNormTemp(end,i+1) = earthNormTemp(end,i+1)+1;
                        %maybe update wavefront?
                        if i+1 > wavefront(end)
                            wavefront(end) = i+1;
                        end
                    else %stay
                        earthNormTemp(end,i) = earthNormTemp(end,i)+1;
                    end
                end
            end
            %migrate the top-left corner
            for k = 1:earthNorm(1,1)
                mig = rand;
                if mig < corMig1
                    earthNormTemp(1,2) = earthNormTemp(1,2)+1;
                    %maybe update wavefront?
                    if 2 > wavefront(1)
                        wavefront(1) = 2;
                    end
                elseif mig < corMig2
                    earthNormTemp(2,1) = earthNormTemp(2,1)+1;
                    %maybe update wavefront?
                    if 1 > wavefront(2)
                        wavefront(2) = 1;
                    end
                else
                    earthNormTemp(1,1) = earthNormTemp(1,1)+1;
                end
            end
            %migrate the top-right corner
            for k = 1:earthNorm(1,end)
                mig = rand;
                if mig < corMig1
                    earthNormTemp(1,end-1) = earthNormTemp(1,end-1)+1;
                elseif mig < corMig2
                    earthNormTemp(2,end) = earthNormTemp(2,end)+1;
                    %maybe update wavefront?
                    if Nc > wavefront(2)
                        wavefront(2) = Nc;
                    end
                else
                    earthNormTemp(1,end) = earthNormTemp(1,end)+1;
                end
            end
            %migrate the bottom-left corner
            for k = 1:earthNorm(end,1)
                mig = rand;
                if mig < corMig1
                    earthNormTemp(end,2) = earthNormTemp(end,2)+1;
                    %maybe update wavefront?
                    if 2 > wavefront(end)
                        wavefront(end) = 2;
                    end
                elseif mig < corMig2
                    earthNormTemp(end-1,1) = earthNormTemp(end-1,1)+1;
                    %maybe update wavefront?
                    if 1 > wavefront(end-1)
                        wavefront(end-1) = 1;
                    end
                else
                    earthNormTemp(end,1) = earthNormTemp(end,1)+1;
                end
            end
            %migrate the bottom-right corner
            for k = 1:earthNorm(end,end)
                mig = rand;
                if mig < corMig1
                    earthNormTemp(end,end-1) = earthNormTemp(end,end-1)+1;
                    %maybe update wavefront?
                    if Nc > wavefront(end-1)
                        wavefront(end-1) = Nc;
                    end
                elseif mig < corMig2
                    earthNormTemp(end-1,end) = earthNormTemp(end-1,end)+1;
                else
                    earthNormTemp(end,end) = earthNormTemp(end,end)+1;
                end
            end
            
            earthNorm = earthNormTemp;
            
            %the wavefront might have zeros
            for i = 1:length(wavefront)
                if not(wavefront(i) == 0)
                    if earthNorm(i,wavefront(i)) == 0
                        if wavefront(i) == 1
                            wavefront(i) = 0;
                        else
                            j = 1;
                            corrected = 0;
                            while(not(corrected))
                                if not(earthNorm(i,wavefront(i)-j) == 0)
                                    wavefront(i) = wavefront(i) - j;
                                    corrected = 1;
                                else
                                    j = j+1;
                                    if j == wavefront(i)
                                        corrected = 1;
                                        wavefront(i) = 0;
                                    end
                                    
                                end
                            end
                        end
                    end
                end
            end
            
            %if we've induced the mutation, we also have to evolve the mutants:
            if(haveMutated)
                earthMutants = poissrnd(mu*earthMutants);
                %migrate
                earthMutantTemp = zeros(Nr,Nc);
                %migrate the interior
                for i = 2:(Nr-1)
                    for j = 2:(Nc-1)
                        for k = 1:earthMutants(i,j)
                            mig = rand;
                            if mig < intMigLeft
                                earthMutantTemp(i,j-1) = earthMutantTemp(i,j-1)+1;
                            elseif mig < intMigRight
                                earthMutantTemp(i,j+1) = earthMutantTemp(i,j+1)+1;
                            elseif mig < intMigUp
                                earthMutantTemp(i-1,j) = earthMutantTemp(i-1,j)+1;
                            elseif mig < intMigDown
                                earthMutantTemp(i+1,j) = earthMutantTemp(i+1,j)+1;
                            else
                                earthMutantTemp(i,j) = earthMutantTemp(i,j)+1;
                            end
                        end
                    end
                end
                %migrate the left side
                for i = 2:(Nr-1)
                    for k = 1:earthMutants(i,1)
                        mig = rand;
                        if mig < extMig1 %go Up
                            earthMutantTemp(i-1,1) = earthMutantTemp(i-1,1)+1;
                        elseif mig < extMig2 %go Right
                            earthMutantTemp(i,2) = earthMutantTemp(i,2)+1;
                        elseif mig < extMig3 %go Down
                            earthMutantTemp(i+1,1) = earthMutantTemp(i+1,1)+1;
                        else %stay
                            earthMutantTemp(i,1) = earthMutantTemp(i,1)+1;
                        end
                    end
                end
                %migrate the right side
                for i = 2:(Nr-1)
                    for k = 1:earthMutants(i,Nc)
                        mig = rand;
                        if mig < extMig1 %go Up
                            earthMutantTemp(i-1,Nc) = earthMutantTemp(i-1,Nc)+1;
                        elseif mig < extMig2 %go Left
                            earthMutantTemp(i,Nc-1) = earthMutantTemp(i,Nc-1)+1;
                        elseif mig < extMig3 %go Down
                            earthMutantTemp(i+1,Nc) = earthMutantTemp(i+1,Nc)+1;
                        else %stay
                            earthMutantTemp(i,Nc) = earthMutantTemp(i,Nc)+1;
                        end
                    end
                end
                %migrate the top side
                for i = 2:(Nc-1)
                    for k = 1:earthMutants(1,i)
                        mig = rand;
                        if mig < extMig1 %go Left
                            earthMutantTemp(1,i-1) = earthMutantTemp(1,i-1)+1;
                        elseif mig < extMig2 %go Down
                            earthMutantTemp(2,i) = earthMutantTemp(2,i)+1;
                        elseif mig < extMig3 %go Right
                            earthMutantTemp(1,i+1) = earthMutantTemp(1,i+1)+1;
                        else %stay
                            earthMutantTemp(1,i) = earthMutantTemp(1,i)+1;
                        end
                    end
                end
                %migrate the bottom side
                for i = 2:(Nc-1)
                    for k = 1:earthMutants(end,i)
                        mig = rand;
                        if mig < extMig1 %go Left
                            earthMutantTemp(end,i-1) = earthMutantTemp(end,i-1)+1;
                        elseif mig < extMig2 %go Up
                            earthMutantTemp(end-1,i) = earthMutantTemp(end-1,i)+1;
                        elseif mig < extMig3 %go Right
                            earthMutantTemp(end,i+1) = earthMutantTemp(end,i+1)+1;
                        else %stay
                            earthMutantTemp(end,i) = earthMutantTemp(end,i)+1;
                        end
                    end
                end
                %migrate the top-left corner
                for k = 1:earthMutants(1,1)
                    mig = rand;
                    if mig < corMig1
                        earthMutantTemp(1,2) = earthMutantTemp(1,2)+1;
                    elseif mig < corMig2
                        earthMutantTemp(2,1) = earthMutantTemp(2,1)+1;
                    else
                        earthMutantTemp(1,1) = earthMutantTemp(1,1)+1;
                    end
                end
                %migrate the top-right corner
                for k = 1:earthMutants(1,end)
                    mig = rand;
                    if mig < corMig1
                        earthMutantTemp(1,end-1) = earthMutantTemp(1,end-1)+1;
                    elseif mig < corMig2
                        earthMutantTemp(2,end) = earthMutantTemp(2,end)+1;
                    else
                        earthMutantTemp(1,end) = earthMutantTemp(1,end)+1;
                    end
                end
                %migrate the bottom-left corner
                for k = 1:earthMutants(end,1)
                    mig = rand;
                    if mig < corMig1
                        earthMutantTemp(end,2) = earthMutantTemp(end,2)+1;
                    elseif mig < corMig2
                        earthMutantTemp(end-1,1) = earthMutantTemp(end-1,1)+1;
                    else
                        earthMutantTemp(end,1) = earthMutantTemp(end,1)+1;
                    end
                end
                %migrate the bottom-right corner
                for k = 1:earthMutants(end,end)
                    mig = rand;
                    if mig < corMig1
                        earthMutantTemp(end,end-1) = earthMutantTemp(end,end-1)+1;
                    elseif mig < corMig2
                        earthMutantTemp(end-1,end) = earthMutantTemp(end-1,end)+1;
                    else
                        earthMutantTemp(end,end) = earthMutantTemp(end,end)+1;
                    end
                end
                
                earthMutants = earthMutantTemp;
                
            end
            
            
            %cull with carrying capacity Ns
            for i = 1:Nr
                for j = 1:Nc
                    if earthNorm(i,j) + earthMutants(i,j) > Ns
                        %time to kill some individuals
                        
                        dice = rand([1 (earthNorm(i,j)+earthMutants(i,j))]);
                        discriminant = sort(dice);
                        discriminant = discriminant(Ns);
                        %if an individual has a number less than or equal to Ns,
                        %he's safe.  Otherwise, he's gone.
                        normals = 0;
                        mutants = 0;
                        for k = 1:earthNorm(i,j)
                            if dice(k) <= discriminant
                                normals = normals+1;
                            end
                        end
                        for k = (earthNorm(i,j)+1):(earthNorm(i,j)+earthMutants(i,j))
                            if dice(k) <= discriminant
                                mutants = mutants+1;
                            end
                        end
                        earthNorm(i,j) = normals;
                        earthMutants(i,j) = mutants;
                        
                    end
                end
            end
            
            %is it time to induce the mutation?
            numFrontIndividuals = zeros(Nr,1);
            if not(haveMutated)
                if max(earthNorm(:,mutateLoc)) > 0
                    %induce the mutation on the wavefront somewhere
                    %first figure out how many individuals are on the wavefront
                    if wavefront(1) == 0
                        numFrontIndividuals(1) = 0;
                    else
                        numFrontIndividuals(1) = earthNorm(1,wavefront(1));
                    end
                    
                    for i = 2:Nr
                        if wavefront(i) == 0
                            numFrontIndividuals(i) = numFrontIndividuals(i-1);
                        else
                            numFrontIndividuals(i) = numFrontIndividuals(i-1) + earthNorm(i,wavefront(i));
                        end
                    end
                    
                    %now induce mutation
                    mutInd = randi([1 numFrontIndividuals(Nr)]);
                    if mutInd <= numFrontIndividuals(1)
                        earthMutants(1,wavefront(1)) = 1;
                        earthNorm(1,wavefront(1)) = earthNorm(1,wavefront(1)) - 1;
                        mutantRow = 1;
                        mutantCol = wavefront(1);
                    else
                        for i = 2:Nr
                            if and(numFrontIndividuals(i-1) < mutInd, mutInd <= numFrontIndividuals(i))
                                earthMutants(i,wavefront(i)) = 1;
                                earthNorm(i,wavefront(i)) = earthNorm(i,wavefront(i)) - 1;
                                mutantRow = i;
                                mutantCol = wavefront(i);
                            end
                        end
                    end
                    haveMutated = 1;
                    popInMutantDeme = earthNorm(mutantRow,mutantCol)+1;
                end
            end
            
            
            %has the wavefront reached the end?
            for l = 1:Nr
                if earthNorm(l,Nc) > 0
                    isDone = 1;
                    isSuccess = 1;
                end
            end
            %have all the individuals died?
            if max(max(earthNorm)) == 0
                isDone = 1;
                isSuccess = 0;
            end
            %are all the mutants dead?
            if and(haveMutated,max(max(earthMutants))==0)
                isDone = 1;
                isSuccess = 0;
            end
        end
        successCount = successCount + isSuccess;
        
        if isSuccess
            filename = ['Sim' num2str(mutateLoc) '/Success' num2str(saveCount)];
            save(filename,'earthNorm','earthMutants','mutantRow','mutantCol','popInMutantDeme');
            saveCount = saveCount+1;
        end
    end

end

 



