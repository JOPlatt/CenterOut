% Clear the workspace and the screen
try
    sca;
    close all;
    clearvars;
    %---------------Setting initial values-------------------
    TimeTable = table();
    [~, Directions] = xlsread('TextList.xlsx');
    [TimeTable{1,:}, ~, syncErrorSecs] = GetSecs('AllClocks');
    Position = table();
    InputSetting = table();
    Colors = table();
    Stimuli = table();
     
    % [InputSetting] = UserInput();
    % %
    % % 
    %testing valses
    InputSetting{1,1} = 1;
    InputSetting{1,2} = 3;
    InputSetting{1,3} = 1;  
    InputSetting{1,4} = .5;
    InputSetting{1,5} = 30;
    %------------Assigns the headers for the inputs-------------
    InputSetting.Properties.VariableNames = ({'Trial' 'Speed' 'Rest(s)' ...
        'Endurance level' 'Task Time (s)'});
    
    % %--------Makes sure the user accepts the conditions-------
    % fprintf('Based on the setting entered\nTesting will take %2.2f minutes\n' ...
    %     , ((Sets)*InputSetting{1,5})/60);
    % Ready = input(['Whould you like to proceed with this test?\n' ...
    %     'Enter 1(Yes) 2(No)\n']);
    % if Ready >=2
    %     return;
    % end
    
    %------------number of objects before a rest--------------
    ABR = round((InputSetting{1,5})/(2*InputSetting{1,2}+ ...
        InputSetting{1,3}));
    %
    %
    
    for i = 1:InputSetting{1,1}
        Position{i,:} = randperm(8);
    end
    Position.Properties.VariableNames = {'TrialOne' 'TrialTwo' ...
        'TrialThree' 'TrialFour' 'TrialFive' 'TrialSix' ...
        'TrialSeven' 'TrialEight'};
    
    
    % Determining the size of the matrix
    [mp, np] = size(Position);
    
    % Finds the number of sets
    Sets = (mp*np)/ABR;
    
    % setting the dots in a single column
    for i = 1:mp
        Stimuli = table([Stimuli{:,:}; Position{i,:}']);
    end
    
    [ms,~] = size(Stimuli);
    
    %Setting up a char array for the directions
    %     Directions = char(["  East" "NorthEast" "  North" "NorthWest" ...
    %         "  West" "SouthWest" "  South" "SouthEast" "Return to\nCenter" ...
    %         "GO!!!"]);
    
    % setting a table for all the colors
    Colors = table(...
        [250;255;  0;128;105; 46;255;255;  0], ...
        [250;  0;128;128;105;139;255;  0;  0], ...
        [250;  0;  0;128;105; 87;  0;  0;205]);
    Colors.Properties.RowNames = {'White' 'Red' 'DkGreen' 'Gray' ...
        'DemGray' 'SeaGreen' 'Yellow' 'red' 'Blue'};
    Colors.Properties.VariableNames = {'R' 'G' 'B'};
    Colors{:,:} = Colors{:,:}/255;
    SColor = Colors{6+InputSetting{1,2},:};
    TimeTable{2,:} = GetSecs;  
    
    % Here we call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer. For help see: Screen Screens?
    screens = Screen('Screens');
    
    % Draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen. When only one screen is attached to the monitor we will draw to
    % this. For help see: help max
    screenNumber = max(screens);
    
    % Open an on screen window and color it black.
    % For help see: Screen OpenWindow?
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, [0 0 0]);
    
    % Get the size of the on screen window in pixels.
    % For help see: Screen WindowSize?
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    % Enable alpha blending for anti-aliasing
    % For help see: Screen BlendFunction?
    % Also see: Chapter 6 of the OpenGL programming guide
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Determine the X and Y center position
    xCenter = windowRect(3)/2;
    yCenter = windowRect(4)/2;
    % Making table of Dot Sizes
    dotSize = table([60;55]);
    dotSize.Properties.RowNames = {'full' 'smaller'};
    dotSize.Properties.VariableNames = {'DotSize'};
    
    
    Radius = table();
    % Making a table of radii
    Radius = table([xCenter/2;.66*xCenter/2;.33*xCenter/2]);
    Radius.Properties.RowNames = {'full' '66%' '33%'};
    Radius.Properties.VariableNames = {'Radius'};
    
    %8 different locations for the circles
    xPoint(1) = Radius{1,1} * cos(0) + xCenter;
    yPoint(1) = -Radius{1,1} * sin(0) + yCenter;
    xPoint(2) = Radius{1,1} * cos(pi/4) + xCenter;
    yPoint(2) = -Radius{1,1} * sin(pi/4) + yCenter;
    xPoint(3) = Radius{1,1} * cos(pi/2) + xCenter;
    yPoint(3) = -Radius{1,1} * sin(pi/2) + yCenter;
    xPoint(4) = Radius{1,1} * cos((3*pi)/4) + xCenter;
    yPoint(4) = -Radius{1,1} * sin((3*pi)/4) +  yCenter;
    xPoint(5) = Radius{1,1} * cos(pi) + xCenter;
    yPoint(5) = -Radius{1,1} * sin(pi) + yCenter;
    xPoint(6) = Radius{1,1} * cos(5*pi/4) + xCenter;
    yPoint(6) = -Radius{1,1} * sin(5*pi/4) + yCenter;
    xPoint(7) = Radius{1,1} * cos(3*pi/2) + xCenter;
    yPoint(7) = -Radius{1,1} * sin(3*pi/2) + yCenter;
    xPoint(8) = Radius{1,1} * cos(7*pi/4) + xCenter;
    yPoint(8) = -Radius{1,1} * sin(7*pi/4) + yCenter;
    xPoint(9) = xCenter;
    yPoint(9) = yCenter;
    
    %Making a table for all the perimeters
    Di = 40;        %diameter of the circles
    Perimeters = table([720; 200; 1200; 400], [1920;0;0;525], ...
        [1920;0;0;675], [1920;0;0;600]);
    for i = 1:9
       Perimeters{:,4+i} = ...
           [(xPoint(i)-Di);(yPoint(i)-Di);(xPoint(i)+Di);(yPoint(i)+Di)];
    end
    Perimeters.Properties.RowNames = {'Left' 'Top' 'Right' 'Bottom'};
    Perimeters.Properties.VariableNames = {'Textbox' 'UpperText' ...
        'LowerText' 'CenterText' '0_Degrees' '45_Degrees' '90_Degrees' ...
        '135_Degrees' '180_Degrees' '225_Degrees' '270_Degreees' ...
        '315_Degrees' 'Center'};
    
     
    % Draw the dot to the screen
    Screen('Flip', window,0,1);
    tic; 
    
    TimeTable{2,1} = GetSecs;
    TimeTable{2,2} = TimeTable{2,1}-TimeTable{1,1};
    i = 1;
    j = 1;
    
    
    %-----------Welcome Screen showing all the circles----------
    
    Screen('Flip', window,0,1);
    
    % loops though all the circles
    for i = 5:12
        Screen('FillOval', window, Colors{5,:}, ...
            Perimeters{:,i},[]);
    end
    Screen('FillOval', window, SColor, ...
        Perimeters{:,13},[]);
     
    % Makes the initial message screen with a welcome displayed
    Screen('FillRect', window, Colors{5,:},Perimeters{:,1});
    Screen('TextSize', window, 80);
    DrawFormattedText(window,Directions{12},'center', ...
        'center', Colors{2,:}, [], [], [], [], [], Perimeters{:,4}');
     
    % Puts everything on the screen
    Screen('Flip', window);
    
    % Holds till space is pressed indicating the test shold start
    KbTriggerWait(KbName('space'));
      
    %----------------Getting the patient ready---------------
    % This part shows the patient a two line message indicating
    %them to get ready and place their finger over the center
    %circle without touching.
     
    Screen('TextSize', window, 40);
    Screen('DrawText', window, ... 
        Directions{13}, ...
        650,300, Colors{2,:});
    Screen('DrawText', window, ...
        Directions{14}, ...
        550, 400, Colors{2,:});
    Screen('FillOval', window, SColor, ... 
        Perimeters{:,13},[]);
     
    % Puts everything on the screen and waits 3 seconds
    Screen('Flip', window);
    WaitSecs(3);
     
    %----------Looping through the different tasks----------
    
    % loops though all the circles
    for i = 5:12
        Screen('FillOval', window, Colors{4,:}, ...
            Perimeters{:,i},[]);
    end
    Screen('FillOval', window, SColor, ...  
        Perimeters{:,13},[]);
    % Makes the initial message screen with a welcome displayed
    Screen('FillRect', window, Colors{5,:},Perimeters{:,1});
    Screen('TextSize', window, 80);
    DrawFormattedText(window,Directions{15},'center', ...
        'center', Colors{2,:}, [], [], [], [], [], Perimeters{:,4}');
    
     
    % Puts everything on the screen
    Screen('Flip', window,0,1);
    
    % Starts the timer
    startTime = GetSecs;
    
    for i = 1:ms
        
        %-----Showing the stimuli with a test box----
        Screen('FillOval', window, Colors{3,:}, ...
            Perimeters{:,i+4},[]);
        
        %Give a visual location of the dot
        Screen('FillRect', window, Colors{5,:}, Perimeters{:,1});
        Screen('TextSize', window, 80);
        DrawFormattedText(window,Directions{i},'center', ...
            'center', Colors{2,:}, [], [], [], [], [], Perimeters{:,4}');
         
        Screen('Flip', window,0,1);
        %Shows and tells where the dot the patient needs to reach
         
        WaitSecs(1.5); 
        %The amount of time the patient see the dot before moving
         
        %-----Removes the center dot and indicates to move---
         
        %Changes the center circle color 
        Screen('FillOval', window, Colors{4,:}, ...
            Perimeters{:,13},[]);
        
        %Give a visual go by changing text box to green and use of text
        Screen('FillRect', window, Colors{6,:},Perimeters{:,1});
        Screen('TextSize', window, 80);
        DrawFormattedText(window,Directions{9},'center', ...
            'center', Colors{1,:}, [], [], [], [], [], Perimeters{:,2}');
        DrawFormattedText(window,Directions{i},'center', ...
            'center', Colors{1,:}, [], [], [], [], [], Perimeters{:,3}');
        
        Screen('Flip', window,0,1);
        
        %Gives the patient the time set by speed to reach the dot
        WaitSecs(InputSetting{1,2});
        
        %---------Return to the center-----------------
        %Changes the task dot and fills in the center dot to
        %indicate the patient to move back to the center.
        
        Screen('FillOval', window, Colors{4,:}, ...
            Perimeters{:,i+4},[]);
        Screen('FillOval', window, SColor, ...
            Perimeters{:,13},[]);
        
        %Give a visual go by changing text box to green and use of text
        Screen('FillRect', window, Colors{5,:},Perimeters{:,1});
        Screen('TextSize', window, 80);
        DrawFormattedText(window,Directions{10},'center', ...
            'center', Colors{2,:}, [], [], [], [], [], Perimeters{:,2}');
        DrawFormattedText(window,Directions{11},'center', ...
            'center', Colors{2,:}, [], [], [], [], [], Perimeters{:,3}');
        Screen('Flip', window,0,1);
        
        %-----------Gives the patient a rest------------
        %During each task the patient is given a user given
        %rest and after an endurance level is reached a
        %longer rest is given before the next trial.
        
        eplapsed = GetSecs-startTime;
         
        if eplapsed >= InputSetting{1,5}
            WaitSecs(2);
            Screen('Flip', window);
            Screen('TextFont',window, 'Times');
            Screen('TextSize',window, 30);
            Screen('DrawText', window, ...
                Directions{16}, ...
                550, 400, Colors{2,:});
            
            Screen('Flip', window,0,1);
            WaitSecs(4);
            Screen('Flip', window);
            Screen('DrawText', window, ...
                Directions{17}, ...
                600, 400, Colors{3,:});
            
            Screen('FillOval', window, SColor, ...
                Perimeters{:,13},[]);
            Screen('Flip', window);
            WaitSecs(4);
             
            % loops though all the circles
            for j = 5:12
                Screen('FillOval', window, Colors{4,:}, ...
                    Perimeters{:,j},[]);
            end
            Screen('FillOval', window, SColor, ...
                Perimeters{:,13},[]);
            Screen('Flip', window,0,1); 
            WaitSecs(2);
            startTime = GetSecs;
        else
            % Give the patient a small rest between each trial 
            WaitSecs(InputSetting{1,3});
        end
%        [~,~,~,LostIt] = KbQueueCheck(); 
%         if LostIt == 1
%             return; 
%         end
        
    end
     
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    capture = toc;
    
    % Flip to the screen. This command basically draws all of our previous
    % commands onto the screen. See later demos in the animation section on more
    % timing details. And how to demos in this section on how to draw multiple
    % rects at once.
    % For help see: Screen Flip?
    %     Screen('Flip', window);
    capture = toc;
    % Now we have drawn to the screen we wait for a keyboard button press (any
    % key) to terminate the demo. For help see: help KbStrokeWait
    KbStrokeWait;
    
    
    capture = [capture toc];
    % Clear the screen. "sca" is short hand for "Screen CloseAll". This clears
    % all features related to PTB. Note: we leave the variables in the
    % workspace so you can have a look at them if you want.
    % For help see: help sca
    sca;
    
    
catch X
end
