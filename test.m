arg=input('in','s');
in={'hi';'bye'};
out={'hello';'see ya'};
T=table(in,out);
writetable(T,'record.txt');
a=readtable('record.txt');

%basic learn mode
%asks for user input arg and response
cnt='';

while strcmp(cnt,'')
    temp=input('argument','s');
    temp=lower(temp);
    in{end+1}=temp;
    temp=input('response','s');
    temp=lower(temp);
    out{end+1}=temp;
    cnt=input('','s');
end
T=table(in,out);
writetable(T,'record.txt');

%onging learn mode
%asks for user input arg and response
%then asks for a response to the response
cnt='';

temp=input('argument','s');
temp=lower(temp);
in{end+1}=temp;
temp=input('response','s');
temp=lower(temp);
out{end+1}=temp;
while strcmp(cnt,'')
    in{end+1}=temp;
    temp=input('response','s');
    temp=lower(temp);
    out{end+1}=temp;
    cnt=input('','s');
end
T=table(in,out);
writetable(T,'record.txt');

%Conversation learn mode
%asks for user input arg and response
%then asks for a response to the response
cnt='';

temp=input('argument','s');
temp=lower(temp);
in{end+1}=temp;
temp=input('response','s');
temp=lower(temp);
out{end+1}=temp;
while strcmp(cnt,'')
    in{end+1}=temp;
    temp=input('response','s');
    temp=lower(temp);
    out{end+1}=temp;
    cnt=input('','s');
end
T=table(in,out);
writetable(T,'record.txt');

%responseGen
%takes a table, identifies all matching ins, collects responses, and randomizes response
x=a{1,:};
response={}
for c = 1:length(x)
    temp=x{c};
    if strcmp(temp,arg)
        temp2=a{c,2};
        response{end+1}=temp2;
    end
end
if length(response)==0
    response{end+1}='error';
end
ran=randi(length(response));
re=response{ran};
disp(re);