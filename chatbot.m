% Main program file for the chatbot
% Handles I/O, everything else is handled through function calls

% Possible addition: GUI menu to set global options before the start (text speed, smooth vs random
% scrolling, personality parameters, etc.)

% Greet user, ask for name (could ask for more stuff), enter main program loop
in='';
textScroll('Welcome to the chatbot');
textScroll('Type "exit" at any time to leave.');
textScroll('');
while ~strcmp(in,'exit')
    textScroll('What mode would you like to run?');
    textScroll('(1)Chatting mode');
    textScroll('(2)Learning mode');
    textScroll('(3)Settings');
    while true 
        in = input('$ ', 's');
        if strcmp(in,'1')
            break;
        elseif strcmp(in,'2')
            break;
        elseif strcmp(in,'3')
            break;
        elseif strcmp(in,'exit')
            break;
        end
       textScroll('Invalid option'); 
    end
    textScroll('');


    %chat mode
    if strcmp(in,'1')
        textScroll('Before we begin, what is your name:');
        user = input('$ ', 's');
        if strcmp(user,'ADMIN')
            responseGen('hello world');
            responseGen('other test');
            responseGen('h');
            responseGen('i');
        end
        textScroll(strcat(user, ', is it? Nice to meet you.'));
        % textScroll('Is there anything in particular you wanted to talk about?');
        while 1
            in = input('$ ', 's');% Standard input prompt
            in=prepare(in);
            if strcmp(in, 'exit');
                break;
            end
            textScroll(responseGen(in));
        end

        textScroll('Thanks for chatting.');


     %learn mode   
    elseif strcmp(in,'2')
        textScroll('What learn mode would you like to run?');
        textScroll('(1)Basic learning mode');
        textScroll('(2)Ongoing learning mode');
        textScroll('(3)Conversational learning mode');
        while true 
            in = input('$ ', 's');
            if strcmp(in,'1')
                textScroll('');
                basicLearn()
                break;
            elseif strcmp(in,'2')
                textScroll('');
                fastLearn();
                break;
            elseif strcmp(in,'3')
                textScroll('');
                conversationLearn();
                break;
            elseif strcmp(in,'exit')
                break;
            end
           textScroll('Invalid option'); 
        end
        textScroll('');


    %Settings 
    elseif strcmp(in,'3')
        textScroll('Settings');
        textScroll('(1)Reset system');
        textScroll('(2)Back');
        while true 
            in = input('$ ', 's');
            if strcmp(in,'1')
                in={'hi';'bye'};
                out={'hello';'see ya later'};
                T=table(in,out);
                writetable(T,'record.txt');
                %Overwrites all response data
                textScroll('System reset');
                break;
            elseif strcmp(in,'2')
                break
            elseif strcmp(in,'exit')
                break;
            end
        end
        textScroll('');
    end
end
textScroll('Bye!');

    
    
