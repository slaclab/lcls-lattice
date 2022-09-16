from pytao import Tao
import shutil
import os
import argparse


# bmad/models to export

# MODELS_DIR = os.path.expandvars('$LCLS_LATTICE/bmad/models/')
# MODELS = os.listdir(MODELS_DIR)

MODELS = ['cu_sxr',
# 'hxr',
 'cu_spec',
# 'lcls_complex',
 'sc_diag0',

# 'cu_inj',
 'sc_dasel', # crashes Bmad, bug reported
# 'cu_linac',
 'sc_inj',
 'sc_sxr',
 'sc_hxr',
 'sc_bsyd',
 'cu_hxr'         
         ]

DIRS = ['bmad/tao']


def export_model(model, src_root_dir, dst_root_dir):
     
    # Basic check for directories
    for d in [src_root_dir, dst_root_dir]:
        assert os.path.exists(d)

    path = f'bmad/models/{model}'        
    path1 = os.path.join(src_root_dir, path)
    path2 = os.path.join(dst_root_dir, path)
    print(f'exporting {model} from {path1} to {path2}')
    assert os.path.exists(path1), path1
    
    if not os.path.exists(path2):
        os.makedirs(path2)

    # Check that the properly named lattice file exists
    lat = f'{path1}/{model}.lat.bmad'
    if not os.path.exists(lat):
        print(f'no lat file for {model}, skipping')
        return 
    latname = os.path.split(lat)[1]
    
    # Run Tao, write lattice
    tao = Tao(f'-init {path1}/tao.init -noplot')    
    outfile = os.path.join(path2, latname)
    tao.cmd(f'write bmad {outfile}')
    
    # copy tao.init file
    src = os.path.join(path1, 'tao.init')
    dst = os.path.join(path2, 'tao.init')
    shutil.copy(src, dst)
    
def export_dir(rel_dir, src_root_dir, dst_root_dir):
    path1 = os.path.join(src_root_dir, rel_dir)
    path2 = os.path.join(dst_root_dir, rel_dir)
    print(f'exporting {rel_dir} from {path1} to {path2}')
    shutil.copytree(path1, path2, dirs_exist_ok=True)    
    
def export_all(src_root_dir, dst_root_dir): 
    for model in MODELS:
        export_model(model, src_root_dir, dst_root_dir)  
    
    for dir in DIRS:
        export_dir(dir, src_root_dir, dst_root_dir)          
    
    
parser = argparse.ArgumentParser(description="""
    Export Bmad lattices, preserving the directory structure.
    
    Example: 
        python export_lattice.py --source $LCLS_LATTICE --dest /path/to/lcls-lattice-data/
""")
parser.add_argument('--source', help='source directory root (e.g. $LCLS_LATTICE)', required=True)    
parser.add_argument('--dest', help='destination directory root', required=True)      
    
if __name__ =='__main__':
    args = parser.parse_args()   
    export_all(args.source, args.dest)
    
    
    
