#!/bin/python
# -*- coding: utf-8 -*-

import os
import os.path
import pandas as pd
import json



# directory_rel = "./results/delay-vs-loads"
# directory_rel = "./results/delay-vs-burst-size"
directory_rel = "./results_copy/delay-vs-ports"
# metric = 'Mean-Delay'
metric = 'Mean-Delay'
throughput_thresh = 0.9999
xname = "Port_Number"
# xname = "Delay"
# xname = "#Load"
# xname = "Burst-Size"
# ofn = metric + '_iSLIP-like_vs_port_number.json'
# ofn = metric + '_FQPS_iSLIP_vs_load.json'

# ofn = metric + '_md_vs_pipeline_delay.json'

# ofn = metric + '_Serenades_md_vs_load.json'
# ofn = metric + '_Serenades_md_vs_burst_size.json'

ofn = metric + '_Serenades_md_vs_port.json'

directory = os.path.abspath(directory_rel)

traffic_models = ['uniform', 'logdiagonal', 'quasidiagonal', 'diagonal']
data = {}
for tm in traffic_models:
    data[tm] = {}
fileLists = os.listdir(directory)

fileLists_o = sorted(fileLists, key=lambda x: int(x.split('-')[1]))

for f in fileLists_o:
    if not (f.endswith('.dat')):
        continue
    print "Processing file ", f
    fn = os.path.join(directory, f)
    df = pd.read_csv(fn, delim_whitespace=True)
    try:
        alg = f.split('-')[0]
        pn = int(f.split('-')[1])
    except IndexError as e:
        print "Error %s" % str(e)
        continue
    for id, tm in enumerate(traffic_models):
        dff = df[df['Traffic-Mode'] == id]
        if not data[tm].has_key(alg):
            data[tm][alg] = [[], []]
        # assert (len(data[tm][alg]) == 0)
        if (len(dff[metric]) > 0):
            data[tm][alg][0].append(pn)
            data[tm][alg][1].append(dff[metric].iloc[0])
        # throughput = dff['Throughput'].values.tolist()
        # for i in xrange(0, len(throughput)):
        #     if throughput[i] < throughput_thresh:
        #         del data[tm][alg][0][0]
        #         del data[tm][alg][1][0]
        #     else:
        #         break
        #
        if (len(data[tm][alg][0]) == 0):
            del data[tm][alg]

with open(ofn, 'w') as jsonf:
    json.dump(data, jsonf, indent=4)
