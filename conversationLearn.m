function conversationLearn()
%Conversation learn mode
%asks for user input arg and response
%then asks for a response to the response

cnt='';
T=readtable('record.txt');
in=T{:,1};
out=T{:,2};

temp='error, no response set';
while strcmp(temp,'error, no response set')
textScroll('Argument');
temp=input('$','s');
    temp=prepare(temp);
    if strcmp(temp,'exit')
        break
    end
    textScroll(responseGen(temp));
    temp=responseGen(temp);
    temp2=temp;
end
    
    
while ~strcmp(temp,'exit')
    temp=input('$','s');
    temp=prepare(temp);
    if strcmp(temp,'exit')
        break
    end
    in{end+1}=temp2;
    out{end+1}=temp;
    textScroll(responseGen(temp));
    temp2=temp;
    temp=responseGen(temp);
    if strcmp(temp,'error, no response set')
        textScroll('set response or press enter to continue:');
        temp=input('$','s');
        temp=prepare(temp);
        if ~strcmp(temp,'')
            in{end+1}=temp2;
            out{end+1}=temp;
            textScroll(temp);
        end
    end        
    temp2=temp;
end
T=table(in,out);
writetable(T,'record.txt');