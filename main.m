close all; clear all;

s = serialport('COM7',115200);

fopen(s);
a = fscanf(s);
prevx = 0;
prevy = 0;
xinters = 0;
yinters = 0;
datax = [0, 0, 0, 0,0,0,0,0,0,0];
datay = [0, 0, 0, 0,0,0,0,0,0,0];

for i = 1:10
    a = fscanf(s);
    b = convertCharsToStrings(a);
    b = regexprep(b, '\s+', '');
    x = extractBefore(b,',');
    y = extractAfter(b,',');
    x = str2double(x);
    y = str2double(y);
    %x = x/1000;
    if x < 0
        x = x*-1;
    end
    if x > 0
        datax(i) = x;
    end
    y = y/1000;
    if y > 0
        datay(i) = y;
    end
    pause(0.01);
    disp(datax);
    disp(datay);
end

while(1)
    %hold on;
    scatter(datax,datay);
    line(datax,datay);
    yline(5,'-.r');
    if yinters > 0
        text((min(datax)-100),(max(datay)-0.5),'BAD FORM!!');
        return;
    end
    ylim([0 6]);
    yinters = 0;
    xinters = 0;
    %xlim([0 6000]);
    
    for i = 1:9
        datax(i) = datax(i+1);
        datay(i) = datay(i+1);
    end

    a = fscanf(s);
    b = convertCharsToStrings(a);
    b = regexprep(b, '\s+', '');
    x = extractBefore(b,',');
    y = extractAfter(b,',');
    x = str2double(x);
    y = str2double(y);
    
    if x > 0
        datax(10) = x;
    end
    y = y/1000;
    if y > 0
        datay(10) = y;
    end
    if y > 5
        yinters = datay(datay==y);
        xinters = datax(datay==y);
        disp(yinters);
    end
    pause(0.01);
    %disp(datax);
    %disp(datay);


end