classdef BrainSection < FixedSample
    %BrainSection
    
    properties
        sectionAnatomy = ''; %the anatomy of where the brain section is from
        brainSectionNumber
    end
    
    methods
        
        function section = BrainSection(sampleNumber, existingSampleNumbers, brainSectionNumber, existingBrainSectionNumbers, toSubjectPath, projectPath, importPath, userName)
            if nargin > 0
                [cancel, section] = section.enterMetadata(sampleNumber, existingSampleNumbers, brainSectionNumber, existingBrainSectionNumbers, importPath, userName);
                
                if ~cancel
                    % set UUID
                    section.uuid = generateUUID();
                    
                    % set navigation listbox label
                    section.naviListboxLabel = section.generateListboxLabel();
                    
                    % make directory/metadata file
                    section = section.createDirectories(toSubjectPath, projectPath);
                    
                    % set metadata history
                    section.metadataHistory = MetadataHistoryEntry(userName, BrainSection.empty);
                    
                    % save metadata
                    saveToBackup = true;
                    section.saveMetadata(makePath(toSubjectPath, section.dirName), projectPath, saveToBackup);
                else
                    section = BrainSection.empty;
                end
            end
        end
        
        function [cancel, section] = enterMetadata(section, suggestedSampleNumber, existingSampleNumbers, suggestedBrainSectionNumber, existingBrainSectionNumbers, importPath, userName)
            isEdit = false;
            
            %Call to BrainSectionMetadataEntry GUI
            [...
                cancel,...
                sampleNumber,...
                brainSectionNumber,...
                source,...
                timeOfRemoval,...
                timeOfProcessing,...
                dateReceived,...
                storageLocation,...
                anatomy,...
                initFixative,...
                initPercent,...
                initTime,...
                secondFixative,...
                secondPercent,...
                secondTime,...
                notes]...
                = BrainSectionMetadataEntry(suggestedSampleNumber, existingSampleNumbers, suggestedBrainSectionNumber, existingBrainSectionNumbers, userName, importPath, isEdit);
            
            if ~cancel
                %Assigning values to Brain Section Properties
                section.sampleNumber = sampleNumber;
                section.brainSectionNumber = brainSectionNumber;
                section.source = source;
                section.timeOfRemoval = timeOfRemoval;
                section.timeOfProcessing = timeOfProcessing;
                section.dateReceived = dateReceived;
                section.storageLocation = storageLocation;
                section.sectionAnatomy = anatomy;
                section.initialFixative = initFixative;
                section.initialFixativePercent = initPercent;
                section.initialFixingTime = initTime;
                section.secondaryFixative = secondFixative;
                section.secondaryFixativePercent = secondPercent;
                section.secondaryFixingTime = secondTime;
                section.notes = notes;
            end
        end
        
         function dirName = generateDirName(section)            
            dirSubtitle = section.sectionAnatomy;
            
            dirName = createDirName(BrainSectionNamingConventions.DIR_PREFIX, section.brainSectionNumber, dirSubtitle, BrainSectionNamingConventions.DIR_NUM_DIGITS);
        end
        
        
        function label = generateListboxLabel(section)                    
            subtitle = section.sectionAnatomy;
            
            label = createNavigationListboxLabel(BrainSectionNamingConventions.NAVI_LISTBOX_PREFIX, section.brainSectionNumber, subtitle);
        end
        
        
        function section = generateFilenameSection(section)
            section = createFilenameSection(BrainSectionNamingConventions.DATA_FILENAME_LABEL, num2str(section.brainSectionNumber));
        end
                
        function section = loadObject(section, sectionPath)
        end
               
        function subSampleNumber = getSubSampleNumber(section)
            subSampleNumber = section.brainSectionNumber;
        end
        
        function section = wipeoutMetadataFields(section)
            section.dirName = '';
        end
        
        function metadataString = getMetadataString(section)
            
            [sampleNumberString, notesString] = section.getSampleMetadataString();
            [sourceString, timeOfRemovalString, timeOfProcessingString, dateReceivedString, storageLocationString] = section.getTissueSampleMetadataString();
            [initFixativeString, initFixPercentString, initFixTimeString, secondFixativeString, secondFixPercentString, secondFixTimeString] = section.getFixedSampleMetadataString();
            
            brainSectionNumberString = ['Brain Section Number: ', num2str(section.brainSectionNumber)];
            sectionAnatomyString = ['Section Anatomy: ', section.sectionAnatomy];
            metadataHistoryStrings = generateMetadataHistoryStrings(section.metadataHistory);
            
            
            metadataString = ...
                {'Brain Section:',...
                sampleNumberString,...
                brainSectionNumberString,...
                sectionAnatomyString,...
                sourceString,...
                timeOfRemovalString,...
                timeOfProcessingString,...
                dateReceivedString,...
                storageLocationString,...
                initFixativeString,...
                initFixPercentString,...
                initFixTimeString,...
                secondFixativeString,...
                secondFixPercentString,...
                secondFixTimeString,...
                notesString};
            metadataString = [metadataString, metadataHistoryStrings];
            
        end
               
        
        function handles = updateNavigationListboxes(section, handles)
            disableNavigationListboxes(handles, handles.quarterSampleSelect);
        end
        
        function handles = updateMetadataFields(section, handles, sectionMetadataString)
                        
            metadataString = sectionMetadataString;
            
            disableMetadataFields(handles, handles.locationMetadata);
            
            set(handles.eyeQuarterSampleMetadata, 'String', metadataString);
        end 
        
    end
    
end

