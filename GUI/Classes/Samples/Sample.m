classdef Sample
    %Sample
    
    properties
        % set at initialization
        uuid
        dirName
        naviListboxLabel
        metadataHistory
        
        
        sampleNumber
        notes = '';
        
    end
    
    methods(Static)
        
        function sample = createSample(sampleType, sampleNumber, existingSampleNumbers, subSampleNumber, existingSubSampleNumbers, toSubjectPath, projectPath, importPath, userName)
            
            if sampleType == SampleTypes.Eye
                sample = Eye(...
                    sampleNumber,...
                    existingSampleNumbers,...
                    subSampleNumber,...
                    existingSubSampleNumbers,...
                    toSubjectPath,...
                    projectPath,...
                    importPath,...
                    userName);
                
            elseif sampleType == SampleTypes.CsfSample
                sample = CsfSample(...
                    sampleNumber,...
                    existingSampleNumbers,...
                    subSampleNumber,...
                    existingSubSampleNumbers,...
                    toSubjectPath,...
                    projectPath,...
                    importPath,...
                    userName);
                
            elseif sampleType == SampleTypes.BrainSection
                sample = BrainSection(...
                    sampleNumber,...
                    existingSampleNumbers,...
                    subSampleNumber,...
                    existingSubSampleNumbers,...
                    toSubjectPath,...
                    projectPath,...
                    importPath,...
                    userName);
                
            else
                error('Invalid Sample type!');
            end                
        end
        
    end
    
    methods
        
        function sample = loadGenericSample(sample, toSamplePath, sampleDir)
            samplePath = makePath(toSamplePath, sampleDir);

            % load metadata
            vars = load(makePath(samplePath, SampleNamingConventions.METADATA_FILENAME), Constants.METADATA_VAR);
            sample = vars.metadata;

            % load dir name
            sample.dirName = sampleDir;
            
            sample = sample.loadObject(samplePath);
        end
        
        function sample = createDirectories(sample, toSubjectPath, projectPath)
            sampleDirectory = sample.generateDirName();
            
            createObjectDirectories(projectPath, toSubjectPath, sampleDirectory);
                        
            sample.dirName = sampleDirectory;
        end
        
        function [] = saveMetadata(sample, toSamplePath, projectPath, saveToBackup)
            saveObjectMetadata(sample, projectPath, toSamplePath, SampleNamingConventions.METADATA_FILENAME, saveToBackup);            
        end
        
        function [sampleNumberString, notesString] = getSampleMetadataString(sample)
            sampleNumberString = ['Sample Number: ', num2str(sample.sampleNumber)];
            notesString = ['Notes: ', sample.notes];
        end
        
    end
    
end

