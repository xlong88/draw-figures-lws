function draw_subplots_onerow_3(datajsonfile, confjsonfile)

fullpath = mfilename('fullpath');
[folder, ~, ~] = fileparts(fullpath);
[parent, ~, ~] = fileparts(folder);
% add dependen files
addpath([parent, '/colorlab']);
addpath([parent, '/colorlab/colorspace']);
func = @(x) colorspace('RGB->Lab',x);
addpath([parent, '/jsonlab']);

% load configuration file
conf = loadjson(confjsonfile);
data = loadjson(datajsonfile);
% parse confurations
if isfield(conf, 'LineWidth')
    lw = conf.LineWidth;
else
    lw = 2;
end

if isfield(conf, 'MarkerSize')
    ms = conf.MarkerSize;
else
    ms = 8;
end

if isfield(conf, 'FontSize')
    fs = conf.FontSize;
else
    fs = 18;
end

afs = 16;

axes_order = conf.axis_order;
axes_title = conf.title;
algorithm_order = conf.algorithm_order;
algorithm_displayname = conf.DisplayName;
label_x = conf.xlabel;
label_y = conf.ylabel;
figureName = conf.figureName;


xlim_ = {};
ylim_ = {};



if isfield(conf, 'xtick')
    tick_x = conf.xtick;
end

if isfield(conf, 'ytick')
    tick_y = conf.ytick;
end

if isfield(conf, 'xlim')
    xlim_tmp = conf.xlim;
    if size(xlim_tmp, 1) > 1
        xlim_ = {};
        for i = 1:size(xlim_tmp,1)
            xlim_ = [xlim_, xlim_tmp(i,:)];
        end
    else
        xlim_ = xlim_tmp;
    end
end
% tp_constant = 0.7;

if isfield(conf, 'plotType')
    plotType = conf.plotType;
else
    plotType = 'plot';
end


if isfield(conf, 'ylim')
    ylim_tmp = conf.ylim;
    
    if size(ylim_tmp, 1) > 1
        ylim_ = {};
        for i = 1:size(ylim_tmp,1)
            ylim_ = [ylim_, ylim_tmp(i,:)];
        end
    else
        ylim_ = ylim_tmp;
    end
            
end


% generate six different colors
if isfield(conf, 'ColorNumber')
    cn = conf.ColorNumber;
else
    cn = 6;
end
% color_pool = distinguishable_colors(cn, 'w', func);
color_pool = load('colorTable.txt');
marker_pool = different_markers(cn);

if isfield(conf, 'Color')
    colors = conf.Color;
else
    colors = 1:cn;
end

if isfield(conf, 'Marker')
    markers = conf.Marker;
else
    markers = 1:cn;
end



X = {};
Ys = {};

legend_ = {};
markers_ = {};
colors_ = {};

for k = 1:length(algorithm_order)
    legend_ = [legend_, algorithm_displayname{k}];
    markers_ = [markers_, marker_pool(markers(k))];
    colors_ = [colors_, color_pool(colors(k),:)];
end

plotProp = {'Marker', markers_, 'LineWidth', lw,'MarkerSize', ms, 'Color', colors_};

diffProp = {};

x_ticks_ = {};
x_tick_labels_ = {};
y_ticks_ = {};
y_tick_labels_ = {};
for i = 1:4
    fid = axes_order{i};
    
    algs = fieldnames(data.(fid));

    tmp_x = {};
    tmp_y = {};
    for id = 1:length(algorithm_order)
        alg = algorithm_order{id};
        tmp_x = [tmp_x, data.(fid).(alg)(1, :)]; % x
        tmp_y = [tmp_y, data.(fid).(alg)(2, :)]; % y
    end
    
    X = [X; tmp_x];
    Ys = [Ys; tmp_y];
    
    
    if exist('tick_x', 'var') ~= 0
        x_ticks_ = [x_ticks_; tick_x{1, i}.value];
        x_tick_labels_ = [x_tick_labels_; {tick_x{1, i}.label}];
    end
      
    if exist('tick_y', 'var') ~= 0
        y_ticks_ = [y_ticks_; tick_y{1, i}.value];
        y_tick_labels_ = [y_tick_labels_; {tick_y{1, i}.label}];
    end
    
    
    
end


if ~isempty(x_ticks_)
    diffProp = [diffProp, 'XTick', {x_ticks_}, 'XTickLabel', {x_tick_labels_}];
end

if ~isempty(y_ticks_)
    diffProp = [diffProp, 'YTick', {y_ticks_}, 'YTickLabel', {y_tick_labels_}];
end

if conf.legend_latex == 1
    legend_int = 'latex';
else
    legend_int = 'tex';
end

rowPlot(X,Ys,'heter',...
    'FigureName',figureName,...
    'XLabelFontSize', fs,...
    'YLabelFontSize', fs,...
    'TitleFontSize', fs,...
    'LegendFontSize', fs,...
    'AxesFontSize', afs,...
    'title',axes_title,...
    'xlim', xlim_,...
    'ylim', ylim_,...
    'xlabel', label_x,...
    'ylabel', label_y,...
    'legend', {legend_, 'Interpreter', legend_int},...
    'diffproperties', diffProp,...
    'plotType', plotType,...
    'PlotProperties',plotProp);

end
