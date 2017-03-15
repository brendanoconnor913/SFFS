function cols = sffs(trainlabels, traindata, testlabels, testdata)
% Function implements the sequential forward floating selection algorithm
% with the given labels and data

numfeat = []; % used for plotting output
accuracy = []; % used for plotting output
cols = []; % Vector for storing set of features we will use
maxacc = 0; % Variable to store maximum accuracy our algo provides
previtrmax = -1; % value < 0 to initialize loop
k = 1; % keep track of number of iterations
% need to stop when acc doesn't improve
while (maxacc > previtrmax) % If accuracy of prediction isn't increased stop
    previtrmax = maxacc; % Assign previous max value
    featureaddresults = zeros(1,size(traindata,2)); % store result of adding each feature
    for col = 1:length(featureaddresults)
        if (ismember(col, cols)) % If current feature in our set skip it
            continue;
        end
        newcols = cols;
        % Add new column to test resulting prediction
        newcols(end+1) = col; 
        data = traindata(:,newcols);
        SVMModel = fitcsvm(data,trainlabels);
        [label, score] = predict(SVMModel,testdata(:,newcols));

        % Evaluate accuracy of model
        resultlist = zeros(1,(length(testlabels)));
        for i = 1:length(testlabels)
            matches = (label(i) == testlabels(i));
            resultlist(1,i) = matches;
        end
        % Get precentage of rows that match between prediction and test
        % labels
        correctprct = (sum(resultlist)/size(resultlist,2)); 
        featureaddresults(col) = correctprct;
    end
    
    % If adding max feature increases accuracy add to our set of features
    [val, indx] = max(featureaddresults);
    if (val > maxacc)
        cols(end+1) = indx;
        maxacc = val;
    end

    updated = 1; % Value to initialize while loop
    while updated
        updated = 0;
        if (length(cols) > 1) % need atleast one vector or won't be able to predict
            featuresubtractresults = zeros(1,size(cols,2)); % vector for storing results
            for col = 1:length(featuresubtractresults)
                fewercols = cols;
                % remove the column from our set and evaluate
                fewercols(col) = []; 
                data = traindata(:,fewercols);
                SVMModel = fitcsvm(data,trainlabels);
                [label, score] = predict(SVMModel,testdata(:,fewercols));

                % Evaluate accuracy of model
                resultlist = zeros(1,(length(testlabels)));
                for i = 1:length(testlabels)
                  matches = (label(i) == testlabels(i));
                  resultlist(1,i) = matches;
                end
                correctprct = (sum(resultlist)/size(resultlist,2));
                featuresubtractresults(col) = correctprct;
            end
            
            % If max prediction from feature removal increases accuracy
            % remove from our set of features
            [valr, indxr] = max(featuresubtractresults);
            if (valr > maxacc)
                maxacc = valr;
                cols(indxr) = [];
                updated = 1;
            end
        end
    end
    
    % Display results after each iteration
    disp(strcat(string('After iteration '), string(k), ...
        string(' the max value of svm is at '), string(maxacc), ...
        string(' with the following columns: ')));
    disp(cols);
    k = k + 1;
    numfeat(end+1) = length(cols);
    accuracy(end+1) = (maxacc);
end

plot(numfeat,accuracy);