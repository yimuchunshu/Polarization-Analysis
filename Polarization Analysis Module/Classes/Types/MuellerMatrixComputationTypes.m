classdef MuellerMatrixComputationTypes
    % MuellerMatrixComputationTypes
    
    properties
        displayString
        explanationString
        startDateString
        endDateString
    end
    
    enumeration
        chrisFranProgram (...
            'Chris Cookson''s/Fran Avila''s Program',...
            'The legacy version of the MM Computation. This version was incorrect because the slow axis and fast axis were mixed up and because the angle naming convention was incorrect',...
            'Project Start',...
            'Summer 2014')
        
        davidProgram (...
            'David DeVries''s Program',...
            'A version of the MM Computation program that was used for the first round of full polarization analysis. The errors due to the angle naming conventions were fixed, but the slow axis and fast axis mix was still undiscovered.',...
            'Summer 2014',...
            'May 2016')
        
        frankProgram (...
            'Frank''s Program',...
            'The current version of the MM Computation program that is what we believe to be the correct way to compute the Mueller Matrix. The fast and slow axis mix-up was corrected in this version',...
            'May 2016',...
            'Current')
    end
    
    methods
        function enum = MuellerMatrixComputationTypes(displayString, explanationString, startDateString, endDateString)
            enum.displayString = displayString;
            enum.explanationString = explanationString;
            enum.startDateString = startDateString;
            enum.endDateString = endDateString;
        end
    end
    
end

