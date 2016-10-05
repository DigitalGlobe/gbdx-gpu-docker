import os
import json
import logging as log
import subprocess

PORTSFILE = '/mnt/work/input/ports.json'
STATUSFILE = '/mnt/work/status.json'
INPUTDIR = '/mnt/work/input'
OUTPUTDIR = '/mnt/work/output'

DEFAULT_LOGGING_DIR = OUTPUTDIR+'/log'
DEFAULT_OUTPUT_DIR = OUTPUTDIR+'/log'

# set up logging
if not os.path.exists(DEFAULT_LOGGING_DIR):
    os.makedirs(DEFAULT_LOGGING_DIR)
log.getLogger().addHandler( log.FileHandler(DEFAULT_LOGGING_DIR+'/app.log') )
#log.getLogger().addHandler( log.StreamHandler() )
log.getLogger().setLevel( log.WARNING )
# set up output dir
if not os.path.exists(DEFAULT_OUTPUT_DIR):
    os.makedirs(DEFAULT_OUTPUT_DIR)

def create_status_file(status, message):
    content = { 'status': status,
                'reason': message }
    with open(STATUSFILE, 'w') as f:
        f.write( json.dumps(content) )

def parse_ports_file(ports_file):
    with open(ports_file, 'r') as json_file:
        args_json = json.load(json_file)
    return args_json

if __name__ == '__main__':
    log.getLogger().setLevel(log.INFO)
    log.info('Application start')
    out = open(DEFAULT_LOGGING_DIR+'/cudatest.log','w')
    err = open(DEFAULT_LOGGING_DIR+'/cudatest.err','w')
    result = subprocess.call(["/bin/bash","cudatest.sh"],
       stdout=out,
       stderr=err)
    log.info('System check ended with return code '+str(result))
    out.close()
    err.close()

    # Create some outputs
    with open(DEFAULT_OUTPUT_DIR+"/result.txt",'w') as fout:
        fout.write("Empty")

    # Write status file
    if result == 0:
        create_status_file('success','GPU Test succeeded')
    else:
        create_status_file('failed','GPU Test failed with error code '+str(result))

    log.info('Application end')
