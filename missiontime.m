% mission time function
function [upd_t_mission] = missiontime(t_mission, dt, ~)
% shows total mission time in {D,hrs,m,s} format and current datetime 
% based on maneuver starting time and maneuver duration

% INPUT:
% t_mission = mission time before maneuever [s]
% dt = maneuver duration [s]

% OUTPUT:
% upd_t_mission = mission time after maneuver [s]

upd_t_mission = t_mission + dt; % updated mission time [s]
sec = upd_t_mission; % feed mission time to time converter [s]


% define ratio of seconds
sec_in_min = 60;
min_in_hr = 60;
hr_in_day = 24;


minute = sec_in_min;      % seconds in a minute
hour = minute * min_in_hr;% seconds in an hr
day = hour * hr_in_day;   % seconds in a day

% total mission time calc
days_mission = floor(sec/day);                        % calc num days
hours_mission = floor(rem(sec/hour, hr_in_day));      % calc num hours
minutes_mission = floor(rem(sec/minute, min_in_hr));  % calc num minutes
seconds_mission = rem(sec, minute);                   % calc num seconds

% maneuver converter
days_man = floor(dt/day);                        % calc num days
hours_man = floor(rem(dt/hour, hr_in_day));      % calc num hours
minutes_man = floor(rem(dt/minute, min_in_hr));  % calc num minutes
seconds_man = rem(dt, minute);                   % calc num seconds

disp(" ")
disp("     ---    MISSION TIME    ---     ")
disp(" ")
disp("Total Maneuver Duration:")
if days_man >= 1
    disp(days_man + " d, " + hours_man + " hrs, " + minutes_man + " m, " +  round(seconds_man) + " s")
elseif hours_man >= 1
    disp(hours_man + " hrs, " + minutes_man + " m, " + round(seconds_man) + " s")
elseif minutes_man >= 1
    disp(minutes_man + " m, " + round(seconds_man) + " s")
else
    disp(round(seconds_mission) + " s")
end
disp(" ")
disp("Total Time Elapsed from Mission Start:")
if days_mission >= 1
    disp(days_mission + " d, " + hours_mission + " hrs, " + minutes_mission + " m, " +  round(seconds_mission) + " s")
elseif hours_mission >= 1
    disp(hours_mission + " hrs, " + minutes_mission + " m, " + round(seconds_mission) + " s")
elseif minutes_mission >= 1
    disp(minutes_mission + " m, " + round(seconds_mission) + " s")
else
    disp(round(seconds_mission) + " s")
end
disp(" ")