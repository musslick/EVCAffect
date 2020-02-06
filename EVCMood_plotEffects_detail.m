function EVCMood_plotEffects_debug(filePath, plotRT)

% plotRT = 0;
% filePath = 'EVCMood logfiles/EVCMood_sampleSubjects_Reward_20'
% filePath = 'EVCMood logfiles/EVCMood_sampleSubjects_Utility Discounting_20'
% filePath = 'EVCMood logfiles/EVCMood_sampleSubjects_Low Expected Task Difficulty_20'
% filePath = 'EVCMood logfiles/EVCMood_sampleSubjects_Expected Task Difficulty_20'
% filePath = 'EVCMood logfiles/EVCMood_sampleSubjects_Default_20'
% filePath = 'EVCMood logfiles/EVCMood_sampleSubjects_ControlCost_20.mat'
% filePath = 'EVCMood logfiles/EVCMood_sampleSubjects_ControlCost_s20_2.mat'
% EVCMood_plotEffects( 'EVCMood logfiles/EVCMood_sampleSubjects_ControlCost_10.mat',1)

close all;
clc;

load(filePath);

disp(parameterValues);

% PLOT SETTINGS

plotSEM = 0;

% plot settings

export = 0;
fontSize.title = 13;
fontSize.xlabel = fontSize.title;
fontSize.ylabel = fontSize.title;
fontSize.TickLabel = fontSize.title;
fontWeight.title = 'normal';
fontWeight.ylabel = 'normal';
fontWeight.xlabel = 'normal';
fontWeight.TickLabel = 'normal';
color.default = [0 0 0];
color.line1 = [31 119 180]/255;
color.line2 = [31 119 180]/255;
color.line3 = [253 127 35]/255;
color.line4 = [253 127 35]/255;
color.bar0 = [1 1 1];
color.bar1 = [0.7 0.7 0.7];
color.bar2 = [0.5 0.5 0.5];
color.bar3 = [0.3 0.3 0.3];
color.bar4 = [173,216,230]/255; % light blue
lineWidth.line1 = 3;
lineWidth.line2 = 3;
lineWidth.line3 = 3;
lineWidth.line4 = 3;
style.line1 = '-';
style.line2 = '--';
style.line3 = '-';
style.line4 = '--';
style.marker1 = 's';
style.marker2 = 's';
style.marker3 = 'd';
style.marker4 = 'd';
markerSize = 10;
color.regularMood = [244 177 131]/255;
color.positiveMood = [157 195 230]/255;

fixYLimit = 0;
addedMarginUp = 0.15;
addedMarginDown = 0.05;

switch(parameterName)
    case 'Default'
        fullPlot = 1;
    case 'ControlCost'
        xtitle = 'Control Cost';
        fullPlot = 0;
    case 'Expected Task Difficulty'
        xtitle = 'Expected Task Difficulty';
        fullPlot = 0;
    case 'Utility Discounting'
        xtitle = 'Utility Discounting';
        fullPlot = 0;
     case 'Reward'
        xtitle = 'Reward';  
        fullPlot = 0;
    otherwise
        error('Could not recognize parameter name.');
end

if(fullPlot)
    %% Gratton 

    fig1 = figure();
    set(fig1, 'Position', [100 450 225 200]);

    nSubj = length(RT_results(1).Gratton.incINC);
    fixYLimit = 1;
    ylimitRT = [0.35 0.55];
    ylimitER = [0 0.4];

    for paramIdx=1:1

