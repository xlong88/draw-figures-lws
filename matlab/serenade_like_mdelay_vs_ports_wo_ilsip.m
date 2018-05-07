addpath('./drawlab');
datajsonfile = '../results_final/Mean-Delay-vs-ports/Mean-Delay_Serenades_md_vs_port.json';
confjsonfile = '../results_final/Mean-Delay-vs-ports/Mean-Delay_Serenades_md_vs_port_conf.json';
draw_subplots_onerow_3(datajsonfile, confjsonfile)