from pytao import Tao
import shutil
import os
import argparse

# Do not include large particle files
def ignore_files(directory, files):
    return [f for f in files if os.path.isfile(os.path.join(directory, f)) and f == 'partcl.data']

DIRS = [
    'distgen/models/cu_inj/v0',
    'impact/models/cu_inj/v0',
]

def export_dir(rel_dir, src_root_dir, dst_root_dir):
    path1 = os.path.join(src_root_dir, rel_dir)
    path2 = os.path.join(dst_root_dir, rel_dir)
    print(f'exporting {rel_dir} from {path1} to {path2}')
    shutil.copytree(path1, path2, dirs_exist_ok=True, ignore=ignore_files)

def export_all(src_root_dir, dst_root_dir): 
    for dir in DIRS:
        export_dir(dir, src_root_dir, dst_root_dir)          


parser = argparse.ArgumentParser(description="""
    Export Impact-T models
    
    Example: 
        python export_impact.py --source $LCLS_LATTICE --dest /path/to/lcls-lattice-data/
""")
parser.add_argument('--source', help='source directory root (e.g. $LCLS_LATTICE)', required=True)    
parser.add_argument('--dest', help='destination directory root', required=True)      

if __name__ =='__main__':
    args = parser.parse_args()   
    export_all(args.source, args.dest)

    

