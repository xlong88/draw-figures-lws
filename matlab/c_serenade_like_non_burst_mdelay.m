addpath('./drawlab');
datajsonfile = '../results_final/Mean-Delay-vs-loads/Mean-Delay_Serenades_md_vs_load.json';
confjsonfile = '../results_final/Mean-Delay-vs-loads/Mean-Delay_Serenades_md_vs_load_c_conf.json';
draw_subplots_onerow_3(datajsonfile, confjsonfile)