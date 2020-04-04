function fastLearn()
%onging learn mode
%asks for user input arg and response
%then asks for a response to the response

cnt='';
T=readtable('record.txt');
in=T{:,1};
out=T{:,2};

temp=input('Argument\n$','s');
    temp=prepare(temp);
    in{end+1}=temp;
    temp=input('Response\n$','s');
    temp=prepare(temp);
    out{end+1}=temp;
    
while strcmp(cnt,'')
    in{end+1}=temp;
    temp=input('Response\n$','s');
    temp=prepare(temp);
    out{end+1}=temp;
    cnt=input('Press enter to repeat\n$','s');
end
T=table(in,out);
writetable(T,'record.txt');