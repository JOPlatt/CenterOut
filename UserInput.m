function [InputSetting, Sets, ABR, Position] = UserInput()
Position = table();
InputSetting = table();
%----------Asks user how many cycles they would like-------
InputSetting{1,1} = input(['Enter many cycles would you like:\n' ...
    'Each cycle = 8 trials\n']);
%
%----------Asks user the speed for patient movement--------
InputSetting{1,2} = input(['Please set the movemet speed:\n', ...
    '1 (slow) 2 (Normal) 3 (Fast)\n' ...
    'Enter 1-3 Below\n']);
if InputSetting{1,2} >= 4
    while InputSetting{1,2} >= 4
        InputSetting{1,2} = input(['You entered a value outside of 1-3\n' ...
            'Please reenter the movemet speed:\n', ...
            '1 (slow) 2 (Normal) 3 (Fast)\n' ...
            'Enter 1-3 Below\n']);
    end
end
%
%----------Asks user how long of a rest between each--------
InputSetting{1,3} = input(['Choose rest period between trials:\n' ...
    'Enter time below in seconds\n']);
%
%---------Asks user level of endurance of the patient-------
InputSetting{1,4} = input(['Choose endurance level of patient:\n' ...
    '1(Low) 2(Normal) 3(High)\n' ...
    'Enter 1-3 Below\n']);
if InputSetting{1,4} >= 4
    while InputSetting{1,4} >= 4
        InputSetting{1,4} = input(['You entered a value outside of 1-3\n' ...
            'Choose endurance level of patient:\n', ...
            '1(Low) 2(Normal) 3(High)\n' ...
            'Enter 1-3 Below\n']);
    end
end
% Converting the rest time to seconds
if InputSetting{1,4} == 1
    InputSetting{1,5} = 2*60;
elseif InputSetting{1,4} == 2
    InputSetting{1,5} = 3.5*60;
elseif InputSetting{1,4} == 3
    InputSetting{1,5} = 5*60;
else
    fprintf('How did you get past securety\n Please rest now\n')
end

%------------Assigns the headers for the inputs-------------
InputSetting.Properties.VariableNames = ({'Trial' 'Speed' 'Rest(s)' ...
    'Endurance level' 'Task Time (s)'});



end

