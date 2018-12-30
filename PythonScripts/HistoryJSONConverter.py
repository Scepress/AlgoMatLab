# -*- coding: utf-8 -*-
"""
Created on Thu Nov 15 17:34:16 2018

@author: Owner
"""

import json
import csv

infile=open('Binance_XRPBTC_30m_1538352000000-1541030400000.json',"r")
outfile=open('Binance_XRPBTC_30m_1538352000000-1541030400000.csv',"w")

writer = csv.writer(outfile)

for row in json.loads(infile.read()):
    writer.writerow(row)
    
close(outfile)