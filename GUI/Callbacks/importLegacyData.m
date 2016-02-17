function [] = importLegacyData(hObject, eventdata, handles)
% importLegacyData
% starts workflow for user to import legacy data

start = 'C:\';
title = 'Select Legacy Subject Directory';

subjectImportDir = uigetdir(start, title);

if subjectImportDir ~= 0 %dir successfully selected
    project = handles.localProject;
    
    project = project.importLegacyData(subjectImportDir, handles.localPath, handles.userName);
    
    handles.localProject = project;
end
    
    
    
    
    
    
    
    
    % select trial
    
    prompt = ['Select the trial to which the subject being imported belongs to. Import path: ', subjectImportDir];
    title = 'Select Trial';
    choices = project.getTrialChoices();
    
    [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
    
    if ~cancel
        if createNew
            trial = Trial(project.nextTrialNumber, project.existingTrialNumbers, handles.userName, handles.localPath, subjectImportDir);
        else
            trial = project.getTrialFromChoice(choice);
        end
        
        if ~isempty(trial)
            % select subject
            
            prompt = ['Select the subject to which the data being imported from ', importDir, ' belongs to.'];
            title = 'Select Subject';
            choices = trial.getSubjectChoices();
            
            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
            
            if ~cancel
                if createNew
                    suggestedSubjectNumber = getNumberFromFolderName(getFilename(importDir));
                    
                    if isnan(suggestedSubjectNumber)
                        suggestedSubjectNumber = trial.nextSubjectNumber();
                    end
                        
                    subject = trial.createNewSubject(suggestedSubjectNumber, trial.existingSubjectNumbers, trial.dirName, handles.localPath, importDir, handles.userName);
                else
                    subject = trial.getSubjectFromChoice(choice);
                end
                
                if ~isempty(subject)
                    dataFilename = createFilenameSection(TrialNamingConventions.DATA_FILENAME_LABEL, num2str(trial.trialNumber));
                    
                    % select raw data paths
                    counter = 1;
                    
                    while true
                        
                        if counter ~= 1
                            prompt = 'Would you like to import another location?';
                            title = 'Import Next Location';
                            yes = 'Yes';
                            no = 'No';
                            default = yes;
                            
                            response = questdlg(prompt, title, yes, no, default);
                            
                            if strcmp(response, no)
                                break;
                            end
                        end
                        
                        [cancel, rawDataPath, alignedDataPath, positiveAreaPath, negativeAreaPath] = selectLegacyDataPaths(subjectImportDir);
                        
                        % TODO: could add a path validation here
                        
                        if ~cancel && (~isempty(rawDataPath) || ~isempty(alignedDataPath) || ~isempty(positiveAreaPath) || ~isempty(negativeAreaPath))
                            paths = {rawDataPath, alignedDataPath, positiveAreaPath, negativeAreaPath};
                            
                            displayPath = ''; % we need a path to display to the user on the metadata entry GUIs just to remind them what's going on
                            
                            for i=1:length(paths)
                                if ~isempty(paths{i})
                                    displayPath = paths{i};
                                end
                            end
                            
                            % now that we for sure have some data to input, let's
                            % trawl some metadata
                            
                            if trial.subjectType.subjectClassType == SubjectClassType.Natural
                                % select eye
                                prompt = ['Select the eye to which the data being imported from ', eyeImportPath, ' belongs to.'];
                                title = 'Select Eye';
                                choices = subject.getEyeChoices();
                                
                                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                                
                                if ~cancel
                                    if createNew
                                        suggestedEyeNumber = getNumberFromFolderName(folderName);
                                        
                                        if isnan(suggestedEyeNumber)
                                            suggestedEyeNumber = subject.getNextEyeNumber();
                                        end
                                        
                                        eye = Eye(suggestedEyeNumber, subject.existingEyeNumbers(), toSubjectProjectPath, projectPath, subjectImportPath, userName);
                                    else
                                        eye = subject.getEyeFromChoice(choice);
                                    end
                                    
                                    if ~isempty(eye)
                                        eyeProjectPath = makePath(toSubjectProjectPath, eye.dirName);
                                        
                                        % select quarter
                                        prompt = ['Select the quarter to which the data being imported from ', displayPath, ' belongs to.'];
                                        title = 'Select Quarter';
                                        choices = eye.getQuarterChoices();
                                        
                                        [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                                        
                                        if ~cancel
                                            if createNew
                                                suggestedEyeNumber = getNumberFromFolderName(folderName);
                                                
                                                if isnan(suggestedEyeNumber)
                                                    suggestedEyeNumber = subject.getNextEyeNumber();
                                                end
                                                
                                                quarter = Quarter(suggestedEyeNumber, eye.existingQuarterNumbers(), toEyeProjectPath, projectPath, quarterImportPath, userName);
                                            else
                                                quarter = eye.getQuarterFromChoice(choice);
                                            end
                                            
                                            if ~isempty(quarter)
                                                quarterProjectPath = makePath(toEyeProjectPath, quarter.dirName);
                                                
                                                quarter = quarter.importQuarter(quarterProjectPath, quarterImportPath, projectPath, dataFilename, userName, subjectType, eye.eyeType);
                                                
                                                eye = eye.updateQuarter(quarter);
                                            end
                                        end
                                        
                                        subject = subject.updateEye(eye);
                                    end
                                end
                                
                                
                                
                                
                                
                            elseif trial.subjectType.subjectClassType == SubjectClassType.Artifical
                                
                            end
                        end
                    end
                    
                    
                    
                    
                    
                    trial = trial.updateSubject(subject);
                    project = project.updateTrial(trial);
                end
            end      
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    %have user select trial that subject is from
    trialChoices = project.getTrialChoices();
    
    name = 'Select Trial';
    listSize = [160, 150];
    promptString = 'Please select the trial that this data is from.';
    
    [selection, ok] = listdlg('ListString', trialChoices, 'SelectionMode', 'single', 'ListSize', listSize, 'PromptString', promptString, 'Name', name);
    
    if ok
        trial = project.getTrialFromChoice(selection);
        
        prompt = ['Please select the subject that corresponds to the selected legacy subject directory (', subjectImportDir, '):'];
        title = 'Select Subject';
        choices = trial.getSubjectChoices();
        
        [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
        
        if ~cancel
            if createNew
                subject = trial.createNewSubject();
                
                subject = subject.enterMetadata(subjectImportDir, handles.userName);
                
                toTrialPath = makePath(handles.localPath, trial.dirName);
                
                subject = subject.createDirectories(toTrialPath, handles);
                
                saveToBackup = true;
                subject.saveMetadata(makePath(toTrialPath, subject.dirName), handles, saveToBackup);
            else
                subject = trial.getSelectedSubject(choice);
            end
            
            counter = 1;
            
            while true
                
                if counter ~= 1
                    prompt = 'Would you like to import another location?';
                    title = 'Import Next Location';
                    yes = 'Yes';
                    no = 'No';
                    default = yes;
                    
                    response = questdlg(prompt, title, yes, no, default);
                    
                    if strcmp(response, no)
                        break;
                    end
                end
                
                [cancel, rawDataPath, alignedDataPath, positiveAreaPath, negativeAreaPath] = selectLegacyDataPaths(subjectImportDir);
                
                % TODO: could add a path validation here
                
                if ~cancel && (~isempty(rawDataPath) || ~isempty(alignedDataPath) || ~isempty(positiveAreaPath) || ~isempty(negativeAreaPath))
                    paths = {rawDataPath, alignedDataPath, positiveAreaPath, negativeAreaPath};
                    
                    displayPath = ''; % we need a path to display to the user on the metadata entry GUIs just to remind them what's going on
                    
                    for i=1:length(paths)
                        if ~isempty(paths{i})
                            displayPath = paths{i};
                        end
                    end                    
                    
                    % now that we for sure have some data to input, let's
                    % trawl some metadata
                    
                    if trial.subjectType.subjectClassType == SubjectClassType.Natural
                        % get eye
                        prompt = 'Please select the eye that this location was from:';
                        title = 'Select Eye';
                        choices = subject.getEyeChoices();
                        
                        [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                        
                        if ~cancel
                            if createNew
                                eye = Eye;
                                
                                eye = eye.enterMetadata(displayPath, handles.userName);
                                
                                toSubjectPath = makePath(toTrialPath, subject.dirName);
                                
                                eye = eye.createDirectories(toSubjectPath, handles);
                                
                                saveToBackup = true;
                                eye.saveMetadata(makePath(toSubjectPath, eye.dirName), handles, saveToBackup);
                            else
                                eye = subject.getSelectedEye(choice);
                            end
                            
                            % get quarter
                            prompt = 'Please select the quarter that this location was from:';
                            title = 'Select Quarter';
                            choices = eye.getQuarterChoices();
                            
                            [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                            
                            if ~cancel
                                if createNew
                                    quarter = Quarter;
                                    
                                    quarter = quarter.enterMetadata(displayPath, handles.userName);
                                    
                                    toEyePath = makePath(toSubjectPath, eye.dirName);
                                    
                                    quarter = quarter.createDirectories(toEyePath, handles);
                                    
                                    saveToBackup = true;
                                    quarter.saveMetadata(makePath(toEyePath, quarter.dirName), handles, saveToBackup);
                                else
                                    quarter = eye.getSelectedQuarter(choice);
                                end
                                
                                % get location
                                prompt = 'Please select the location that this data was from:';
                                title = 'Select Location';
                                choices = quarter.getLocationChoices();
                                
                                [choice, cancel, createNew] = selectEntryOrCreateNew(prompt, title, choices);
                                
                                if ~cancel
                                    if createNew
                                        location = Location;
                                        
                                        location = location.enterMetadata(displayPath, handles.userName);
                                        
                                        toQuarterPath = makePath(toEyePath, quarter.dirName);
                                        
                                        location = location.createDirectories(toQuarterPath, handles);
                                        
                                        saveToBackup = true;
                                        location.saveMetadata(makePath(toQuarterPath, location.dirName), handles, saveToBackup);
                                    else
                                        location = quarter.getSelectedLocation(choice);
                                    end
                                    
                                    % import raw data
                                end
                            end
                        end
                    end
                    
                
                counter = counter + 1;
            end
        end
    end
end


end

