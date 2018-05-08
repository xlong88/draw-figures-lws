clear all
close all
clc
addpath('./drawlab');
datajsonfile = '../results_final/Mean-Delay-vs-ports/06/Mean-Delay_Serenades_md_vs_port.json';
confjsonfile = '../results_final/Mean-Delay-vs-ports/06/Mean_Delay_Serenade_md_vs_port_conf.json';
draw_subplots_onerow_3(datajsonfile, confjsonfile)