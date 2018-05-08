clear all
close all
clc
addpath('./drawlab');
datajsonfile = '../results_final/Mean-Delay-vs-bs/06/Mean-Delay_Serenades_md_vs_burst_size.json';
confjsonfile = '../results_final/Mean-Delay-vs-bs/06/Mean-Delay_Serenades_md_vs_burst_size_conf.json';
draw_subplots_onerow_3(datajsonfile, confjsonfile)