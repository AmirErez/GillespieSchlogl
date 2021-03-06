#!/usr/bin/env python
#! Produce input script for simulating producer-consumer pairs
import pandas as pd
import numpy as np
from collections import defaultdict
import os
outdir = 'scan_thetax_thetay_h0_nc3000-schlogl';
os.makedirs(outdir, exist_ok=True)
outfile=os.path.join(outdir,'scan.txt')

ret = defaultdict(lambda: [])

# log10theta = np.linspace(-6, 0, 61);
# thetas = np.power(10, log10theta)
# thetas = np.linspace(-0.3, 0.3, 21)
thetaxs = np.linspace(-0.3, 0.3, 61)
thetays = np.linspace(-0.3, 0.3, 61)
h = 0

for thetay in thetays:
   for thetax in thetaxs:
       ret['theta_x'].append(thetax)
       ret['theta_y'].append(thetay)
       ret['hx'].append(h)
       ret['hy'].append(h)

df = pd.DataFrame(ret)
df['log10nc_x'] = 3.4771
df['log10nc_y'] = 3.4771

df = df[['theta_x', 'theta_y', 'hx', 'hy', 'log10nc_x', 'log10nc_y']]
df.to_csv(outfile, sep=',', header=None, index=None, float_format='%g')
print('Finished successfully writing to {}'.format(outfile))
