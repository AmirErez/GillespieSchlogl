#!/usr/bin/env python
#! Produce input script for simulating producer-consumer pairs
import pandas as pd
import numpy as np
from collections import defaultdict
import os
outdir = 'randparams0_1-nc_3000-schlogl';
os.makedirs(outdir, exist_ok=True)
outfile=os.path.join(outdir,'scan.txt')

outfile = 'scan.txt'
ntrials = 10000
ret = defaultdict(lambda: [])
hrange = 0.1
thetarange = 0.1

df = pd.DataFrame()
df['h_x'] = 2*(np.random.random(ntrials) - 0.5)*hrange
df['h_y'] = 2*(np.random.random(ntrials) - 0.5)*hrange
df['theta_x'] = 2*(np.random.random(ntrials) - 0.5)*thetarange
df['theta_y'] = 2*(np.random.random(ntrials) - 0.5)*thetarange

df['log10nc_x'] = 3.4771
df['log10nc_y'] = 3.4771

# df = df.sort_values(['theta_x', 'theta_y', 'h_x', 'h_y'])
df = df[['theta_x', 'theta_y', 'h_x', 'h_y', 'log10nc_x', 'log10nc_y']]

df.to_csv(outdir+'/'+outfile, sep=',', header=None, index=None, float_format='%g')
print('Finished successfully writing to {}'.format(outfile))
