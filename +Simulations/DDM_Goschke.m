classdef DDM_Goschke < Simulations.DDMSim
    
    % description of class
    % simulates sequential control adjustments in response to conflict (see
    % Goschke 1992)
    
    % global parameters
    properties
        automaticControlMappingFnc
        automaticControlFnc
        automaticControlProcess
        
        fitMainEffects
        taskSequence
        
        taskAReward = 100;
        taskBReward = 100;
    end
    
    methods
        
        function this = DDM_Goschke()

            import EVC.*;
            import EVC.DDM.*;
            
            % call parent constructor
            this = this@Simulations.DDMSim();
            
            %% general simulation parameters
            
            this.nSubj = 2;
            this.plotSum = true;
            
            this.learningFnc(1).params{1} = 0.2; 
            this.defaultCostFnc.params{1} = 4;
            this.defaultCostFnc.params{2} = 0;
            this.reconfCostFnc.params{1} = 5.7;
            this.reconfCostFnc.params{2} = 0;     
            
            this.rewardFnc.params{2} = 0; % reward RT discount
            
            temp.rewardFnc.params{1} = this.rewardFnc.params{1};
            temp.rewardFnc.params{2} = this.rewardFnc.params{2};
            temp.rewardFnc.params{3} = 1;
            temp.rewardFnc.params{4} = 0;
            temp.rewardFnc.type = EVCFnc.REWRATE_EXT;
            this.rewardFnc = EVCFnc(temp.rewardFnc.type, temp.rewardFnc.params);
               
            this.defaultDDMParams.c = 0.699; 
            this.defaultDDMParams.thresh = 1.06;             
            this.defaultDDMParams.T0 = 0.15;                    
            
            %% automatic/control process
           
            % generate 3 control signals, one for the target stimulus & two
            % for the flanker stimuli
            
            % signal range
            tmp.IntensityRange = [0:0.2:15]; % [0:0.2:10]
            
            % signal for task A
           this.ctrlSignals(1) = CtrlSignal(this.defaultCtrlSignal);
           this.ctrlSignals(1).CtrlSigStimMap  = [1 0];
           this.ctrlSignals(1).IntensityRange = tmp.IntensityRange;
            
           % signal for task B
           this.ctrlSignals(2) = CtrlSignal(this.defaultCtrlSignal);
           this.ctrlSignals(2).CtrlSigStimMap  = [0 1];
           this.ctrlSignals(2).IntensityRange = tmp.IntensityRange;
           
            %% define DDM processes
            
            % map all control processes to a specific DDM parameter
            
            % target
            temp.taskAControlFnc.type = DDMFnc.INTENSITY2DDM_EFFICACY;
            temp.taskAControlFnc.params{1} = this.ctrlSignals(1);
            temp.taskAControlFnc.params{2} = this.defaultControlProxy;
            temp.taskAControlFnc.params{3} = this.defaultControlMappingFnc;
            temp.taskAControlFnc.params{4} = 1;
            temp.taskAControlFnc = DDMFnc(temp.taskAControlFnc.type, ...
                                            temp.taskAControlFnc.params);
            
            % flanker 1                            
            temp.taskBControlFnc.type = DDMFnc.INTENSITY2DDM_EFFICACY;
            temp.taskBControlFnc.params{1} = this.ctrlSignals(2);
            temp.taskBControlFnc.params{2} = this.defaultControlProxy;
            temp.taskBControlFnc.params{3} = this.defaultControlMappingFnc;
            temp.taskBControlFnc.params{4} = 1;
            temp.taskBControlFnc = DDMFnc(temp.taskBControlFnc.type, ...
                                            temp.taskBControlFnc.params);
            
            % define each DDM process
            temp.taskAProcess = DDMProc(DDMProc.CONTROL, ...                  % default controlled DDM process 
                                                    DDMProc.DRIFT, ...
                                                    temp.taskAControlFnc);
           
            temp.taskBProcess = DDMProc(DDMProc.CONTROL, ...                  % default controlled DDM process 
                                        DDMProc.DRIFT, ...
                                        temp.taskBControlFnc);

            % put all DDM processes together
            this.DDMProcesses = DDMProc.empty(4,0);
            this.DDMProcesses(1) =   this.defaultAutomaticProcess;
            this.DDMProcesses(2) =   temp.taskAProcess;
            this.DDMProcesses(3) =   temp.taskBProcess;
            
            
            %% task environment parameters: task environment
            
            % create a congruent trial for Task A
            this.trials(1).ID = 1;                                                          % trial identification number (for task set)
            this.trials(1).typeID = 1;                                                      % trial type (defines task context)
            this.trials(1).cueID = 1;                                                       % cued information about trial identity
            this.trials(1).descr = 'A_con';                                                 % trial description
            this.trials(1).conditions    = [0 0];                                           % set of trial conditions (for logging)
            this.trials(1).outcomeValues = [this.taskAReward 0];                                           % reward for correct outcome = 3; no reward/punishment for incorrect outcome
            this.trials(1).stimSalience  = [1 1];                                       % relative salience between stimulus 1 and stimulus 2 defines level of incongruency; here stim 2 is more dominant (like in stroop)
            this.trials(1).stimRespMap   = [0.4 0;                                            % responding to stimulus 1 tends to produce first outcome by 100%
                                                            0.4 0];                                          % responding to stimulus 3 tends to produce second outcome by 100%
            this.trials(1).params = [];                                                   % DDM specific trial parameters
            this.trials(1).cueOutcomeValues = 1;                                    % cue the outcome value for this trial

            % create an incongruent trial for Task A
            this.trials(2).ID = 1;                                                          % trial identification number (for task set)
            this.trials(2).typeID = 1;                                                      % trial type (defines task context)
            this.trials(2).cueID = 1;                                                       % cued information about trial identity
            this.trials(2).descr = 'A_inc';                                                 % trial description
            this.trials(2).conditions    = [0 1];                                           % set of trial conditions (for logging)
            this.trials(2).outcomeValues = [this.taskAReward 0];                                           % reward for correct outcome = 3; no reward/punishment for incorrect outcome
            this.trials(2).stimSalience  = [1 1];                                       % relative salience between stimulus 1 and stimulus 2 defines level of incongruency; here stim 2 is more dominant (like in stroop)
            this.trials(2).stimRespMap   = [0.4 0;                                            % responding to stimulus 1 tends to produce first outcome by 100%
                                                            0 0.4];                                          % responding to stimulus 3 tends to produce second outcome by 100%
            this.trials(2).params = [];                                                   % DDM specific trial parameters
            this.trials(2).cueOutcomeValues = 1;                                    % cue the outcome value for this trial

            % create a congruent trial for Task B
            this.trials(3).ID = 1;                                                          % trial identification number (for task set)
            this.trials(3).typeID = 1;                                                        % trial type (defines task context)
            this.trials(3).cueID = 1;                                                       % cued information about trial identity
            this.trials(3).descr = 'B_con';                                                 % trial description
            this.trials(3).conditions    = [1 0];                                           % set of trial conditions (for logging)
            this.trials(3).outcomeValues = [0 this.taskBReward];                                           % reward for correct outcome = 3; no reward/punishment for incorrect outcome
            this.trials(3).stimSalience  = [1 1];                                       % relative salience between stimulus 1 and stimulus 2 defines level of incongruency; here stim 2 is more dominant (like in stroop)
            this.trials(3).stimRespMap   = [0 0.4;                                            % responding to stimulus 1 tends to produce first outcome by 100%
                                            0 0.4];                                          % responding to stimulus 3 tends to produce second outcome by 100%
            this.trials(3).params = [];                                                   % DDM specific trial parameters
            this.trials(3).cueOutcomeValues = 1;                                    % cue the outcome value for this trial

            % create an incongruent trial for Task B
            this.trials(4).ID = 1;                                                          % trial identification number (for task set)
            this.trials(4).typeID = 1;                                                        % trial type (defines task context)
            this.trials(4).cueID = 1;                                                       % cued information about trial identity
            this.trials(4).descr = 'B_inc';                                                 % trial description
            this.trials(4).conditions    = [1 1];                                           % set of trial conditions (for logging)
            this.trials(4).outcomeValues = [0 this.taskBReward];                                           % reward for correct outcome = 3; no reward/punishment for incorrect outcome
            this.trials(4).stimSalience  = [1 1];                                       % relative salience between stimulus 1 and stimulus 2 defines level of incongruency; here stim 2 is more dominant (like in stroop)
            this.trials(4).stimRespMap   = [0.4 0;                                            % responding to stimulus 1 tends to produce first outcome by 100%
                                            0 0.4];                                          % responding to stimulus 3 tends to produce second outcome by 100%
            this.trials(4).params = [];                                                   % DDM specific trial parameters
            this.trials(4).cueOutcomeValues = 1;                                    % cue the outcome value for this trial
            
            this.nTrials = 200;
            
            %% log parameters
            
            this.fitMainEffects = 1;
            
            this.writeLogFile = 1; 
            this.logFileName = 'DDM_Goschke'; 
            
            this.logAddVars{3} = '[this.EVCM.Log.Trials.conditions]''';
            this.logAddVarNames{3} = 'condition';
        end
        
        function getResults(this)
            
            this.results.analysis.RTData = [];
            this.results.analysis.ERData = [];
            this.results.analysis.congruency = [];
            this.results.analysis.transition = [];
            this.results.analysis.subject = [];
            
            for subj = 1:this.nSubj
                
                subjLog = this.subjData(subj).Log;
                conditions = reshape([subjLog.TrialsOrg.conditions],[3 this.nTrials])';
                task = conditions(:,1);
                congruency = conditions(:,2);
                transition = conditions(:,3);
                
                % retrieve intensities and delta-reward from log data
                RT = this.subjData(subj).Log.RTs(:,2)';
                ER = this.subjData(subj).Log.ERs(:,2)';
                drift = abs(this.subjData(subj).Log.drift);
                
                this.results.meanIntensity(subj, :) = mean(subjLog.CtrlIntensities(:));
                taskAIntensity = subjLog.CtrlIntensities(:,1);
                taskBIntensity = subjLog.CtrlIntensities(:,2);
                targetIntensity = nan(size(taskAIntensity));
                flankerIntensity = nan(size(taskAIntensity));
                
                for trial = 1:length(task)
                    if(task(trial) == 0)
                        targetIntensity(trial) = taskAIntensity(trial);
                        flankerIntensity(trial) = taskBIntensity(trial);
                    else
                        targetIntensity(trial) = taskBIntensity(trial);
                        flankerIntensity(trial) = taskAIntensity(trial);
                    end
                end

                switch_RT = RT(transition == 1);
                rep_RT = RT(transition == 0);
                switch_ER = ER(transition == 1);
                rep_ER = ER(transition == 0);
                
                con_RT = RT(congruency == 0);
                inc_RT = RT(congruency == 1);
                con_ER = ER(congruency == 0);
                inc_ER = ER(congruency == 1);
                
                rep_con_RT = RT(transition == 0 & congruency == 0);
                rep_inc_RT = RT(transition == 0 & congruency == 1);
                switch_con_RT = RT(transition == 1 & congruency == 0);
                switch_inc_RT = RT(transition == 1 & congruency == 1);
                rep_con_ER = ER(transition == 0 & congruency == 0);
                rep_inc_ER = ER(transition == 0 & congruency == 1);
                switch_con_ER = ER(transition == 1 & congruency == 0);
                switch_inc_ER = ER(transition == 1 & congruency == 1);
                rep_con_drift = drift(transition == 0 & congruency == 0);
                rep_inc_drift = drift(transition == 0 & congruency == 1);
                switch_con_drift = drift(transition == 1 & congruency == 0);
                switch_inc_drift = drift(transition == 1 & congruency == 1);
                
                rep_targetIntensity = targetIntensity(transition == 0);
                switch_targetIntensity = targetIntensity(transition == 1);
                rep_flankerIntensity = flankerIntensity(transition == 0);
                switch_flankerIntensity = flankerIntensity(transition == 1);
                
                taskA_RT = RT(task == 0);
                taskB_RT = RT(task == 1);
                taskA_ER = ER(task == 0);
                taskB_ER = ER(task == 1);
                
                taskA_switch_RT = RT(transition == 1 & task == 0);
                taskA_rep_RT = RT(transition == 0 & task == 0);
                taskB_switch_RT = RT(transition == 1 & task == 1);
                taskB_rep_RT = RT(transition == 0 & task == 1);
                taskA_switch_ER = ER(transition == 1 & task == 0);
                taskA_rep_ER = ER(transition == 0 & task == 0);
                taskB_switch_ER = ER(transition == 1 & task == 1);
                taskB_rep_ER = ER(transition == 0 & task == 1);
                
                % extract relevant test vectors
                this.results.RT.overall(subj) = mean(RT);
                this.results.ER.overall(subj) = mean(ER);
                this.results.RT.switch(subj) = mean(switch_RT);
                this.results.RT.rep(subj) = mean(rep_RT);
                this.results.ER.switch(subj) = mean(switch_ER);
                this.results.ER.rep(subj) = mean(rep_ER);
                this.results.RT.con(subj) = mean(con_RT);
                this.results.RT.inc(subj) = mean(inc_RT);
                this.results.ER.con(subj) = mean(con_ER);
                this.results.ER.inc(subj) = mean(inc_ER);
                this.results.RT.taskA(subj) = mean(taskA_RT);
                this.results.RT.taskB(subj) = mean(taskB_RT);
                this.results.ER.taskA(subj) = mean(taskA_ER);
                this.results.ER.taskB(subj) = mean(taskB_ER);
                this.results.RT.taskA_switch(subj) = mean(taskA_switch_RT);
                this.results.RT.taskA_rep(subj) = mean(taskA_rep_RT);
                this.results.RT.taskB_switch(subj) = mean(taskB_switch_RT);
                this.results.RT.taskB_rep(subj) = mean(taskB_rep_RT);
                this.results.ER.taskA_switch(subj) = mean(taskA_switch_ER);
                this.results.ER.taskA_rep(subj) = mean(taskA_rep_ER);
                this.results.ER.taskB_switch(subj) = mean(taskB_switch_ER);
                this.results.ER.taskB_rep(subj) = mean(taskB_rep_ER);
                this.results.RT.rep_con(subj) = mean(rep_con_RT);
                this.results.RT.rep_inc(subj) = mean(rep_inc_RT);
                this.results.RT.switch_con(subj) = mean(switch_con_RT);
                this.results.RT.switch_inc(subj) = mean(switch_inc_RT);
                this.results.ER.rep_con(subj) = mean(rep_con_ER);
                this.results.ER.rep_inc(subj) = mean(rep_inc_ER);
                this.results.ER.switch_con(subj) = mean(switch_con_ER);
                this.results.ER.switch_inc(subj) = mean(switch_inc_ER);
                this.results.drift.rep_con(subj) = mean(rep_con_drift);
                this.results.drift.rep_inc(subj) = mean(rep_inc_drift);
                this.results.drift.switch_con(subj) = mean(switch_con_drift);
                this.results.drift.switch_inc(subj) = mean(switch_inc_drift);
                this.results.targetIntensity.rep(subj) = mean(rep_targetIntensity);
                this.results.targetIntensity.switch(subj) = mean(switch_targetIntensity);
                this.results.flankerIntensity.rep(subj) = mean(rep_flankerIntensity);
                this.results.flankerIntensity.switch(subj) = mean(switch_flankerIntensity);
                this.results.targetIntensity.mean(subj) = mean(targetIntensity);
                this.results.flankerIntensity.mean(subj) = mean(targetIntensity);
                
                this.results.analysis.RTData = [this.results.analysis.RTData; RT'];
                this.results.analysis.ERData = [this.results.analysis.ERData; ER'];
                this.results.analysis.congruency = [this.results.analysis.congruency; (congruency+1)];
                this.results.analysis.transition = [this.results.analysis.transition; (transition+1)];
                this.results.analysis.subject = [this.results.analysis.subject; repmat(subj, length(RT), 1)];

                
                this.results.meanIntensity(subj, :) = mean(subjLog.CtrlIntensities(1));
                
            end
            
            % switch costs tests
            [this.results.h_switchCostsRT this.results.p_switchCostsRT] = ttest(this.results.RT.switch-this.results.RT.rep,0);
            this.results.switch_RT_mean = mean(this.results.RT.switch);
            this.results.rep_RT_mean = mean(this.results.RT.rep);
            
            [this.results.h_switchCostsER this.results.p_switchCostsER] = ttest(this.results.ER.switch-this.results.ER.rep,0);
            this.results.switch_ER_mean = mean(this.results.ER.switch);
            this.results.rep_ER_mean = mean(this.results.ER.rep);
            
            % incongruency tests
            [this.results.h_incCostsRT this.results.p_incCostsRT] = ttest(this.results.RT.inc-this.results.RT.con,0);
            this.results.con_RT_mean = mean(this.results.RT.con);
            this.results.inc_RT_mean = mean(this.results.RT.inc);
            
            [this.results.h_incCostsER this.results.p_incCostsER] = ttest(this.results.ER.inc-this.results.ER.con,0);
            this.results.con_ER_mean = mean(this.results.ER.con);
            this.results.inc_ER_mean = mean(this.results.ER.inc);
            
            % task tests
            [this.results.h_taskCostsRT this.results.p_taskCostsRT] = ttest(this.results.RT.taskA-this.results.RT.taskB,0);
            this.results.taskA_RT_mean = mean(this.results.RT.taskA);
            this.results.taskB_RT_mean = mean(this.results.RT.taskB);
            
            [this.results.h_taskCostsER this.results.p_taskCostsER] = ttest(this.results.ER.taskA-this.results.ER.taskB,0);
            this.results.taskA_ER_mean = mean(this.results.ER.taskA);
            this.results.taskB_ER_mean = mean(this.results.ER.taskB);
            
            removeTrials = find(this.results.analysis.transition ~= 1 & this.results.analysis.transition ~= 2);
            this.results.analysis.RTData(removeTrials) = [];
            this.results.analysis.ERData(removeTrials) = [];
            this.results.analysis.subject(removeTrials) = [];
            this.results.analysis.congruency(removeTrials) = [];
            this.results.analysis.transition(removeTrials) = [];
            
            % 2x2 repeated measures ANOVA
            this.results.ANOVA_RT.main.stats = rm_anova2(this.results.analysis.RTData, ...
                                                                                this.results.analysis.subject, ...
                                                                                this.results.analysis.congruency, ...
                                                                                this.results.analysis.transition, ...
                                                                                {'congruency', 'transition'});
                                                                            
           this.results.ANOVA_ER.main.stats = rm_anova2(this.results.analysis.ERData, ...
                                                                                this.results.analysis.subject, ...
                                                                                this.results.analysis.congruency, ...
                                                                                this.results.analysis.transition, ...
                                                                                {'congruency', 'transition'});                                                                 
        end
        
        function dispResults(this)
            
              mc = metaclass(this);
              disp(['++++++++++ ' mc.Name ' ++++++++++']);
              
              % inference statistics
                disp('---');
                disp(['RT ANOVA (2x2), congruency, F(' num2str(this.results.ANOVA_RT.main.stats{2,3}) ... % df for interaction = df(condition 1) * df(condition 2)
                                                                  ', ' num2str(this.results.ANOVA_RT.main.stats{5,3}) ...    
                                                                  ') = ' num2str(this.results.ANOVA_RT.main.stats{2,end-1}) ...
                                                                  ', p = ' num2str(this.results.ANOVA_RT.main.stats{2,end})]);
                                                              
                disp(['RT ANOVA (2x2), transition, F(' num2str(this.results.ANOVA_RT.main.stats{3,3}) ... 
                                                              ', ' num2str(this.results.ANOVA_RT.main.stats{6,3}) ...    
                                                              ') = ' num2str(this.results.ANOVA_RT.main.stats{3,end-1}) ...
                                                              ', p = ' num2str(this.results.ANOVA_RT.main.stats{3,end})]);
                                                          
                disp(['RT ANOVA (2x2), congruency x transition, F(' num2str(this.results.ANOVA_RT.main.stats{4,3}) ... 
                                                              ', ' num2str(this.results.ANOVA_RT.main.stats{7,3}) ...    
                                                              ') = ' num2str(this.results.ANOVA_RT.main.stats{4,end-1}) ...
                                                              ', p = ' num2str(this.results.ANOVA_RT.main.stats{4,end})]);
                                                          
                disp(['ER ANOVA (2x2), congruency, F(' num2str(this.results.ANOVA_ER.main.stats{2,3}) ... % df for interaction = df(condition 1) * df(condition 2)
                                                                  ', ' num2str(this.results.ANOVA_ER.main.stats{5,3}) ...    
                                                                  ') = ' num2str(this.results.ANOVA_ER.main.stats{2,end-1}) ...
                                                                  ', p = ' num2str(this.results.ANOVA_ER.main.stats{2,end})]);
                                                              
                disp(['ER ANOVA (2x2), transition, F(' num2str(this.results.ANOVA_ER.main.stats{3,3}) ... 
                                                              ', ' num2str(this.results.ANOVA_ER.main.stats{6,3}) ...    
                                                              ') = ' num2str(this.results.ANOVA_ER.main.stats{3,end-1}) ...
                                                              ', p = ' num2str(this.results.ANOVA_ER.main.stats{3,end})]);
                                                          
                disp(['ER ANOVA (2x2), congruency x transition, F(' num2str(this.results.ANOVA_ER.main.stats{4,3}) ... 
                                                              ', ' num2str(this.results.ANOVA_ER.main.stats{7,3}) ...    
                                                              ') = ' num2str(this.results.ANOVA_ER.main.stats{4,end-1}) ...
                                                              ', p = ' num2str(this.results.ANOVA_ER.main.stats{4,end})]);
              
        end
        
        function plotSummary(this) 
        end
        
        function plotTrialConditions(this)

        end
        
        function plotRTResults(this)
            
            subplot(1,3,1);
            bar(1,[this.results.switch_RT_mean],'FaceColor', this.plotParams.defaultBarColor);
            hold on;
            semBar1 = std(this.results.switch_RT)/sqrt(length(this.results.switch_RT));
            semBar2 = std(this.results.rep_RT)/sqrt(length(this.results.rep_RT));
            errorbar(1,[this.results.switch_RT_mean],semBar1,'Color',this.plotParams.defaultColor);
            bar(2,[this.results.rep_RT_mean],'FaceColor', this.plotParams.defaultBarColor);
            errorbar(2,[this.results.rep_RT_mean],semBar2,'Color',this.plotParams.defaultColor);
            xlim([0 3]);
            bardata = [this.results.switch_RT_mean, this.results.rep_RT_mean];
            range = max(max(abs(bardata)));
            ylim([0 range+0.2*range]);
            set(gca,'Xtick',1:2)
            set(gca,'XTickLabel',{'Switch', 'Rep'},'fontsize',this.plotParams.axisFontSize);
            xlabel('Transition');
            ylabel('RT (ms)','FontSize',this.plotParams.axisFontSize); % y-axis label
            title('Switch Costs','FontSize',this.plotParams.titleFontSize-1,'FontWeight','bold'); % y-axis label
            
            subplot(1,3,2);
            bar(1,[this.results.inc_RT_mean],'FaceColor', this.plotParams.defaultBarColor);
            hold on;
            semBar1 = std(this.results.inc_RT)/sqrt(length(this.results.inc_RT));
            semBar2 = std(this.results.con_RT)/sqrt(length(this.results.con_RT));
            errorbar(1,[this.results.inc_RT_mean],semBar1,'Color',this.plotParams.defaultColor);
            bar(2,[this.results.con_RT_mean],'FaceColor', this.plotParams.defaultBarColor);
            errorbar(2,[this.results.con_RT_mean],semBar2,'Color',this.plotParams.defaultColor);
            xlim([0 3]);
            bardata = [this.results.inc_RT_mean, this.results.con_RT_mean];
            range = max(max(abs(bardata)));
            ylim([0 range+0.2*range]);
            set(gca,'Xtick',1:2)
            set(gca,'XTickLabel',{'Inc', 'Con'},'fontsize',this.plotParams.axisFontSize);
            xlabel('Congruency');
            ylabel('RT (ms)','FontSize',this.plotParams.axisFontSize); % y-axis label
            title('Incongruency Costs','FontSize',this.plotParams.titleFontSize-1,'FontWeight','bold'); % y-axis label
            
            subplot(1,3,3);
            bar(1,[this.results.taskA_RT_mean],'FaceColor', this.plotParams.defaultBarColor);
            hold on;
            semBar1 = std(this.results.taskA_RT)/sqrt(length(this.results.taskA_RT));
            semBar2 = std(this.results.taskB_RT)/sqrt(length(this.results.taskB_RT));
            errorbar(1,[this.results.taskA_RT_mean],semBar1,'Color',this.plotParams.defaultColor);
            bar(2,[this.results.taskB_RT_mean],'FaceColor', this.plotParams.defaultBarColor);
            errorbar(2,[this.results.taskB_RT_mean],semBar2,'Color',this.plotParams.defaultColor);
            xlim([0 3]);
            bardata = [this.results.taskA_RT_mean, this.results.taskB_RT_mean];
            range = max(max(abs(bardata)));
            ylim([0 range+0.2*range]);
            set(gca,'Xtick',1:2)
            set(gca,'XTickLabel',{'A', 'B'},'fontsize',this.plotParams.axisFontSize);
            xlabel('Task');
            ylabel('RT (ms)','FontSize',this.plotParams.axisFontSize); % y-axis label
            title('Task Differences','FontSize',this.plotParams.titleFontSize-1,'FontWeight','bold'); % y-axis label
            
            
        end
        
        function plotERResults(this)
            %%
            subplot(1,3,1);
            bar(1,[this.results.switch_ER_mean],'FaceColor', this.plotParams.defaultBarColor);
            hold on;
            semBar1 = std(this.results.switch_ER)/sqrt(length(this.results.switch_ER));
            semBar2 = std(this.results.rep_ER)/sqrt(length(this.results.rep_ER));
            errorbar(1,[this.results.switch_ER_mean],semBar1,'Color',this.plotParams.defaultColor);
            bar(2,[this.results.rep_ER_mean],'FaceColor', this.plotParams.defaultBarColor);
            errorbar(2,[this.results.rep_ER_mean],semBar2,'Color',this.plotParams.defaultColor);
            xlim([0 3]);
            bardata = [this.results.switch_ER_mean, this.results.rep_ER_mean];
            range = max(max(abs(bardata)));
            ylim([0 range+0.2*range]);
            set(gca,'Xtick',1:2)
            set(gca,'XTickLabel',{'Switch', 'Rep'},'fontsize',this.plotParams.axisFontSize);
            xlabel('Transition');
            ylabel('ER (%)','FontSize',this.plotParams.axisFontSize); % y-axis label
            title('Switch Costs','FontSize',this.plotParams.titleFontSize-1,'FontWeight','bold'); % y-axis label
            
            subplot(1,3,2);
            bar(1,[this.results.inc_ER_mean],'FaceColor', this.plotParams.defaultBarColor);
            hold on;
            semBar1 = std(this.results.inc_ER)/sqrt(length(this.results.inc_ER));
            semBar2 = std(this.results.con_ER)/sqrt(length(this.results.con_ER));
            errorbar(1,[this.results.inc_ER_mean],semBar1,'Color',this.plotParams.defaultColor);
            bar(2,[this.results.con_ER_mean],'FaceColor', this.plotParams.defaultBarColor);
            errorbar(2,[this.results.con_ER_mean],semBar2,'Color',this.plotParams.defaultColor);
            xlim([0 3]);
            bardata = [this.results.inc_ER_mean, this.results.con_ER_mean];
            range = max(max(abs(bardata)));
            ylim([0 range+0.2*range]);
            set(gca,'Xtick',1:2)
            set(gca,'XTickLabel',{'Inc', 'Con'},'fontsize',this.plotParams.axisFontSize);
            xlabel('Congruency');
            ylabel('ER (%)','FontSize',this.plotParams.axisFontSize); % y-axis label
            title('Incongruency Costs','FontSize',this.plotParams.titleFontSize-1,'FontWeight','bold'); % y-axis label
            
            subplot(1,3,3);
            bar(1,[this.results.taskA_ER_mean],'FaceColor', this.plotParams.defaultBarColor);
            hold on;
            semBar1 = std(this.results.taskA_ER)/sqrt(length(this.results.taskA_ER));
            semBar2 = std(this.results.taskB_ER)/sqrt(length(this.results.taskB_ER));
            errorbar(1,[this.results.taskA_ER_mean],semBar1,'Color',this.plotParams.defaultColor);
            bar(2,[this.results.taskB_ER_mean],'FaceColor', this.plotParams.defaultBarColor);
            errorbar(2,[this.results.taskB_ER_mean],semBar2,'Color',this.plotParams.defaultColor);
            xlim([0 3]);
            bardata = [this.results.taskA_ER_mean, this.results.taskB_ER_mean];
            range = max(max(abs(bardata)));
            ylim([0 range+0.2*range]);
            set(gca,'Xtick',1:2)
            set(gca,'XTickLabel',{'A', 'B'},'fontsize',this.plotParams.axisFontSize);
            xlabel('Task');
            ylabel('ER (%)','FontSize',this.plotParams.axisFontSize); % y-axis label
            title('Task Differences','FontSize',this.plotParams.titleFontSize-1,'FontWeight','bold'); % y-axis label
            
            
        end
        
    end
    
    methods (Access = protected)
        
        % generate task environment
        function initTaskEnv(this)
            
            this.initOptimizationTaskEnv();
            
        end
        
    end
    
    methods (Access = public)
        
       function initOptimizationTaskEnv(this)
           
            import EVC.*;
            
            % build & randomize task sequence  
            trials(1) = this.trials(1);
            trials(2) = this.trials(2);
            trials(3) = this.trials(3);
            trials(4) = this.trials(4);   
            this.taskEnv = TaskEnv.randomTaskSwitchDesign(trials, this.nTrials);   
            this.taskEnv.trialTypes{1} = EVC.Trial(this.taskEnv.Sequence(1));
            
            % code conditions
            for trial = 1:length(this.taskEnv.Sequence)
                if(trial > 1)
                    if(isequal(this.taskEnv.Sequence(trial).outcomeValues, this.taskEnv.Sequence(trial-1).outcomeValues))
                        this.taskEnv.Sequence(trial).conditions(3) = 0;
                    else
                        this.taskEnv.Sequence(trial).conditions(3) = 1;
                    end
                else
                    this.taskEnv.Sequence(trial).conditions(3) = -1;
                end
            end 


       end
                           

       function criterion = getOptimizationCriterion(this)
           
           % Goschke & Holroyd (2014) 
           orgData.meanRT_switchR = 1.000;
           orgData.meanRT_switchNonR = 1.060;
           orgData.meanRT_repR = 0.925;
           orgData.meanRT_repNonR = 0.965;
           
           orgData.meanER_switchR = 0.0675;
           orgData.meanER_switchNonR = 0.0875;
           orgData.meanER_repR = 0.0520;
           orgData.meanER_repNonR = 0.0600;
           
           % FIT INTERACTION

           simulation.Intensity = mean(this.results.meanIntensity,2);

           % simulation data
           simulation.RTs.switchR = mean(this.results.RT.switchR);
           simulation.RTs.switchNonR = mean(this.results.RT.switchNonR);
           simulation.RTs.repR = mean(this.results.RT.repR);
           simulation.RTs.repNonR = mean(this.results.RT.repNonR);

           simulation.ERs.switchR = mean(this.results.ER.switchR);
           simulation.ERs.switchNonR = mean(this.results.ER.switchNonR);
           simulation.ERs.repR = mean(this.results.ER.repR);
           simulation.ERs.repNonR = mean(this.results.ER.repNonR);

           RT_Criterion =   abs(simulation.RTs.switchR - orgData.meanRT_switchR) + ...
                                   abs(simulation.RTs.repR - orgData.meanRT_repR) + ...
                                   abs(simulation.RTs.switchNonR - orgData.meanRT_switchNonR) + ...
                                   abs(simulation.RTs.repNonR - orgData.meanRT_repNonR);

           ER_Criterion =   abs(simulation.ERs.switchR - orgData.meanER_switchR) + ...
                                   abs(simulation.ERs.repR - orgData.meanER_repR) + ...
                                   abs(simulation.ERs.switchNonR - orgData.meanER_switchNonR) + ...
                                   abs(simulation.ERs.repNonR - orgData.meanER_repNonR); 

           if(simulation.Intensity == 0)
               intensity_Criterion = 100;
           else
               intensity_Criterion = 0;
           end

           criterion = RT_Criterion + ER_Criterion * 100 + intensity_Criterion;

           disp([RT_Criterion ER_Criterion intensity_Criterion]);       

        end
        
        
    end
    
end

