#!/bin/python
# -*- coding: utf-8 -*-
import os
import os.path
import random

class ReadAndSummarizeResults(object):

    def __init__(self, verbose=False):
        self.folder_pairs = []
        self.verbose = verbose

    def process_results_in_folder(self, src_folder, dst_folder):
        self.folder_pairs.append((src_folder, dst_folder))
        for src in os.listdir(src_folder):
            if src.endswith('txt'):
                if self.verbose:
                    print("src : ", src)
                self.process_result(os.path.join(src_folder, src).replace("\\", '/'))

    def process_result(self, src):
        name_parts = os.path.splitext(os.path.basename(src))[0].split('-')
        alg = "_".join(name_parts[0].split("_")[:-1])
        m = 0
        l = 0
        p = 0
        for part in name_parts:
            if part.startswith('l'):
                l = part[1:]
            elif part.startswith('m'):
                m = int(part[1:])
            elif part.startswith('p'):
                p = int(part[1:])

        if self.verbose:
            print ("algorithm : ", alg)

        dst_folder = self.folder_pairs[-1][-1]

        # Step 1: get destination filename
        dst_filename = os.path.join(dst_folder,
                                    '{alg}-{p}-{m}-{r}.dat'.format(
                                        alg=alg,
                                        p=p,
                                        m=m,
                                        r=random.randint(1, int(1e8))
                                    )).replace("\\", '/')
        with open(src) as sf:
            # Step 1: get destination filename
            # for line in sf:
            #     if line.find("Ouroboros_stats_filename") != -1:
            #         line = line.strip()
            #         fn = line.split(':')[-1]
            #         fn = fn.strip('",').split('/')[-1]
            #         dst_filename = os.path.join(dst_folder, fn.replace('Simulator', alg)).replace("\\", '/')
            #         break
            if self.verbose:
                print("destination filename : ", dst_filename)
            if dst_filename is not None:
                with open(dst_filename, "w") as df:
                    # Step 2: read header
                    for line in sf:
                        if line.startswith('#Load'):
                            df.write(line)
                            if self.verbose:
                                print(line)
                            break
                    pre_line = ""
                    cnt = 0
                    # Step 3: read data
                    for line in sf:
                        if line.startswith(l):
                            pre_line = line
                        else:
                            if not len(pre_line) == 0:
                                df.write(pre_line)
                                if self.verbose:
                                    print (pre_line)
                                cnt = cnt + 1
                                if cnt == 4:
                                    break
                            pre_line = ""


if __name__ == "__main__":
    rasr = ReadAndSummarizeResults(verbose=True)
    # rasr.process_results_in_folder('06', '06-preprocessed')
    rasr.process_results_in_folder('07', '07-preprocessed')
    rasr.process_results_in_folder('08', '08-preprocessed')
