function [] = EquationSolver()
    close all;
    global solver;
    
    %Naming the figure
    solver.fig = figure('numbertitle','off','name','Equation Solver');
    
    %Making the input box
    solver.inputBox = uicontrol('style','edit','units','normalized','position',...
    [.05 .85 .25 .05],'string','Insert Function Here','horizontalalignment','center');
    solver.inputInstructions = uicontrol('style','text','units','normalized','position',...
    [.05 .9 .25 .05],'string','Type a function in terms of x','horizontalalignment','center');
    
    %Making the plot button and zeros button
    solver.plotButton = uicontrol('style','push','units','normalized','position',...
    [.30 .85 .07 .05],'string','Plot','horizontalalignment','center','callback', {@plotExpression});
    solver.zerosButton = uicontrol('style','push','units','normalized','position',...
    [.37 .85 .12 .05],'string','Find Zeros','horizontalalignment','center','callback', {@findZeros});

    %Making the zeros display
    solver.zerosDisplay = uicontrol('style','text','units','normalized','position',...
    [.05 .45 .25 .30],'string','Zeros will appear here','horizontalalignment','left');
    solver.zerosPreface = uicontrol('style','text','units','normalized','position',...
    [.05 .75 .25 .05],'string','Zeros will appear below','horizontalalignment','left');

    %Making the area where the plot will be
    solver.axes = axes('Position',[0.35 0.07 .60 .60],'Box','on');
end

function [] = findZeros(~, ~)
    %Screening user input
    if inputScreener == false
        return
    end
    
    %Making sure all the variables will work in this function
    global solver;
    x = sym('x');
    y = sym('y');
    %Including e for people who don't want to deal with the exp thing
    e = 2.7182818284590452353602874713526624977572470937;
    
    %Making the user input readable by Matlab's solve function
    input = get(solver.inputBox, 'string');
    y = input;
    eval(['y = ',input,';']);
    
    %Making an array to hold the zeros of the function
    zerosArray = double(solve(y == 0, x));
    zerosString = string(zerosArray);
    
    %Displaying the zeros
    solver.zerosDisplay.String = zerosString;
end

function [] = plotExpression(~, ~)
    %Screening user input
    if inputScreener == false
        return
    end

    %Making sure all the variables will work in this function
    global solver;
    x = sym('x');
    y = sym('y');
    %Including e for people who don't want to deal with the exp thing
    e = 2.7182818284590452353602874713526624977572470937;
    
    %Making the user input readable by Matlab's fplot function
    input = get(solver.inputBox, 'string');
    y = input;
    eval(['y = ',input,';']);
    
    %Plotting the graph in the same figure
    axes(solver.axes);
    fplot(x,y);
     
end

function [output] = inputScreener()
    output = true;
    global solver;
    input = get(solver.inputBox, 'string');
    
    %Making sure the user includes x
    isThereX = regexp(input, 'x');
    if numel(isThereX) == 0
        msgbox('Please input a function of x (lowercase)!','Error','error','modal')
        output = false;
    end
    
    %Making sure the user only uses proper characters
    isExpressionValid = regexp(input, '[^\s \( \) 0-9 *./ex+\-\^(exp)(log)]');
    if numel(isExpressionValid) > 0
        msgbox('Please input a function of x (lowercase)!','Error','error','modal')
        output = false;
    end
    
end