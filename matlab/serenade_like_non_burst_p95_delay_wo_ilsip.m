addpath('./drawlab');
datajsonfile = '../results_final/P95-Delay-vs-loads/P95-Delay_Serenades_md_vs_load.json';
confjsonfile = '../results_final/P95-Delay-vs-loads/P95-Delay_Serenades_md_vs_load_conf.json';
draw_subplots_onerow_3(datajsonfile, confjsonfile)