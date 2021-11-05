import csv
import os
import sys
import time
from collections import defaultdict


def pluralize(n, w):
    if n == 1:
        return '%s %s' % (n, w)
    else:
        return '%s %ss' % (n, w)

def usage():
    print("usage: python make_tests.py <template_directory> <test_directory>")


########## Main ##############
if len(sys.argv) < 3:
    usage()
    sys.exit(1)

TEMPLATE_DIR = sys.argv[1]
TEST_DIR = sys.argv[2]

files = []
main_dict = {'profile': defaultdict(int), 'version': defaultdict(int), 'record_type': defaultdict(int)}

for filename in os.listdir(TEMPLATE_DIR):
    if not '-template.csv' in filename: continue
    try:
        triplet = filename.replace('.csv','')
        (profile, version, record_type) = triplet.split('_')
        main_dict['profile'][profile] += 1
        main_dict['version'][version] += 1
        main_dict['record_type'][record_type] += 1
    except:
        # skip .csv files that don't match the pattern
        continue

    tests = {}
    with open(os.path.join(TEST_DIR, filename.replace('-template','-test')), 'w') as output_csv_file:
        outputfh = csv.writer(output_csv_file,  delimiter=",")
        with open(os.path.join(TEMPLATE_DIR, filename), 'r') as input_csv_file:
            inputfh = csv.reader(input_csv_file,  delimiter=",")

            properties = {}
            for row in inputfh:
                if 'Before importing' in row[0]: continue
                properties[row[0]] = row[1:]

            v = []
            for i, t in enumerate(properties['CSVHEADER']):
                if properties['DATA TYPE'][i] == 'date':
                    date_to_use = time.strftime("%B %d, %Y", time.localtime())
                    v.append(date_to_use)
                elif properties['VALUE SOURCE TYPE'][i] == 'optionlist':
                    v.append(properties['VALUE SOURCE'][i].split(',')[0])
                elif properties['VALUE SOURCE TYPE'][i] == 'authority':
                    v.append(properties['CSVHEADER'][i])
                elif properties['DATA TYPE'][i] == 'string':
                    v.append(properties['CSVHEADER'][i] + '_data')
                else:
                    v.append('')
            tests[filename] = properties
            outputfh.writerow(properties['CSVHEADER'])
            outputfh.writerow(v)

for p in sorted(main_dict['profile']):
    for r in sorted(main_dict['record_type']):
        print(f'{p} {r}')
