function data = readDataString(string)

    
    % Check if laser or odom
    if string(1) == 'O'
        d = textscan(string, '%s %f %f %f %f');
        cField = 'c'; cValue = d{1}; % data classification
        xField = 'x'; xValue = d{2}; % x position
        yField = 'y'; yValue = d{3}; % y position
        thField = 'th'; thValue = d{4}; % theta
        tsField = 'ts'; tsValue = d{5}; % timestamp
        data = struct(cField, cValue, xField, xValue, yField, yValue, thField, thValue, tsField, tsValue);
    elseif string(1) == 'L'
        
        C = strsplit(string);
        
        cField = 'c'; cValue = C(1); % data classification
        xField = 'x'; xValue = str2double(C(2)); % x position
        yField = 'y'; yValue = str2double(C(3)); % y position
        thField = 'th'; thValue = str2double(C(4)); % theta
        xlField = 'x_l'; xlValue = str2double(C(5)); % laser x position
        ylField = 'y_l'; ylValue = str2double(C(6)); % laser y position
        thlField = 'th_l'; thlValue = str2double(C(7)); % laser theta
        rField = 'r'; rValue =  str2double(C(8:end - 1));
        tsField = 'ts'; tsValue = str2double(C(end)); % timestamp
        data = struct(cField, cValue, xField, xValue, yField, yValue, thField, thValue, xlField, xlValue, ylField, ylValue, thlField, thlValue, rField, rValue, tsField, tsValue);

    end
    
    
    
end