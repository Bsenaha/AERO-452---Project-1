% LVLH Plot Function
function plotLVLH(man1_R, man2_R, man3_R, man4_R, man5_R, hold1_R)
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
m(4) = plot(hold1_R(:,2), hold1_R(:,1), 'k');
m(5) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(9) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Maneuver 1: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(9)], 'Maneuver 1 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 2 spotlight ==

figure()
m(1) = plot(man2_R(:,2), man2_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man2_R(1,2), man2_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man2_R(end,2), man2_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(hold1_R(:,2), hold1_R(:,1), 'k');
m(5) = plot(man1_R(:,2), man1_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(9) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Maneuver 2: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(9)], 'Maneuver 2 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 3 spotlight ==

figure()
m(1) = plot(man3_R(:,2), man3_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man3_R(1,2), man3_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man3_R(end,2), man3_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(5) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(6) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(7) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-.2 1.1])
ylim([-.2 .2])
grid minor
title('Maneuver 3: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(7)], 'Maneuver 3 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 4 spotlight ==

figure()
m(1) = plot(man4_R(:,2), man4_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man4_R(1,2), man4_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man4_R(end,2), man4_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(5) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(6) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(7) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-.2 1.1])
ylim([-.2 .2])
grid minor
title('Maneuver 4: Hop Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(7)], 'Maneuver 4 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% == maneuver 5 spotlight ==

figure()
% convert km to m
man5_R = man5_R.*1000;
man4_R = man4_R.*1000;
m(1) = plot(man5_R(:,2), man5_R(:,1), 'r'); % spotlight maneuver plot
hold on
m(2) = plot(man5_R(1,2), man5_R(1,1), '*', 'Color', 'm'); % maneuver start
m(3) = plot(man5_R(end,2), man5_R(end,1), '*', 'Color', 'b'); % maneuver end
m(4) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(5) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-10 30])
ylim([-10 10])
grid minor
title('Maneuver 5: Vbar Approach -- LVLH')
xlabel('Downrange -- Vbar [m]')
ylabel('Altitude -- Rbar [m]')
legend([m(1) m(2) m(3) m(5)], 'Maneuver 5 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southwest')
% convert back
man5_R = man5_R./1000;
man4_R = man4_R./1000;


% == Entire Approach Profile ==
%{
figure()
m(1) = plot(man1_R(:,2), man1_R(:,1), 'k'); % maneuver 1
hold on
m(2) = plot(man1_R(1,2), man1_R(1,1), '*', 'Color', 'm'); % mission start
m(3) = plot(hold1_R(:,2), hold1_R(:,1), 'k'); % hold 1
m(4) = plot(man2_R(:,2), man2_R(:,1), 'k'); % maneuver 2
m(5) = plot(man3_R(:,2), man3_R(:,1), 'k'); % maneuver 3
m(6) = plot(man4_R(:,2), man4_R(:,1), 'k'); % maneuver 4
m(7) = plot(man5_R(:,2), man5_R(:,1), 'k'); % maneuver 5
m(8) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Approach Profile -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(2) m(8)], 'Mission Start', 'Target', 'Location', 'Southeast')
%}


% ====== HOLDS ======
% == hold 1 spotlight ==

figure()
m(1) = plot(hold1_R(:,2), hold1_R(:,1), 'r'); % spotlight hold plot
hold on
m(2) = plot(hold1_R(1,2), hold1_R(1,1), '*', 'Color', 'm'); % hold start
m(3) = plot(hold1_R(end,2), hold1_R(end,1), '*', 'Color', 'b'); % hold end
m(4) = plot(man1_R(:,2), man1_R(:,1), 'k');
m(5) = plot(man2_R(:,2), man2_R(:,1), 'k');
m(6) = plot(man3_R(:,2), man3_R(:,1), 'k');
m(7) = plot(man4_R(:,2), man4_R(:,1), 'k');
m(8) = plot(man5_R(:,2), man5_R(:,1), 'k');
m(9) = scatter(0, 0, 'k', 'filled'); % Target
xlim([-45 105])
ylim([-22 22])
grid minor
title('Hold 1: Football Trajectory -- LVLH')
xlabel('Downrange -- Vbar [km]')
ylabel('Altitude -- Rbar [km]')
legend([m(1) m(2) m(3) m(9)], 'Hold 1 Trajectory', 'Start', ...+
    'End', 'Target Position', 'Location', 'Southeast')


% holds 2, 3, do not require plots
