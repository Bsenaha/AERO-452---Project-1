% LVLH Plot Function
function plotLVLH(man1_R, man2_R, man3_R, man4_R, man5_R, hold2_R, hold5_R)
% plots Project 1 maneuvers 1-5 and hold 1 in LVLH
% INPUT:
% man*_R = position states of maneuver *
% hold1_R = position states of hold 1

% ====== MANEUVERS ======
% == maneuver 1 spotlight ==

figure()
m(1) = plot(man1_R(:,2), man1_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man1_R(1,2), man1_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man1_R(end,2), man1_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(hold2_R(:,2), hold2_R(:,1), 'k');
m(5) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = plot(hold5_R(:,2), hold5_R(:,1), 'k');
m(9) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(10) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Maneuver 1: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(10)], 'Maneuver 1 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 2 spotlight ==

figure()
m(1) = plot(man2_R(:,2), man2_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man2_R(1,2), man2_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man2_R(end,2), man2_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(hold2_R(:,2), hold2_R(:,1), 'k');
m(5) = plot(man1_R(:,2), man1_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = plot(hold5_R(:,2), hold5_R(:,1), 'k');
m(9) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(10) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Maneuver 2: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(10)], 'Maneuver 2 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 3 spotlight ==

figure()
m(1) = plot(man3_R(:,2), man3_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man3_R(1,2), man3_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man3_R(end,2), man3_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(5) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(6) = plot(hold5_R(:,2), hold5_R(:,1), 'k');
m(7) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(8) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-.2 1.1])
ylim([-.2 .2])
grid minor
title('Maneuver 3: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(8)], 'Maneuver 3 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 4 spotlight ==

figure()
m(1) = plot(man4_R(:,2), man4_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man4_R(1,2), man4_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man4_R(end,2), man4_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(5) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(6) = plot(hold5_R(:,2), hold5_R(:,1), 'k');
m(7) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(8) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-.2 1.1])
ylim([-.2 .2])
grid minor
title('Maneuver 4: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(8)], 'Maneuver 4 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 5 spotlight ==

figure()
% convert km to m
man5_R = man5_R.*1000;
man4_R = man4_R.*1000;
hold5_R = hold5_R.*1000; 
m(1) = plot(man5_R(:,2), man5_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man5_R(1,2), man5_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man5_R(end,2), man5_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(hold5_R(:,2), hold5_R(:,1), 'k');
m(5) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(6) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-25 30])
ylim([-18 18])
grid minor
title('Maneuver 5: Vbar Approach -- LVLH')
xlabel('Downrange -- Vbar [m]')
ylabel('Altitude -- Rbar [m]')
legend([m(1) m(2) m(3) m(6)], 'Maneuver 5 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')
% convert back
man5_R = man5_R./1000;
man4_R = man4_R./1000;
hold5_R = hold5_R./1000; 


% == Entire Approach Profile ==

figure()
m(1) = plot(man1_R(:,2), man1_R(:,1), 'k'); % maneuver 1
hold on
m(2) = plot(man1_R(1,2), man1_R(1,1), '*', 'Color', 'm'); % mission start
m(3) = plot(hold2_R(:,2), hold2_R(:,1), 'k'); % hold 1
m(4) = plot(man2_R(:,2), man2_R(:,1), 'k'); % maneuver 2
m(5) = plot(man3_R(:,2), man3_R(:,1), 'k'); % maneuver 3
m(6) = plot(man4_R(:,2), man4_R(:,1), 'k'); % maneuver 4
m(7) = plot(hold5_R(:,2), hold5_R(:,1), 'k'); % hold 5
m(8) = plot(man5_R(:,2), man5_R(:,1), 'k'); % maneuver 5
m(9) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Approach Profile -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(2) m(9)], 'Mission Start', 'Target', 'Location', 'Southeast')



% ====== HOLDS ======
% == hold 2 spotlight ==

figure()
m(1) = plot(hold2_R(:,2), hold2_R(:,1), 'r'); % spotlight hold plot
hold on
m(2) = plot(hold2_R(1,2), hold2_R(1,1), '*', 'Color', 'm'); % hold start/end
m(3) = plot(man1_R(:,2), man1_R(:,1), 'k');
m(4) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(5) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(6) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(7) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(8) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Hold 2: Football Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(8)], 'Hold 2 Trajectory', 'Start/End', ...+
    'Target Position', 'Location', 'Southeast')

% holds 2, 3, do not require plots

% == hold 5 spotlight ==

figure()
% convert km to m
man5_R = man5_R.*1000;
man4_R = man4_R.*1000;
hold5_R = hold5_R.*1000; 
m(1) = plot(hold5_R(:,2), hold5_R(:,1), 'r'); % spotlight hold plot
hold on
m(2) = plot(hold5_R(1,2), hold5_R(1,1), '*', 'Color', 'm'); % hold start/end
m(3) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(4) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(5) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-25 30])
ylim([-18 18])
grid minor
title('Hold 5: Football Trajectory -- LVLH')
xlabel('Downrange -- Vbar [m]')
ylabel('Altitude -- Rbar [m]')
legend([m(1) m(2) m(5)], 'Hold 5 Trajectory', 'Start/End', ...+
    'Target Position', 'Location', 'Southeast')
