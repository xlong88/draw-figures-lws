function draw_subplots_onerow(datajsonfile, confjsonfile)

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


axes_order = conf.axis_order;
axes_title = conf.title;
algorithm_order = conf.algorithm_order;
algorithm_displayname = conf.DisplayName;
label_x = conf.xlabel;
label_y = conf.ylabel;


if isfield(conf, 'xtick')
    tick_x_temp = conf.xtick;
    
    if size(tick_x_temp, 1) == 1
        tick_x = repmat(tick_x_temp, length(axes_order), 1);
    else
        tick_x = tick_x_temp;
    end
end

if isfield(conf, 'ytick')
    tick_y_temp = conf.ytick;
    if size(tick_y_temp, 1) == 1
        tick_y = repmat(tick_y_temp, length(axes_order), 1);
    else
        tick_y = tick_y_temp;
    end
end

if isfield(conf, 'xlim')
    lim_x_temp = conf.xlim;
    if size(lim_x_temp, 1) == 1
        lim_x = repmat(lim_x_temp, length(axes_order), 1);
    else
        lim_x = lim_x_temp;
    end
end

if isfield(conf, 'ylim')
    lim_y_temp = conf.ylim;
    if size(lim_y_temp, 1) == 1
        lim_y = repmat(lim_y_temp, length(axes_order), 1);
    else
        lim_y = lim_y_temp;
    end
end


% generate six different colors
if isfield(conf, 'ColorNumber')
    cn = conf.ColorNumber;
else
    cn = 6;
end
color_pool = distinguishable_colors(cn, 'w', func);
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

% positions
axpos = {[0.0842890809112336 0.2 0.18 0.65];
         [0.314289080911234 0.2 0.18 0.65];
         [0.544289080911235 0.2 0.18 0.65];
         [0.774289080911235 0.2 0.18 0.65]};


for i = 1:4
    fid = axes_order{i};  

    fig.(fid) = subplot(1, 4, i, 'Position', axpos{i});

    algs = fieldnames(data.(fid));
    XYs = {};
    
    for id = 1:length(algorithm_order)
        alg = algorithm_order{id};
        XYs = [XYs, data.(fid).(alg)(1, :)]; % x
        XYs = [XYs, data.(fid).(alg)(2, :)]; % y
    end

    if isfield(conf, 'plotType')
        switch conf.plotType
            case 'plot'
                lines.(fid) = plot(XYs{1:end});
            case 'logy'
                lines.(fid) = semilogy(XYs{1:end});
            case 'logx'
                lines.(fid) = semilogx(XYs{1:end});
            case 'loglog'
                lines.(fid) = loglog(XYs{1:end});
        end
    else
        lines.(fid) = plot(XYs{1:end});
    end
        

    for k = 1:length(algorithm_order)
        set(lines.(fid)(k),'DisplayName', algorithm_displayname{k}, 'Marker', marker_pool(markers(k)),...
                    'LineWidth', lw,'MarkerSize', ms,'Color', color_pool(colors(k), :));
    end
    

    set(fig.(fid), 'FontSize', fs);

    xlabel(fig.(fid), label_x);
    title(fig.(fid), axes_title{i});
     
    if exist('lim_x', 'var') ~= 0
        xlim(fig.(fid), lim_x(i, :));
    end
    
    if exist('lim_y', 'var') ~= 0
        disp(lim_y(i, :));
        ylim(fig.(fid), lim_y(i, :));
    end  
    
    if exist('tick_x', 'var') ~= 0
        set(fig.(fid), 'XTick', tick_x(i, :));
    end
    
    if exist('tick_y', 'var') ~= 0
        set(fig.(fid), 'YTick', tick_y(i, :));
    end
    
    grid(fig.(fid),'on');
    if isfield(conf, 'plotType')
        switch conf.plotType
            case 'logx'
                fig.(fid).XMinorGrid = 'on';
            case 'logy'
                disp('turn on minor')
                fig.(fid).YMinorGrid = 'on';
            case 'loglog'
                grid(fig.(fid), 'minor');
        end
    end
    
    if i == 1
        ylabel(fig.(fid),label_y);
    end
    
    pos.(fid) = get(fig.(fid),'Position');
end

% Create legend

legend1 = legend(fig.(axes_order{1}),'show');


if conf.legend_latex == 1
    set(legend1,...
        'Position',[0.372087483854501 0.893087845367162 0.260015710919089 0.0555555555555556],...
        'Orientation','horizontal',...
        'Interpreter','latex',...
        'EdgeColor',[1 1 1]);
else
    set(legend1,...
            'Position',[0.372087483854501 0.893087845367162 0.260015710919089 0.0555555555555556],...
            'Orientation','horizontal',...
            'EdgeColor',[1 1 1]);
end
end
