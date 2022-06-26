close all; clear all;

%open reader for serial data
s = serialport('COM7',115200); 
fopen(s);
a = fscanf(s);

%initialize data
prevx = 0;
prevy = 0;
xinters = 0;
yinters = 0;
datax = [0, 0, 0, 0,0,0,0,0,0,0];
datay = [0, 0, 0, 0,0,0,0,0,0,0];

%We must fill the arrays with data before we can plot
for i = 1:10
    a = fscanf(s);
    b = convertCharsToStrings(a);
    b = regexprep(b, '\s+', ''); %remove spaces
    x = extractBefore(b,','); %create string of x data before the comma, since raw data is in format (x,y)
    y = extractAfter(b,','); %create string of y data after the comma, since raw data is in format (x,y)
    x = str2double(x); 
    y = str2double(y);
    
    %sometimes the data is wonky and gives a negative value. We can't plot
    %these, so we must make them positive
    if x < 0
        x = x*-1;
    end

    %no point in plotting 0's, so we only fill array with nonzeroes
    if x > 0
        datax(i) = x;
    end

    y = y/1000; %to make y data more clean

    if y > 0
        datay(i) = y;
    end
    pause(0.01);
    disp(datax);
    disp(datay);
end

while(1)
    %plot (x,y) as scatter
    scatter(datax,datay);
    line(datax,datay); 
    yline(5,'-.r'); %constant horizontal line to show threshold

    %Stop and show bad form text when the y passes 5 (below)
    if yinters > 0
        text((max(datax)-100),(max(datay)-0.5),'BAD FORM!!');
        return;
    end

    ylim([0 6]);
    yinters = 0;
    xinters = 0;
    %xlim([0 6000]);
    
    %move all data to the left, to create space for the new data at the end
    %of the array
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
    
    %threshold detected
    if y > 5
        yinters = datay(datay==y);
        xinters = datax(datay==y);
        disp(yinters);
    end
    pause(0.01);


end