%         subplot(1,length(parameterValues),paramIdx);

        RT = RT_results(paramIdx).Gratton;
        ER = ER_results(paramIdx).Gratton;

    if(plotRT)
        % plot RT data

        ydata3_mean = [mean(RT.conINC) mean(RT.incINC)];
        ydata4_mean = [mean(RT.conCON) mean(RT.incCON)];

        ydata3_sem = [std(RT.conINC) std(RT.incINC)] / sqrt(nSubj);
        ydata4_sem = [std(RT.conCON) std(RT.incCON)] / sqrt(nSubj);

        xdata = 1:length(ydata3_mean);
        errorbar(xdata, ydata3_mean, ydata3_sem, style.line3, 'Color', color.line3, 'LineWidth', lineWidth.line3); hold on;
        errorbar(xdata, ydata4_mean, ydata4_sem, style.line3, 'Color', color.line1, 'LineWidth', lineWidth.line4); 

        legend('Current Trial Incongruent ','Current Trial Congruent', 'Location', 'northoutside');

        if(fixYLimit)
            ylim(ylimitRT);
        end
        xlim([min(xdata)-0.2 max(xdata)+0.2]);
        set(gca,'Xtick',[1 2])
        set(gca, 'XTickLabel', {'Congruent', 'Incongruent'});
        set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
        ylabel('Reaction Time (s)', 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
        xlabel('Previous Trial', 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    %     title({'Congruency Sequence' 'Effect'}, 'FontSize', fontSize.title, 'FontWeight', fontWeight.title);

    else
        % plot ER data

        ydata3_mean = [mean(ER.conINC) mean(ER.incINC)] *100;
        ydata4_mean = [mean(ER.conCON) mean(ER.incCON)] *100;
        ydata3_sem = [std(ER.conINC) std(ER.incINC)] /sqrt(nSubj) *100;
        ydata4_sem = [std(ER.conCON) std(ER.incCON)] /sqrt(nSubj) *100;
        xdata = 1:length(ydata3_mean);
        errorbar(xdata, ydata3_mean, ydata3_sem, style.line3, 'Color', color.line3, 'LineWidth', lineWidth.line3); hold on;
        errorbar(xdata, ydata4_mean, ydata4_sem, style.line3, 'Color', color.line1, 'LineWidth', lineWidth.line4); 

        legend('Current Trial Incongruent ','Current Trial Congruent', 'Location', 'northoutside');

        if(fixYLimit)
            ylim(ylimitER * 100);
        end
        xlim([min(xdata)-0.2 max(xdata)+0.2]);
        set(gca,'Xtick',[1 2])
        set(gca, 'XTickLabel', {'Congruent', 'Incongruent'});
        set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
        ylabel('Error Rate (%)', 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
        xlabel('Previous Trial', 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    %     title({'Congruency Sequence' 'Effect'}, 'FontSize', fontSize.title, 'FontWeight', fontWeight.title);


    end

%     title(titles{paramIdx}, 'FontSize', fontSize.title, 'FontWeight', fontWeight.title);

    end

    %% Goschke

    fig2 = figure();
    set(fig2, 'Position', [100 100 225 200]);

    for paramIdx=1:length(parameterValues)

        subplot(1,length(parameterValues),paramIdx);

        RT = RT_results(paramIdx).Goschke;
        ER = ER_results(paramIdx).Goschke;

        fixYLimit = 1;
        ylimitRT = [0.4 0.7];
        ylimitER = [0 0.5];

    if(plotRT)
        % plot RT data

        ydata3_mean = [mean(RT.rep_inc) mean(RT.switch_inc)];
        ydata4_mean = [mean(RT.rep_con) mean(RT.switch_con)];

        ydata3_sem = [std(RT.rep_inc) std(RT.switch_inc)] / sqrt(nSubj);
        ydata4_sem = [std(RT.rep_con) std(RT.switch_con)] / sqrt(nSubj);

        xdata = 1:length(ydata3_mean);
        errorbar(xdata, ydata3_mean, ydata3_sem, style.line3, 'Color', color.line3, 'LineWidth', lineWidth.line3); hold on;
        errorbar(xdata, ydata4_mean, ydata4_sem, style.line3, 'Color', color.line1, 'LineWidth', lineWidth.line4); 

        legend('Current Trial Incongruent','Current Trial Congruent', 'Location', 'northoutside');

        if(fixYLimit)
            ylim(ylimitRT);
        end
        xlim([min(xdata)-0.2 max(xdata)+0.2]);
        set(gca,'Xtick',[1 2])
        set(gca, 'XTickLabel', {'Repetition', 'Switch'});
        set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
        ylabel('Reaction Time (s)', 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
        xlabel('Task Transition', 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    %     title({'Congruency Sequence' 'Effect'}, 'FontSize', fontSize.title, 'FontWeight', fontWeight.title);

    else
        % plot ER data

        ydata3_mean = [mean(ER.rep_inc) mean(ER.switch_inc)];
        ydata4_mean = [mean(ER.rep_con) mean(ER.switch_con)];

        ydata3_sem = [std(ER.rep_inc) std(ER.switch_inc)] / sqrt(nSubj);
        ydata4_sem = [std(ER.rep_con) std(ER.switch_con)] / sqrt(nSubj);

        xdata = 1:length(ydata3_mean);
        errorbar(xdata, ydata3_mean, ydata3_sem, style.line3, 'Color', color.line3, 'LineWidth', lineWidth.line3); hold on;
        errorbar(xdata, ydata4_mean, ydata4_sem, style.line3, 'Color', color.line1, 'LineWidth', lineWidth.line4); 

        legend('Current Trial Incongruent','Current Trial Congruent', 'Location', 'northoutside');

        if(fixYLimit)
            ylim(ylimitER);
        end
        xlim([min(xdata)-0.2 max(xdata)+0.2]);
        set(gca,'Xtick',[1 2])
        set(gca, 'XTickLabel', {'Repetition', 'Switch'});
        set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
        ylabel('Error Rate (%)', 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
        xlabel('Task Transition', 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    %     title({'Congruency Sequence' 'Effect'}, 'FontSize', fontSize.title, 'FontWeight', fontWeight.title);

    end

%     title(titles{paramIdx}, 'FontSize', fontSize.title, 'FontWeight', fontWeight.title);

    end

else
    
    %% Gratton 

    fig1 = figure(1);
    set(fig1, 'Position', [100 450 450 200]);

    nSubj = length(RT_results(1).Gratton.incINC);
    fixYLimit = 0;
    ylimitRT = [0.35 0.55];
    ylimitER = [0 0.4];
    
    % RT
    subplot(1,2,1);

    % plot RT data

    barData_mean = [mean(RT_results(1).Gratton.conINC-RT_results(1).Gratton.incINC) ...
                                mean(RT_results(2).Gratton.conINC-RT_results(2).Gratton.incINC)]*1000;
                            
    barData_sem = [std(RT_results(1).Gratton.conINC-RT_results(1).Gratton.incINC) ...
                                std(RT_results(2).Gratton.conINC-RT_results(2).Gratton.incINC)]*1000/sqrt(nSubj);

    hold on;
    h1 = bar(1, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.regularMood);
    end
    
    errorbar(barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitRT);
    end
    set(gca,'Xtick',[1 2])
    set(gca, 'XTickLabel', { 'Low', 'High'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Congruency Sequence Effect' 'in Reaction Time (ms)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    

    % ER
    subplot(1,2,2);

    % plot ER data

    barData_mean = [mean(ER_results(1).Gratton.conINC-ER_results(1).Gratton.incINC) ...
                                mean(ER_results(2).Gratton.conINC-ER_results(2).Gratton.incINC)]*100;
                            
    barData_sem = [std(ER_results(1).Gratton.conINC-ER_results(1).Gratton.incINC) ...
                                std(ER_results(2).Gratton.conINC-ER_results(2).Gratton.incINC)]*100/sqrt(nSubj);

    hold on;
    h1 = bar(1, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.regularMood);
    end
    
    errorbar(barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitER);
    end
    set(gca,'Xtick',[1 2])
    set(gca, 'XTickLabel', { 'Low', 'High'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Congruency Sequence Effect' 'in Error Rate (%)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    

    %% Congruency Effect 

    fig5 = figure(5);
    set(fig5, 'Position', [600 450 450 200]);

    nSubj = length(RT_results(1).Gratton.incINC);
    fixYLimit = 0;
    ylimitRT = [0 100];
    ylimitER = [0 30];
    
    % RT
    subplot(1,2,1);

    % plot RT data

    barData_mean = [mean(RT_results(1).Gratton.inc-RT_results(1).Gratton.con) ...
                                mean(RT_results(2).Gratton.inc-RT_results(2).Gratton.con)]*1000;
                            
    barData_sem = [std(RT_results(1).Gratton.inc-RT_results(1).Gratton.con) ...
                                std(RT_results(2).Gratton.inc-RT_results(2).Gratton.con)]*1000/sqrt(nSubj);

    hold on;
    h1 = bar(1, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.regularMood);
    end
    
    errorbar(barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitRT);
    end
    set(gca,'Xtick',[1 2])
    set(gca, 'XTickLabel', { 'Low', 'High'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Congruency Effect' 'in Reaction Time (ms)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    

    % ER
    subplot(1,2,2);

    % plot ER data

    barData_mean = [mean(ER_results(1).Gratton.inc-ER_results(1).Gratton.con) ...
                                mean(ER_results(2).Gratton.inc-ER_results(2).Gratton.con)]*100;
                            
    barData_sem = [std(ER_results(1).Gratton.inc-ER_results(1).Gratton.con) ...
                                std(ER_results(2).Gratton.inc-ER_results(2).Gratton.con)]*100/sqrt(nSubj);

    hold on;
    h1 = bar(1, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.regularMood);
    end
    
    errorbar(barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitER);
    end
    set(gca,'Xtick',[1 2])
    set(gca, 'XTickLabel', { 'Low', 'High'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Congruency Effect' 'in Error Rate (%)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    
    %% Overall performance congruency

    fig3 = figure(3);
    set(fig3, 'Position', [600 450 650 200]);

    nSubj = length(RT_results(1).Gratton.incINC);
    fixYLimit = 0;
    ylimitRT = [0 600];
    ylimitER = [0 50];
    
    % RT
    subplot(1,2,1);

    % plot RT data

    barData_mean = [mean(RT_results(1).Gratton.inc) ...
                                mean(RT_results(1).Gratton.con) ... 
                                mean(RT_results(2).Gratton.inc) ...
                                mean(RT_results(2).Gratton.con)]*1000;
                            
    barData_sem = [std(RT_results(1).Gratton.inc) ...
                              std(RT_results(1).Gratton.con) ...
                                std(RT_results(2).Gratton.inc) ...
                                std(RT_results(2).Gratton.con)]*1000/sqrt(nSubj);

    hold on;
    h1 = bar(0.5, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    h3 = bar(3.5, barData_mean(3)); 
    h4 = bar(5, barData_mean(4)); 
    
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.regularMood);
        set(h3, 'FaceColor', color.positiveMood);
        set(h4, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.positiveMood);
        set(h3, 'FaceColor', color.regularMood);
        set(h4, 'FaceColor', color.regularMood);
    end
    
    errorbar([0.5 2 3.5 5], barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitRT);
    end
    set(gca,'Xtick',[0.5 2 3.5 5])
    set(gca, 'XTickLabel', { 'LowINC', 'LowCON',  'HighINC', 'HighCON'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel-2, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Reaction Time (ms)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    

    % ER
    subplot(1,2,2);

    % plot ER data
    
    barData_mean = [mean(ER_results(1).Gratton.inc) ...
                                mean(ER_results(1).Gratton.con) ... 
                                mean(ER_results(2).Gratton.inc) ...
                                mean(ER_results(2).Gratton.con)]*100;
                            
    barData_sem = [std(ER_results(1).Gratton.inc) ...
                              std(ER_results(1).Gratton.con) ...
                                std(ER_results(2).Gratton.inc) ...
                                std(ER_results(2).Gratton.con)]*100/sqrt(nSubj);

    hold on;
    h1 = bar(0.5, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    h3 = bar(3.5, barData_mean(3)); 
    h4 = bar(5, barData_mean(4));
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.regularMood);
        set(h3, 'FaceColor', color.positiveMood);
        set(h4, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.positiveMood);
        set(h3, 'FaceColor', color.regularMood);
        set(h4, 'FaceColor', color.regularMood);
    end
    
    errorbar([0.5 2 3.5 5], barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitER);
    end
    set(gca,'Xtick',[0.5 2 3.5 5])
    set(gca, 'XTickLabel', { 'LowINC', 'LowCON',  'HighINC', 'HighCON'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel-2, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Error Rate (%)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    


    %% Goschke

    fig2 = figure(2);
    set(fig2, 'Position', [100 100 450 200]);

    nSubj = length(RT_results(1).Gratton.incINC);
    fixYLimit = 0;
    ylimitRT = [0.35 0.55];
    ylimitER = [0 0.4];

    % RT
    subplot(1,2,1);

    % plot RT data

    barData_mean = [mean(RT_results(1).Goschke.switch-RT_results(1).Goschke.rep) ...
                                mean(RT_results(2).Goschke.switch-RT_results(2).Goschke.rep)]*1000;
                            
    barData_sem = [std(RT_results(1).Goschke.switch-RT_results(1).Goschke.rep) ...
                                std(RT_results(2).Goschke.switch-RT_results(2).Goschke.rep)]*1000/sqrt(nSubj);

    hold on;
    h1 = bar(1, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.regularMood);
    end
    
    errorbar(barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitRT);
    end
    set(gca,'Xtick',[1 2])
    set(gca, 'XTickLabel', { 'Low', 'High'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Switch Cost' 'in Reaction Time (ms)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    

    % ER
    subplot(1,2,2);

    % plot ER data

    barData_mean = [mean(ER_results(1).Gratton.conINC-ER_results(1).Gratton.incINC) ...
                                mean(ER_results(2).Gratton.conINC-ER_results(2).Gratton.incINC)]*100;
                            
    barData_sem = [std(ER_results(1).Gratton.conINC-ER_results(1).Gratton.incINC) ...
                                std(ER_results(2).Gratton.conINC-ER_results(2).Gratton.incINC)]*100/sqrt(nSubj);

    hold on;
    h1 = bar(1, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.regularMood);
    end
    
    errorbar(barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitER);
    end
    set(gca,'Xtick',[1 2])
    set(gca, 'XTickLabel', { 'Low', 'High'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Switch Cost' 'in Error Rate (%)'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    

   %% Mean Intensity

    fig4 = figure(4);
    set(fig4, 'Position', [600 100 450 200]);

    nSubj = length(RT_results(1).Gratton.incINC);
    fixYLimit = 1;
    ylimitRT = [0.35 0.55];
    ylimitER = [0 0.4];
    ylimitIntensity = [0 2.5];
    
    % RT
    subplot(1,2,1);

    % plot RT data

    barData_mean = [mean(results(1).Gratton.meanIntensity) ...
                                mean(results(2).Gratton.meanIntensity)];
                            
    barData_sem = [std(results(1).Gratton.meanIntensity) ...
                                std(results(1).Gratton.meanIntensity)]/sqrt(nSubj);

    hold on;
    h1 = bar(1, barData_mean(1)); 
    h2 = bar(2, barData_mean(2)); 
    
    if(strcmp(parameterName, 'Utility Discounting') || strcmp(parameterName, 'Reward') )
        set(h1, 'FaceColor', color.regularMood);
        set(h2, 'FaceColor', color.positiveMood);
    else
        set(h1, 'FaceColor', color.positiveMood);
        set(h2, 'FaceColor', color.regularMood);
    end
    
    errorbar(barData_mean, barData_sem, '.', 'Color', 'k', 'LineWidth', 2); hold on;
    hold off;

    if(fixYLimit)
        ylim(ylimitIntensity);
    end
    set(gca,'Xtick',[1 2])
    set(gca, 'XTickLabel', { 'Low', 'High'});
    xlabel(xtitle, 'FontSize', fontSize.xlabel, 'FontWeight', fontWeight.xlabel);
    set(gca, 'FontSize', fontSize.TickLabel, 'FontWeight', fontWeight.TickLabel);
    ylabel({'Control Signal Intensity'}, 'FontSize', fontSize.ylabel, 'FontWeight', fontWeight.ylabel);
    


end

end