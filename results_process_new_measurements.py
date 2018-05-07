#!/bin/python
# -*- coding: utf-8 -*-

import os
import os.path
import pandas as pd
import json



def get_all_ouroboros(df, flag):
    # ts-ao-woE     ts-all-woE
    # ts-nonouro-E  ts-all-E
    if flag.upper() == 'E':
        return (df["ts-all-E"].iloc[0] - df["ts-nonouro-E"].iloc[0]) * 1.0 / df["ts-all-E"].iloc[0]
    else:
        return df["ts-ao-woE"].iloc[0] * 1.0 / df["ts-all-woE"]

def get_broadcast_size(df, flag):
    # noncyc-woE ts-all-woE ts-ao-woE
    if flag.upper() == 'O':
        return (df["noncyc-woE"].iloc[0]) * 1.0 / (df["ts-all-woE"].iloc[0] - df["ts-ao-woE"].iloc[0])
    elif flag.upper() == 'E':
        return (df["noncyc-W"].iloc[0] * 1.0) / df["ts-nonouro-E"].iloc[0]
    else:
        return 0

def get_bsit(df, flag):
    # bsit-mp-E
        return (df["bsit-mp-E"].iloc[0] * 1.0) / df["ts-nonouro-E"].iloc[0]


new_measurements = {
    "prob-all-ouroboros": get_all_ouroboros,
    "broadcast-size": get_broadcast_size,
    "BSIT": get_bsit
}

directory_rel = "./results_copy/new-measurements-revised"


ofn = 'Serenades_new_measurements.json'

directory = os.path.abspath(directory_rel)

traffic_models = ['uniform', 'logdiagonal', 'quasidiagonal', 'diagonal']
data = {}
for tm in traffic_models:
    data[tm] = {}
fileLists = os.listdir(directory)


for f in fileLists:
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

        for measure, func in new_measurements.iteritems():
            data[tm][alg][0].append(measure)
            if alg.startswith('S'):               
                value = func(dff, 'O')
            else:
                value = func(dff, alg[0])
            data[tm][alg][1].append(round(value, 3))



with open(ofn, 'w') as jsonf:
    json.dump(data, jsonf, indent=4)

p = {
    "axis_order": [
                    "uniform",
                    "quasidiagonal",
                    "logdiagonal",
                    "diagonal"
                  ],
    "title": [
        "Uniform",
        "Quasi-diagonal",
        "Log-diagonal",
        "Diagonal"
    ],
    "algorithm_order": [
          "C_Serenade_for_Proof",
          "SO_Serenade",
          "E_Serenade"
               ],
}

measurements_order = {
                "prob-all-ouroboros": 0, 
                "BSIT": 1, 
                "broadcast-size": 2
}

for m in ["prob-all-ouroboros", "broadcast-size", "BSIT"]:
    i = measurements_order[m]
    for a in p["algorithm_order"]:
        print "{:>20}: ".format(a),
        for t in p["axis_order"]:
            print "& ${0}$ ".format(data[t][a][1][i]),
        print "\n",


