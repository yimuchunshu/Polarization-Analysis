classdef Session
    %Session
    % holds metadata describing data collection or analysis for a given
    % location
    
    % a lot of classes inherit from this bad boy
    
    properties
        dirName
        
        sessionDate
        sessionDoneBy
           
        sessionNumber
        
        isDataCollectionSession
        
        subfolderIndex = 0
        imageIndex = 0
        
        fileSelectionEntries
        
        notes
    end
    
    methods
        function session = wipeoutMetadataFields(session)
            session.dirName = '';
            session.fileSelectionEntries = [];
        end
        
        function handles = updateNavigationListboxes(session, handles)
            subfolderSelections = session.getSubfolderSelections();
            imageSelections = session.getImageSelections();
            
            if isempty(subfolderSelections)
                disableNavigationListboxes(handles, handles.subfolderSelect);
            else
                set(handles.subfolderSelect, 'String', subfolderSelections, 'Value', session.subfolderIndex, 'Enable', 'on');
                
                if isempty(imageSelections)
                    set(handles.imageSelect, 'String', imageSelections, 'Value', session.imageIndex, 'Enable', 'on');
                else
                    disableNavigationListboxes(handles, handles.imageSelect);
                end
            end
        end
        
        function session = createFileSelectionEntries(session, toSessionPath)
            path = makePath(toSessionPath, session.dirName);
            
            session.fileSelectionEntries = generateFileSelectionEntries({}, path, session.dirName, 0);
        end
        
        function subfolderSelections = getSubfolderSelections(session)
            numEntries = length(session.fileSelectionEntries);
            
            subfolderSelections = cell(numEntries, 1);
            
            for i=1:numEntries
                subfolderSelections{i} = session.fileSelectionEntries{i}.selectionLabel;
            end
        end
        
        function imageSelections = getImageSelections(session)
            images = session.getSubfolderSelection();
            
            numImages = lenth(images);
            
            imageSelections = cell(numImages, 1);
            
            for i=1:numImages
                imageSelections{i} = images{i}.selectionLabel;
            end
        end
        
        function subfolderSelection = getSubfolderSelection(session)
            
            if session.subfolderIndex ~= 0
                subfolderSelection = session.fileSelectionEntries{session.subfolderIndex};
            else
                subfolderSelection = [];
            end
        end
    end
    
end
