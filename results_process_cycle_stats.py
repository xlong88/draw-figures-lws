#!/bin/python
# -*- coding: utf-8 -*-

import os
import os.path
import pandas as pd
import numpy as np
import json



directory_rel = "./results/cycle-stats"
# metric = 'Mean-Delay'
# metric = 'P95-Delay'
# throughput_thresh = 0.9999
# xname = "Port_Number"
# xname = "Delay"
# xname = "#Load"
# ofn = metric + '_iSLIP-like_vs_port_number.json'
# ofn = metric + '_FQPS_iSLIP_vs_load.json'

# ofn = metric + '_md_vs_pipeline_delay.json'

cycle_size_template = "CS-{size}"
N = 64
selected_load = 0.95

css = [cycle_size_template.format(size=i) for i in xrange(1,N+1)]

ofn = 'Serenades_cycle_stats.json'

directory = os.path.abspath(directory_rel)

traffic_models = ['uniform', 'logdiagonal', 'quasidiagonal', 'diagonal']
data = {}
for tm in traffic_models:
    data[tm] = {}
fileLists = os.listdir(directory)

for f in fileLists:
    fn = os.path.join(directory, f)
    df = pd.read_csv(fn, delim_whitespace=True)
    try:
        alg = f.split('-')[0]

    except IndexError as e:
        print "Error %s" % str(e)
        continue
    for id, tm in enumerate(traffic_models):
        dff = df[df['Traffic-Mode'] == id]
        dfff = dff[dff['#Load'] == selected_load]
        if not data[tm].has_key(alg):
            data[tm][alg] = []
        assert (len(data[tm][alg]) == 0)
        data[tm][alg].append(range(1,N+1))
        tmp = dfff[css].values.flatten().tolist()
        data[tm][alg].append((np.cumsum(tmp) / (1.0 * np.sum(tmp))).tolist())
        # throughput = dff['Throughput'].values.tolist()
        # for i in xrange(0, len(throughput)):
        #     if throughput[i] < throughput_thresh:
        #         del data[tm][alg][0][0]
        #         del data[tm][alg][1][0]
        #     else:
        #         break
alg = "URP"
for id, tm in enumerate(traffic_models):
    ar = range(1,N+1)
    if not data[tm].has_key(alg):
        data[tm][alg] = []
    data[tm][alg].append(ar)
    pdf = [1.0 / N] * N
    data[tm][alg].append(np.cumsum(pdf).tolist())

with open(ofn, 'w') as jsonf:
    json.dump(data, jsonf, indent=4)