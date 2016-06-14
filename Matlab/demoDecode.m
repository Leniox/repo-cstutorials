% DEMO DECODING PROGRAM

% Research Question: "Given the firing rate of a collection of neurons at a
% given point in time, is it possible to know which type of cue (or probe)
% is being presented to the test subject?"

% Firing Rate: Neurons "fire" by sending an electrical impulse down their
% axon, which can be recorded. The number of impulses or action potentials
% that occur within 50ms is a cell's firing rate.

% Trial: Presentation of visual stimuli requiring a response from the test
% subject. Electrical activity (firing rate) is recorded from an ensemble
% of neurons during a trial.

% Experiment: Series of trials with different types of cues and probes
% being presented to the test subject.

% Datapoint (i.e. row in a datafile): A time series of firing rates for a
% particular cell during a particular trial (which presented 1 of 2 types of cues).

% Datafile (i.e. a file in folder "demoIn": Datapoints from a collection of
% cells simultaneously collected during an experiment.

% Statistics File: Contains the results of a statistical test (ANOVA) applied
% to each cell to determing if the firing rates for the two types of cues
% are significantly different. Those cells that pass this filter will be
% used in the classifier training and testing.
%________________________________________________________________
%
% TRAINING and TESTING THE CLASSIFIER

% OUTPUT: Time course of percentage of trials predicted (classified)
% correctly. Because there are 2 classes, "chance" is at 50% correct.

% In this version, a new data set is constructed for each time point
% in a trial that represents the activity of all cells active during
% a given point in a trial. A data point (row) in this newly constructed dataset
% consists of 1-3 time points from each cell that was recorded during
% a given trial. The number of time points depend on the variable
% decParams.binWindow. For example, if there are 11 cells that were
% recorded from during trial #5 and the binWindow = 3, then one
% datapoint in the data set for time 6 would consist of the firing
% rate of each of the 8 cells for time 4, 5 and 6 concatenated, 
% making a data point 3*8 = 24 features long. The same would be done
% for all trials to construct a complete set for classification.

% Algorithm ...
%   Using the statistics file, find a list of cells that can be used.
%   From the datafile, extract the data from only those cells in the list.
%   From the extracted data, compile a list of trials.
%   For each time point:
%       Dataset = [];
%       For each trial:
%           Extract the data for all cells recorded during that trial.
%           NEW POINT = [];
%           For each cell c recorded:
%               // with bin window=3, 3 time points are taken from each cell
%               NEW POINT = NEW POINT + [firing rates at t-2, t-1, t]
%               CLASS for NEW POINT = trial type
%           Dataset += NEW POINT
%       Train/Test using Leave-One-Out
%       Concatenate percentage correct to output.
%

dbstop if error;

% --------- SELECT WHICH TRIAL VARIABLE TO DECODE ---------
decParams.decodeVar = 'cue';  % cue stimulus
% decParams.decodeVar = 'probe';  % probe stimulus

% --------- ANALYSIS PARAMETERS ---------
decParams.sigLevel = 0.05;

%decParams.fixedTrain = 1;
decParams.fixedTrain = 0;

% ------------ The number of timepoints in a composed datapoint
decParams.binwindow = 3;

% SET PATHS, THIS IS OS/MACHINE DEPENDENT

% --- MATT'S DELL (superior computer)
%inputFilesPath = 'C:\mattFiles\CODE\DECODE demo\demoIn';
%outputFilesPath = 'C:\mattFiles\CODE\DECODE demo\demoOut';
%statFile = 'C:\mattFiles\CODE\DECODE demo\demoIn\stats\demoStat.mat';

% --- AMY's MAC (inferior computer)
 inputFilesPath = '/Users/amylarson/Documents/__Coding/__DecodeDemo/demoIn';
 outputFilesPath = '/Users/amylarson/Documents/__Coding/__DecodeDemo/demoOut';
 statFile = '/Users/amylarson/Documents/__Coding/__DecodeDemo/demoStat.mat';

% statsFile loads 2 variables:
%   statsOut (data): cell# , channel, Cue pValue, Probe pValue, Cue pref, Probe pref
%   statCol : allows for indexing into the data using:
%       "cell" "chan" "cuePval" "probePval" "cuePref" "probePref"
load(statFile); % pvalue file

switch decParams.decodeVar
    
    case 'cue'
        % OBJECTIVE 1: make a matrix containing only CUE significant neurons from statsOut
        statsOut = statsOut(statsOut(:, statCol.cuePval) < decParams.sigLevel, :);
        
    case 'probe'
        % OBJECTIVE 2: make a matrix containing only PROBE significant neurons from statsOut
        statsOut = statsOut(statsOut(:, statCol.probePval) < decParams.sigLevel, :);
        
end

sigcells = statsOut(:, statCol.cell);

% ** Get all filenames located in inputFilesPath folder **
[fn fd] = demoListDir(inputFilesPath, '*.mat', 2);

% Datafiles load 2 variables:
%   winBin (data) : each row prefaced with cell/trial specific information
%   followed by the firing rates at each time step. "-11111" marks the
%   column just before the data starts.
%
%   standardCol (indexing) : allows indexing into each row including:
%       "area" "ens" "cell" "trial" "cue" "probe" "chan"
%       area = Prefrontal or Parietal Cortex
%       cue and probe values indicate the classification of that trial
%       ens and chan are experiment specific and can be ignored

% **************** LOOP THROUGH INPUT FILES, ACCUMULATE THE RIGHT NEURONS ****************
% ---- 'population' is a matrix that will accumulate all of the significant neurons loaded from input files
allData = [];
for ff = 1 : numel(fn)
    cd(inputFilesPath);
    
    % --------- load next file, which resets winBin to new dataset
    load(fn{ff});
    disp(fn{ff});
    
    % --------- select significant cells
    % Extract from winBin only those cells with significant differences
    % between trial types (as indicated by the pValue)
    winBin = winBin(ismember(winBin(:,standardCol.cell), sigcells), :);
    
    if isempty(winBin)
        continue;
    end
    
    % ---- Various details needed to extract the correct data ....
    startbin = decParams.binwindow;
    decParams.priors = 'empirical'; % uses only training data (should be same as calcFromAll when training with all data, including errors)
    FAILEDCLASS = -1;
    PAR = 1;
    PFC = 2;
    nDecodeVarCols = 3; % after std header, before post/decode tc: [bin actualval class]
    decParams.ctxstr = {'par', 'pfc'};
    decParams.taskstr = {'fix', 'balanced', 'prepotent', '?'};
    
    % ----- find column corresponding to first bin spike count
    firstBinCol = find(winBin(1, :) == -111111) + 1;
    
    % ----- find number of bins
    numbins = size(winBin,2) - firstBinCol + 1;
    
    decode_out = [];
    totalcells = numel(unique(winBin(:, standardCol.chan)));
    tr = tabulate(winBin(:, standardCol.trial));
    tr = sum(tr(:,2) > 0); % find number of total trials
    numctx = numel(unique(winBin(:, standardCol.area)));
    % allClass = zeros(tr*numbins*numctx, wbParams.lastHeaderCol + nDecodeVarCols + ...
    %     numel(unique(winBin(:,decodeCol))));
    allClass = [];
    cnt = 1;
    allsigcells = unique(winBin(:, standardCol.chan));
    nparcells = numel(allsigcells(allsigcells < 49));
    npfccells = numel(allsigcells(allsigcells >= 49));
    
    % *********** CORTEX LOOP ************
    % PFC = channels >= 49, PAR = channels 1-48 
    % (prefrontal vs parietal cortex)
    for ctx = PAR : PFC % 1 : 2
        
        % now we simply call the task- sig- cortex-selected data 'bindata'
        bindata = winBin(winBin(:, standardCol.area) == ctx, :);
        ncells = numel(unique(bindata(:,standardCol.cell)));
        
        if (ncells == 0)
            disp(['no ' decParams.ctxstr{ctx} ' cells']);
            continue;
        end
        
        % helper function demo_goodtabulate() builds histogram without
        % zeros. Returns [ trial#, count, % ].
        trialcounts = demo_goodtabulate(bindata(:,standardCol.trial));
        
        % determine the maximum number of cells for any given trial
        mx = max(trialcounts(:,2));
        % find those trials in which not all cells were active and remove
        % them from the data.
        excess_trials = trialcounts(trialcounts(:,2) < mx, 1);
        bindata(ismember(bindata(:,standardCol.trial), excess_trials), :) = [];
        decoding_cells = unique(bindata(:, standardCol.cell));
        ens = bindata(1, standardCol.ens);
        switch decParams.decodeVar
            case 'cue'
                % OBJECTIVE 1: make a matrix containing only CUE significant neurons from statsOut
                decodeCol = standardCol.cue;
            case 'probe'
                % OBJECTIVE 2: make a matrix containing only PROBE significant neurons from statsOut
                decodeCol = standardCol.probe;
        end
        decvar = double(ordinal(bindata(:,decodeCol))); % cast to double required
        
        % ** find prior probabilities for the decoded variable
        priors = tabulate(decvar);
        priors = priors(:,3) / 100; % 3rd col of tabulate is percent
        chanceprob = sum(priors.^2); % chance level is sum of squared priors, I think (based on simulations)
        
        % ******** DECODING ANALYSIS *********
        thesetrials = unique(bindata(:, standardCol.trial));
        ntrials = numel(thesetrials);
        bindata = sortrows(bindata, [standardCol.cell standardCol.trial]);
        
        % ***** PICK ARBITRARY BIN FOR TRAINING OFF-TIME DECODE ******
        %________________________________________________________________

        % Modify the code so that a classifier is constructed from a single
        % time point, then applied to all time points. One simple approach
        % would be to essentially copy the construction of the training
        % matrix below (withn the "for bin ..." loop), and use that in the
        % train/test portion instead of constructing a new training set for
        % each time point (also in the loop below).
        if ( 1 == decParams.fixedTrain)
            trainBin = 65;
            % here is where you would construct a fixed training set
        end
        %________________________________________________________________
 
        % ***** do the analysis ******
        for bin = startbin : numbins
            
            %dispevery(bin, 10, 'bins', numbins);
            if ( mod( bin, 10 ) == 0 )
                disp( [ num2str(bin) ' bins of ' num2str(numbins) ] );
            end;
            
            % **** get data from this bin ****
            these_spikes = [];  decodeval = zeros(ntrials,1);
            
            % ** put the spikes (or rates) in the format classify uses:
            % rows = observations (trials), columns = predictors/features (firing rates)
            % get every ntrials row (one for each cell, at the current observation)
            % (data has been sorted by cells then trials -- should be equal # trials/cell)
            for tt = 1 : ntrials
                if (decParams.binwindow == 1)
                    these_spikes(tt, :) = bindata(tt : ntrials : end, firstBinCol + bin - 1)';
                else
                    these_spikes(tt, :) = reshape(bindata(tt : ntrials : end, ...
                        firstBinCol + bin - decParams.binwindow : firstBinCol + bin - 1)', ...
                        1, ncells*decParams.binwindow);
                end
                decodeval(tt) = decvar(tt); % redundant, now with introduction of decval
            end
            
            % ** now classify (leave-one-out) **
            allclass = []; allval = [];
            for kk = 1 : ntrials
                
                % leave trial "kk" out for testing
                train = these_spikes;
                train(kk, :) = []; % get rid of the test trial
                test = these_spikes(kk, :);
                
                % create a column vector of classification for each trial
                trainval = decodeval;
                trainval(kk) = []; % get rid of test trial
                actualval = decodeval(kk);
                
                % remove cells (columns) from training and sample matrices with zero rate in training matrix
                % first find cols with less than 2 spikes in training, and remove these
                % columns from both sample and training matrices
                train_sums = sum(train);
                inactive_cells = find(train_sums <= 1);
                train(:, inactive_cells) = [];
                test(inactive_cells) = [];
                
                % Below is where the train/test happens. If you want to use
                % a fixed train set, used that instead of the one
                % constructed in the section above.
                
                try
                    if (strcmp(decParams.priors, 'empirical'))
                        [class, err, post] = classify(test, train, trainval, 'diaglinear', 'empirical');
                    else % use priors calculated from all data above
                        [class, err, post] = classify(test, train, trainval, 'diaglinear', priors);
                    end
                catch classifyerror
                    % possible solution to "pooled variances of TRAINING must be
                    % positive" error: get rid of cells that only have activity for
                    % one of the outputs
                    spam = grpstats(train, trainval);
                    spam2 = sum(spam ~= 0);
                    badcells = spam2 == 1;
                    test(:, badcells) = [];
                    train(:, badcells) = [];
                    try
                        if (strcmp(decParams.priors, 'empirical'))
                            [class, err, post] = classify(test, train, trainval, 'diaglinear', 'empirical');
                        else % use priors calculated from all data above
                            [class, err, post] = classify(test, train, trainval, 'diaglinear', priors);
                        end
                    catch classifyerror2 % bad things happened
                        class = FAILEDCLASS; % make a note of it
                        post = priors'; % priors are chance
                    end
                end
                
                % if there was no activity this bin, class will be empty
                if (isempty(class))
                    class = FAILEDCLASS; % make a note of it
                    post = priors'; % priors are chance
                end
                % thisClass cols:
                % standardCol headers throuh 41 (change cell to ncells)
                % 42: bin, 43: actualvalue, 44: classified value
                % 45->: posteriors (depending on # values, usually 2)
                % kk index should work here because of the previous sorting
                lastHeaderCol = find(bindata(1, :) == -111111);
                thisClass = [bindata(kk,[1:lastHeaderCol]) bin actualval class post];
                thisClass(standardCol.cell) = ncells;
                
                % decode-specific columns
                decol = standardCol;
                decol.ncells = decol.cell; % cell # unused, put ncells here
                decol.bin = lastHeaderCol + 1;         % 42 - allClass
                decol.nbins =lastHeaderCol + 1;       % 42 - decode_out
                decol.actualVal = lastHeaderCol + 2;   % 43
                decol.classVal = lastHeaderCol + 3;    % 44
                
                decol.lastHeaderCol = lastHeaderCol + 3;    % 44
                
                % decoding output
                decol.startPost = lastHeaderCol + 4;   % 45 - allClass
                decol.startDecode = lastHeaderCol + 4; % 45 - decode_out
                
                allClass(cnt,:) = thisClass; % uppercase is to be saved
                cnt = cnt + 1;
                
                allclass = [allclass; class]; % lower case allclass/class is per bin class success
                
            end % for each trial (leave-one-out)
            
            % calculate average accuracy at this bin, unless all trials failed
            if (mean(allclass) ~= FAILEDCLASS)
                acc(bin) = mean(allclass(allclass ~= FAILEDCLASS) == decodeval(allclass ~= FAILEDCLASS));
            else
                acc(bin) = chanceprob;
            end
            
        end % for each bin
        
    end % for each cortex in the file
    
    allData = [allData; allClass];
    
end

% -------- ANALYZE allData
binsHere = unique(allData(:, decol.bin));
for bIndx = 1 : numel(binsHere)
    b = binsHere(bIndx);
    thisBinData = allData(allData(:, decol.bin) == b, :);
    hit = thisBinData(:, decol.actualVal) == thisBinData(:, decol.classVal);
    binCorrect(b) = sum(hit) / size(thisBinData, 1);
end




% --------- PLOT DECODING ACCURACY AS FUNCTION OF TIME IN TRIAL

figure;
minProb = 0.4;
maxProb = 1.0;
plot(binCorrect, 'r');
eventTimes = [20 40 60 70];  % times when cue comes on, goes off, probe comes on, goes off
axis([decParams.binwindow, numbins - (decParams.binwindow + 1), minProb, maxProb]);  %  reset ranges for x and y axes
set(gca, 'TickDir', 'out');                     %  switch side of axis for tick marks
lineX = [eventTimes ; eventTimes]; % matrix of x values of additional lines
lineBot = zeros(1, numel(eventTimes)) + minProb;
lineTop = zeros(1, numel(eventTimes)) + maxProb;
lineY = [lineTop; lineBot];
line(lineX, lineY, 'color', [0 0 0]);




