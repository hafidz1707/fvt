classdef GUI_FresnelVolumeTomografi < matlab.apps.AppBase
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        GridLayout                   matlab.ui.container.GridLayout
        LeftPanel                    matlab.ui.container.Panel
        IterationEditField           matlab.ui.control.NumericEditField
        IterationEditFieldLabel      matlab.ui.control.Label
        AlgorithmButtonGroup         matlab.ui.container.ButtonGroup
        SIRTButton                   matlab.ui.control.RadioButton
        MSIRTButton                  matlab.ui.control.RadioButton
        noteyoucandrawmodelinteractivelyfromgraphicLabel  matlab.ui.control.Label
        DrawModelLabel               matlab.ui.control.Label
        SaveModelSwitch              matlab.ui.control.Switch
        SaveModelSwitchLabel         matlab.ui.control.Label
        VelocitymsEditField          matlab.ui.control.NumericEditField
        VelocitymsEditFieldLabel     matlab.ui.control.Label
        GridHeightSpinner            matlab.ui.control.Spinner
        GridHeightSpinnerLabel       matlab.ui.control.Label
        DimensionDropDown            matlab.ui.control.DropDown
        DimensionDropDownLabel       matlab.ui.control.Label
        SaveSettingSwitch            matlab.ui.control.Switch
        SaveSettingSwitchLabel       matlab.ui.control.Label
        TransducerSpinner            matlab.ui.control.Spinner
        TransducerSpinnerLabel       matlab.ui.control.Label
        ForwardModellingDropDown     matlab.ui.control.DropDown
        ForwardModellingLabel        matlab.ui.control.Label
        SettingLabel                 matlab.ui.control.Label
        ModelBaseDropDown            matlab.ui.control.DropDown
        ModelBaseDropDownLabel       matlab.ui.control.Label
        UnitDropDown_2               matlab.ui.control.DropDown
        UnitDropDown_2Label          matlab.ui.control.Label
        FrequencyHzEditField         matlab.ui.control.NumericEditField
        FrequencyHzEditFieldLabel    matlab.ui.control.Label
        RotateCoreCheckBox           matlab.ui.control.CheckBox
        GridScaleEditField           matlab.ui.control.NumericEditField
        GridScaleEditFieldLabel      matlab.ui.control.Label
        GridSpinner                  matlab.ui.control.Spinner
        GridSpinnerLabel             matlab.ui.control.Label
        StartReconstructionButton    matlab.ui.control.StateButton
        CenterPanel                  matlab.ui.container.Panel
        EditField                    matlab.ui.control.EditField
        EditFieldLabel               matlab.ui.control.Label
        SaveFigureButton_2           matlab.ui.control.StateButton
        UIAxes                       matlab.ui.control.UIAxes
        RightPanel                   matlab.ui.container.Panel
        ShowErrorGraphicSwitch       matlab.ui.control.Switch
        ShowErrorGraphicSwitchLabel  matlab.ui.control.Label
        TimeErrorRMSEditField        matlab.ui.control.NumericEditField
        TimeErrorRMSEditFieldLabel   matlab.ui.control.Label
        VelocityErrorRMSEditField    matlab.ui.control.NumericEditField
        VelocityErrorRMSLabel        matlab.ui.control.Label
        SaveFigureButton             matlab.ui.control.StateButton
        UIAxes2                      matlab.ui.control.UIAxes
        Toolbar                      matlab.ui.container.Toolbar
        PushTool                     matlab.ui.container.toolbar.PushTool
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button down function: CenterPanel
        function CenterPanelButtonDown(app, event)
            
        end

        % Value changed function: FrequencyHzEditField
        function FrequencyHzEditFieldValueChanged(app, event)
            global Frekuensi
            Frekuensi = app.FrequencyHzEditField.Value;
        end

        % Value changing function: TransducerSpinner
        function TransducerSpinnerValueChanging(app, event)
            global b
            b = app.TransducerSpinner.Value;
        end

        % Value changed function: GridScaleEditField
        function GridScaleEditFieldValueChanged(app, event)
            global scale
            scale = app.GridScaleEditFieldValue.Value;
        end

        % Callback function
        function GridSpinnerValueChanging(app, event)
            global N
            N = app.GridSpinner.Value;
        end

        % Value changed function: RotateCoreCheckBox
        function RotateCoreCheckBoxValueChanged(app, event)
            
        end

        % Value changed function: IterationEditField
        function IterationEditFieldValueChanged(app, event)
            global iterasi
            iterasi = app.IterationEditField.Value;
        end

        % Value changed function: SaveSettingSwitch
        function SaveSettingSwitchValueChanged(app, event)
            global N
            N = app.GridSpinner.Value + 1;
            global Smodel
            global Xplot
            global Yplot
            global Vplot
            %scale = app.GridScaleEditField.Value;
            Sawal = 2000;
            Smodel = zeros(N,N);
            Smodel(:,:) = 1/(340*1000); % Kecepatan Udara
            rmod = (N-1)/2;
            for i = 1:N
                for j = 1:N
                    jarak1 = sqrt(((i-1)-rmod)^2+((j-1)-rmod)^2)-0.5;
                    jarak2 = sqrt((i-1-rmod)^2+((j-1)-rmod)^2)-0.5;
                    jarak3 = sqrt(((i-1)-rmod)^2+(j-1-rmod)^2)-0.5;
                    jarak4 = sqrt((i-1-rmod)^2+(j-1-rmod)^2)-0.5;
                    if (jarak1 <= rmod) && (jarak2 <= rmod) && (jarak3 <= rmod) && (jarak4 <= rmod)
                        Smodel(j,i) = 1/(Sawal*1000);
                    end    
                end
            end
            
            nGrid = 0:1:N;
            [Xplot , Yplot] =  meshgrid(nGrid,nGrid);
            Vplot = 1./(1000*Smodel);
            Vplot(N+1, N+1) = 0;        
            pcolor(app.UIAxes,Xplot,Yplot,Vplot);
            c = colorbar(app.UIAxes);
            colormap(app.UIAxes, flipud(hsv))
            c.Label.String = 'Velocity (m/s)';
            axis(app.UIAxes, 'equal')
        end

        % Value changed function: GridSpinner
        function GridSpinnerValueChanged(app, event)
            
            
        end

        % Button down function: UIAxes
        function UIAxesButtonDown(app, event)
            
        end

        % Value changed function: SaveModelSwitch
        function SaveModelSwitchValueChanged(app, event)
            global Xplot
            global Yplot
            global Vplot
            global Smodel
            %set(0, 'CurrentFigure', app.UIAxes)
            nilai = app.VelocitymsEditField.Value;
            h = figure;
            daspect([1 1 1])
            while ishandle(h)
                h = pcolor(Xplot,Yplot,Vplot); hold on;
                daspect([1 1 1]);
                [x,y] = ginput(1);
                disp(ceil(x));
                disp(ceil(y));
                Smodel(ceil(y),ceil(x)) = 1./(1000*nilai);
                Vplot(ceil(y),ceil(x)) = nilai;
            end
            pcolor(app.UIAxes,Xplot,Yplot,Vplot); hold on;
            c = colorbar(app.UIAxes);
            colormap(app.UIAxes, flipud(hsv))
            c.Label.String = 'Velocity (m/s)';
            axis(app.UIAxes, 'equal')
        end

        % Callback function
        function SaveModelSwitchValueChanged2(app, event)
            
            
        end

        % Value changed function: UnitDropDown_2
        function UnitDropDown_2ValueChanged(app, event)
            
            
        end
        
        % Value changed function: StartReconstructionButton
        function StartReconstructionButtonValueChanged(app, event)
            global N
            global Smodel
            global Xplot
            global Yplot
            global error
            
            b = app.TransducerSpinner.Value;
            iterasi = app.IterationEditField.Value;
            scale = app.GridScaleEditField.Value;
            frekuensi = app.FrequencyHzEditField.Value;
            algoritma = app.AlgorithmButtonGroup.SelectedObject.Text; % MSIRT atau SIRT
            if contains('MSIRT',algoritma)
                [Sinverted, error] = MSIRT_GUI(N,scale,b,Smodel,iterasi,frekuensi);
            else 
                Sinverted = SIRT_GUI(N,scale,b,Smodel,iterasi,frekuensi);
            end
            Vakhir = 1./(1000*Sinverted);
            Vakhir(N+1, N+1) = 0;  
            pcolor(app.UIAxes2,Xplot,Yplot,Vakhir);
            c = colorbar(app.UIAxes2);
            colormap(app.UIAxes2, flipud(hsv))
            c.Label.String = 'Velocity (m/s)';
            axis(app.UIAxes2, 'equal')
            app.VelocityErrorRMSEditField.Value = error;
            %}
        end
        
        % Value changed function: VelocityErrorRMSEditField
        function VelocityErrorRMSEditFieldValueChanged(app, event)
            value = app.VelocityErrorRMSEditField.Value;
        end
        
        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {480, 480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif (currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)
                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else
                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {332, '1x', 417};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1170 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {332, '1x', 417};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;
            
            % Create StartReconstructionButton
            app.StartReconstructionButton = uibutton(app.LeftPanel, 'state');
            app.StartReconstructionButton.ValueChangedFcn = createCallbackFcn(app, @StartReconstructionButtonValueChanged, true);
            app.StartReconstructionButton.BusyAction = 'cancel';
            app.StartReconstructionButton.Interruptible = 'off';
            app.StartReconstructionButton.Text = 'Start Reconstruction';
            app.StartReconstructionButton.Position = [82 12 163 22];

            % Create GridSpinnerLabel
            app.GridSpinnerLabel = uilabel(app.LeftPanel);
            app.GridSpinnerLabel.HorizontalAlignment = 'right';
            app.GridSpinnerLabel.Position = [227 381 28 22];
            app.GridSpinnerLabel.Text = 'Grid';

            % Create GridSpinner
            app.GridSpinner = uispinner(app.LeftPanel);
            app.GridSpinner.Limits = [2 100];
            app.GridSpinner.ValueChangedFcn = createCallbackFcn(app, @GridSpinnerValueChanged, true);
            app.GridSpinner.Position = [261 380 67 24];
            app.GridSpinner.Value = 2;

            % Create GridScaleEditFieldLabel
            app.GridScaleEditFieldLabel = uilabel(app.LeftPanel);
            app.GridScaleEditFieldLabel.HorizontalAlignment = 'right';
            app.GridScaleEditFieldLabel.Position = [114 381 62 22];
            app.GridScaleEditFieldLabel.Text = 'Grid Scale';

            % Create GridScaleEditField
            app.GridScaleEditField = uieditfield(app.LeftPanel, 'numeric');
            app.GridScaleEditField.Limits = [0.1 1000];
            app.GridScaleEditField.ValueChangedFcn = createCallbackFcn(app, @GridScaleEditFieldValueChanged, true);
            app.GridScaleEditField.Position = [183 383 35 19];
            app.GridScaleEditField.Value = 0.1;

            % Create RotateCoreCheckBox
            app.RotateCoreCheckBox = uicheckbox(app.LeftPanel);
            app.RotateCoreCheckBox.ValueChangedFcn = createCallbackFcn(app, @RotateCoreCheckBoxValueChanged, true);
            app.RotateCoreCheckBox.Text = 'Rotate Core';
            app.RotateCoreCheckBox.Position = [234 312 87 22];

            % Create FrequencyHzEditFieldLabel
            app.FrequencyHzEditFieldLabel = uilabel(app.LeftPanel);
            app.FrequencyHzEditFieldLabel.HorizontalAlignment = 'right';
            app.FrequencyHzEditFieldLabel.Position = [4 283 88 22];
            app.FrequencyHzEditFieldLabel.Text = 'Frequency (Hz)';

            % Create FrequencyHzEditField
            app.FrequencyHzEditField = uieditfield(app.LeftPanel, 'numeric');
            app.FrequencyHzEditField.Limits = [1 10000000000];
            app.FrequencyHzEditField.RoundFractionalValues = 'on';
            app.FrequencyHzEditField.ValueDisplayFormat = '%.0f';
            app.FrequencyHzEditField.ValueChangedFcn = createCallbackFcn(app, @FrequencyHzEditFieldValueChanged, true);
            app.FrequencyHzEditField.Position = [98 283 117 22];
            app.FrequencyHzEditField.Value = 1000000;

            % Create UnitDropDown_2Label
            app.UnitDropDown_2Label = uilabel(app.LeftPanel);
            app.UnitDropDown_2Label.HorizontalAlignment = 'right';
            app.UnitDropDown_2Label.Position = [5 381 27 22];
            app.UnitDropDown_2Label.Text = 'Unit';

            % Create UnitDropDown_2
            app.UnitDropDown_2 = uidropdown(app.LeftPanel);
            app.UnitDropDown_2.Items = {'mm', 'm', 'km'};
            app.UnitDropDown_2.ValueChangedFcn = createCallbackFcn(app, @UnitDropDown_2ValueChanged, true);
            app.UnitDropDown_2.Position = [41 381 53 22];
            app.UnitDropDown_2.Value = 'mm';

            % Create ModelBaseDropDownLabel
            app.ModelBaseDropDownLabel = uilabel(app.LeftPanel);
            app.ModelBaseDropDownLabel.HorizontalAlignment = 'right';
            app.ModelBaseDropDownLabel.Enable = 'off';
            app.ModelBaseDropDownLabel.Position = [5 420 69 22];
            app.ModelBaseDropDownLabel.Text = 'Model Base';

            % Create ModelBaseDropDown
            app.ModelBaseDropDown = uidropdown(app.LeftPanel);
            app.ModelBaseDropDown.Items = {'Core'};
            app.ModelBaseDropDown.Enable = 'off';
            app.ModelBaseDropDown.Position = [84 420 64 22];
            app.ModelBaseDropDown.Value = 'Core';

            % Create SettingLabel
            app.SettingLabel = uilabel(app.LeftPanel);
            app.SettingLabel.FontSize = 20;
            app.SettingLabel.FontWeight = 'bold';
            app.SettingLabel.Position = [3 452 73 24];
            app.SettingLabel.Text = 'Setting';

            % Create ForwardModellingLabel
            app.ForwardModellingLabel = uilabel(app.LeftPanel);
            app.ForwardModellingLabel.HorizontalAlignment = 'center';
            app.ForwardModellingLabel.Position = [5 93 57 28];
            app.ForwardModellingLabel.Text = {'Forward'; 'Modelling'};

            % Create ForwardModellingDropDown
            app.ForwardModellingDropDown = uidropdown(app.LeftPanel);
            app.ForwardModellingDropDown.Items = {'Finite Difference Travel Time (Vidale, 1990)', 'Option 2', 'Option 3', 'Option 4'};
            app.ForwardModellingDropDown.Position = [69 96 133 22];
            app.ForwardModellingDropDown.Value = 'Finite Difference Travel Time (Vidale, 1990)';

            % Create TransducerSpinnerLabel
            app.TransducerSpinnerLabel = uilabel(app.LeftPanel);
            app.TransducerSpinnerLabel.HorizontalAlignment = 'right';
            app.TransducerSpinnerLabel.Position = [4 312 66 22];
            app.TransducerSpinnerLabel.Text = 'Transducer';

            % Create TransducerSpinner
            app.TransducerSpinner = uispinner(app.LeftPanel);
            app.TransducerSpinner.ValueChangingFcn = createCallbackFcn(app, @TransducerSpinnerValueChanging, true);
            app.TransducerSpinner.Limits = [2 64];
            app.TransducerSpinner.ValueDisplayFormat = '%.0f';
            app.TransducerSpinner.Position = [98 312 117 22];
            app.TransducerSpinner.Value = 2;

            % Create SaveSettingSwitchLabel
            app.SaveSettingSwitchLabel = uilabel(app.LeftPanel);
            app.SaveSettingSwitchLabel.HorizontalAlignment = 'center';
            app.SaveSettingSwitchLabel.Position = [155 250 74 22];
            app.SaveSettingSwitchLabel.Text = 'Save Setting';

            % Create SaveSettingSwitch
            app.SaveSettingSwitch = uiswitch(app.LeftPanel, 'slider');
            app.SaveSettingSwitch.Items = {'', ''};
            app.SaveSettingSwitch.ValueChangedFcn = createCallbackFcn(app, @SaveSettingSwitchValueChanged, true);
            app.SaveSettingSwitch.Position = [103 250 45 20];
            app.SaveSettingSwitch.Value = '';

            % Create DimensionDropDownLabel
            app.DimensionDropDownLabel = uilabel(app.LeftPanel);
            app.DimensionDropDownLabel.HorizontalAlignment = 'right';
            app.DimensionDropDownLabel.Enable = 'off';
            app.DimensionDropDownLabel.Position = [201 420 62 22];
            app.DimensionDropDownLabel.Text = 'Dimension';

            % Create DimensionDropDown
            app.DimensionDropDown = uidropdown(app.LeftPanel);
            app.DimensionDropDown.Items = {'2D', '3D'};
            app.DimensionDropDown.Enable = 'off';
            app.DimensionDropDown.Position = [278 420 48 22];
            app.DimensionDropDown.Value = '2D';

            % Create GridHeightSpinnerLabel
            app.GridHeightSpinnerLabel = uilabel(app.LeftPanel);
            app.GridHeightSpinnerLabel.HorizontalAlignment = 'right';
            app.GridHeightSpinnerLabel.Enable = 'off';
            app.GridHeightSpinnerLabel.Position = [189 350 66 22];
            app.GridHeightSpinnerLabel.Text = 'Grid Height';

            % Create GridHeightSpinner
            app.GridHeightSpinner = uispinner(app.LeftPanel);
            app.GridHeightSpinner.Limits = [2 200];
            app.GridHeightSpinner.Editable = 'off';
            app.GridHeightSpinner.Enable = 'off';
            app.GridHeightSpinner.Position = [261 349 67 24];
            app.GridHeightSpinner.Value = 2;

            % Create VelocitymsEditFieldLabel
            app.VelocitymsEditFieldLabel = uilabel(app.LeftPanel);
            app.VelocitymsEditFieldLabel.HorizontalAlignment = 'right';
            app.VelocitymsEditFieldLabel.Enable = 'off';
            app.VelocitymsEditFieldLabel.Position = [5 174 78 22];
            app.VelocitymsEditFieldLabel.Text = 'Velocity (m/s)';

            % Create VelocitymsEditField
            app.VelocitymsEditField = uieditfield(app.LeftPanel, 'numeric');
            app.VelocitymsEditField.Limits = [1 100000];
            app.VelocitymsEditField.Position = [92 174 73 22];
            app.VelocitymsEditField.Value = 1;

            % Create SaveModelSwitchLabel
            app.SaveModelSwitchLabel = uilabel(app.LeftPanel);
            app.SaveModelSwitchLabel.HorizontalAlignment = 'center';
            app.SaveModelSwitchLabel.Position = [238 174 69 22];
            app.SaveModelSwitchLabel.Text = 'Save Model';

            % Create SaveModelSwitch
            app.SaveModelSwitch = uiswitch(app.LeftPanel, 'slider');
            app.SaveModelSwitch.Items = {'', ''};
            app.SaveModelSwitch.ValueChangedFcn = createCallbackFcn(app, @SaveModelSwitchValueChanged, true);
            app.SaveModelSwitch.Position = [183 174 45 20];
            app.SaveModelSwitch.Value = '';

            % Create DrawModelLabel
            app.DrawModelLabel = uilabel(app.LeftPanel);
            app.DrawModelLabel.FontSize = 20;
            app.DrawModelLabel.FontWeight = 'bold';
            app.DrawModelLabel.Position = [3 201 118 24];
            app.DrawModelLabel.Text = 'Draw Model';

            % Create noteyoucandrawmodelinteractivelyfromgraphicLabel
            app.noteyoucandrawmodelinteractivelyfromgraphicLabel = uilabel(app.LeftPanel);
            app.noteyoucandrawmodelinteractivelyfromgraphicLabel.FontColor = [1 0 0];
            app.noteyoucandrawmodelinteractivelyfromgraphicLabel.Position = [23 145 286 22];
            app.noteyoucandrawmodelinteractivelyfromgraphicLabel.Text = 'note : you can draw model interactively from graphic';

            % Create AlgorithmButtonGroup
            app.AlgorithmButtonGroup = uibuttongroup(app.LeftPanel);
            app.AlgorithmButtonGroup.Title = 'Algorithm';
            app.AlgorithmButtonGroup.Position = [221 46 100 75];

            % Create MSIRTButton
            app.MSIRTButton = uiradiobutton(app.AlgorithmButtonGroup);
            app.MSIRTButton.Text = 'MSIRT';
            app.MSIRTButton.Position = [11 29 59 22];
            app.MSIRTButton.Value = true;

            % Create SIRTButton
            app.SIRTButton = uiradiobutton(app.AlgorithmButtonGroup);
            app.SIRTButton.Text = 'SIRT';
            app.SIRTButton.Position = [11 7 65 22];

            % Create IterationEditFieldLabel
            app.IterationEditFieldLabel = uilabel(app.LeftPanel);
            app.IterationEditFieldLabel.HorizontalAlignment = 'right';
            app.IterationEditFieldLabel.Position = [12 54 49 22];
            app.IterationEditFieldLabel.Text = 'Iteration';

            % Create IterationEditField
            app.IterationEditField = uieditfield(app.LeftPanel, 'numeric');
            app.IterationEditField.Limits = [1 1000];
            app.IterationEditField.RoundFractionalValues = 'on';
            app.IterationEditField.ValueDisplayFormat = '%.0f';
            app.IterationEditField.ValueChangedFcn = createCallbackFcn(app, @IterationEditFieldValueChanged, true);
            app.IterationEditField.Position = [76 54 126 22];
            app.IterationEditField.Value = 1;

            % Create CenterPanel
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.ButtonDownFcn = createCallbackFcn(app, @CenterPanelButtonDown, true);
            app.CenterPanel.Layout.Row = 1;
            app.CenterPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.CenterPanel);
            title(app.UIAxes, 'First Model')
            xlabel(app.UIAxes, 'X (grid)')
            ylabel(app.UIAxes, 'Y (grid)')
            zlabel(app.UIAxes, 'Z (grid)')
            app.UIAxes.CameraPosition = [0.5 0.5 0];
            app.UIAxes.View = [0 -90];
            app.UIAxes.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
            app.UIAxes.Position = [10 119 399 357];

            % Create SaveFigureButton_2
            app.SaveFigureButton_2 = uibutton(app.CenterPanel, 'state');
            app.SaveFigureButton_2.Text = 'Save Figure';
            app.SaveFigureButton_2.Position = [160 12 100 22];

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.CenterPanel);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.Position = [38 75 56 22];
            app.EditFieldLabel.Text = 'Edit Field';

            % Create EditField
            app.EditField = uieditfield(app.CenterPanel, 'text');
            app.EditField.Position = [109 75 100 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 3;

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.RightPanel);
            title(app.UIAxes2, 'Reconstruction Tomogram')
            xlabel(app.UIAxes2, 'X (grid)')
            ylabel(app.UIAxes2, 'Y (grid)')
            zlabel(app.UIAxes2, 'Z (grid)')
            app.UIAxes2.Position = [4 119 407 357];

            % Create SaveFigureButton
            app.SaveFigureButton = uibutton(app.RightPanel, 'state');
            app.SaveFigureButton.Text = 'Save Figure';
            app.SaveFigureButton.Position = [243 12 100 22];

            % Create VelocityErrorRMSLabel
            app.VelocityErrorRMSLabel = uilabel(app.RightPanel);
            app.VelocityErrorRMSLabel.HorizontalAlignment = 'right';
            app.VelocityErrorRMSLabel.Position = [12 46 129 22];
            app.VelocityErrorRMSLabel.Text = 'Velocity Error RMS (%)';

            % Create VelocityErrorRMSEditField
            app.VelocityErrorRMSEditField = uieditfield(app.RightPanel, 'numeric');
            app.VelocityErrorRMSEditField.Editable = 'off';
            app.VelocityErrorRMSEditField.Position = [153 46 44 22];

            % Create TimeErrorRMSEditFieldLabel
            app.TimeErrorRMSEditFieldLabel = uilabel(app.RightPanel);
            app.TimeErrorRMSEditFieldLabel.HorizontalAlignment = 'right';
            app.TimeErrorRMSEditFieldLabel.Position = [27 16 114 22];
            app.TimeErrorRMSEditFieldLabel.Text = 'Time Error RMS (%)';

            % Create TimeErrorRMSEditField
            app.TimeErrorRMSEditField = uieditfield(app.RightPanel, 'numeric');
            app.TimeErrorRMSEditField.Editable = 'off';
            app.TimeErrorRMSEditField.Position = [153 16 44 22];

            % Create ShowErrorGraphicSwitchLabel
            app.ShowErrorGraphicSwitchLabel = uilabel(app.RightPanel);
            app.ShowErrorGraphicSwitchLabel.HorizontalAlignment = 'center';
            app.ShowErrorGraphicSwitchLabel.Position = [264 43 111 22];
            app.ShowErrorGraphicSwitchLabel.Text = 'Show Error Graphic';

            % Create ShowErrorGraphicSwitch
            app.ShowErrorGraphicSwitch = uiswitch(app.RightPanel, 'slider');
            app.ShowErrorGraphicSwitch.Items = {'', ''};
            app.ShowErrorGraphicSwitch.Position = [210 44 45 20];
            app.ShowErrorGraphicSwitch.Value = '';

            % Create Toolbar
            app.Toolbar = uitoolbar(app.UIFigure);

            % Create PushTool
            app.PushTool = uipushtool(app.Toolbar);

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI_FresnelVolumeTomografi

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end