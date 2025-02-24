import marimo

__generated_with = "0.11.6"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    return (mo,)


@app.cell(hide_code=True)
def _(mo):
    mo.md("""# SLACPROD Oracle Table""")
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md("""##Check Environment""")
    return


@app.cell
def _():
    import os
    from subprocess import run

    LCLS_LATTICE_ENV = os.environ['LCLS_LATTICE']
    assert LCLS_LATTICE_ENV != ''
    lcls_lat_check_1 = run(f'ls {LCLS_LATTICE_ENV}/bmad/conversion',shell=True,capture_output=True)
    assert lcls_lat_check_1.returncode == 0

    FACET2_LATTICE_ENV = '/home/mpe/DATA/new_repo/facet2-lattice'  #os.environ['FACET2_LATTICE']
    assert FACET2_LATTICE_ENV != ''
    facet2_lat_check_1 = run(f'ls {FACET2_LATTICE_ENV}/bmad/conversion',shell=True,capture_output=True)
    assert facet2_lat_check_1.returncode == 0

    BMAD_ENV = os.environ['ACC_ROOT_DIR']
    assert BMAD_ENV != ''
    bmad_env_check_1 = run(f'ls {BMAD_ENV}/util/dist_source_me',shell=True,capture_output=True)
    assert bmad_env_check_1.returncode == 0
    return (
        BMAD_ENV,
        FACET2_LATTICE_ENV,
        LCLS_LATTICE_ENV,
        bmad_env_check_1,
        facet2_lat_check_1,
        lcls_lat_check_1,
        os,
        run,
    )


@app.cell
def _(LCLS_LATTICE_ENV):
    LCLS_LATTICE_ENV
    return


@app.cell
def _():
    import pandas as pd
    import numpy as np
    import json
    return json, np, pd


@app.cell
def _(LCLS_LATTICE_ENV, os, pd):
    # Table extracted from SLACPROD Oracle Database
    MASTER = f'{LCLS_LATTICE_ENV}/bmad/conversion/from_oracle/lcls_elements.csv'

    df = pd.read_csv(os.path.expandvars(MASTER))
    # Remove empty
    df = df[['Element', 'Control System Name']].dropna()
    return MASTER, df


@app.cell
def _(df):
    # These are unique
    MADNAMES = list(df['Element'])
    assert len(MADNAMES) == len(set(MADNAMES))
    # These are not
    DEVICENAMES = list(df['Control System Name'])
    assert len(DEVICENAMES) >= len(set(DEVICENAMES))
    return DEVICENAMES, MADNAMES


@app.cell
def _(df):
    # These devices have multiple elements - a mistake?
    series  = df.groupby('Control System Name')['Element'].apply(list)
    for i, val in series.items():
        if len(val) > 1:
            # Skip klystrons - these are expected to be duplicated
            if not val[0].startswith('K'):
                print(i, val)
    return i, series, val


@app.cell
def _(DEVICENAMES, MADNAMES, json):
    # dict for lookup
    DEVICE = dict(zip(MADNAMES, DEVICENAMES))
    json.dump(DEVICE, open('element_devices.json', 'w'))
    return (DEVICE,)


@app.cell(hide_code=True)
def _(mo):
    mo.md("""##Models""")
    return


@app.cell
def _(LCLS_LATTICE_ENV):
    BDIR = f'{LCLS_LATTICE_ENV}/bmad/'
    return (BDIR,)


@app.cell
def _(BDIR, LCLS_LATTICE_ENV, os):
    # All models
    MODELS = [d for d in os.listdir(BDIR+'models/') if os.path.isdir(BDIR+'/models/'+d)]
    INITFILE = {model:f'{LCLS_LATTICE_ENV}/bmad/models/{model}/tao.init' for model in MODELS}
    for k,v, in INITFILE.items():
        print(f'{k:<16}{v}')
    return INITFILE, MODELS, k, v


@app.cell
def _(FACET2_LATTICE_ENV, INITFILE, MODELS, os):
    # Tack on FACET-II if availiable

    FDIR = f'{FACET2_LATTICE_ENV}/bmad/'

    if os.path.exists(FDIR):
        print('Adding FACET-II')
        model = 'f2_elec'
        ifile = f'{FDIR}/models/{model}/tao.init'
        if os.path.exists(ifile):
            print(f'Adding {model} model')
            MODELS.append(model)
            INITFILE[model] = ifile
    return FDIR, ifile, model


@app.cell
def _():
    from pytao import Tao
    return (Tao,)


@app.cell
def _(DEVICE, INITFILE, MASTER, Tao):
    def ele_names(model):
        init = INITFILE[model]
        print(f'{model}')
        tao = Tao(f'-init {init} -noplot')
        names = tao.cmd('python lat_list 1@0>>*|model ele.name')
        return names

    def remove_superslaves(names):
        return [x for x in names if '#' not in x]

    def write_devicenames(unames, filename):
        my_names = remove_superslaves(unames)
        lines = ['! ---------',
                 '! Device mapping derived from '+MASTER

                ]
        for name in my_names:
            if name in DEVICE:
                line = name+'[alias]='+ DEVICE[name]

            else:
                #continue
                line = '! No device listed for: '+name
            lines.append(line)    
        with open(filename, 'w') as f:
            for line in lines:
                f.write(line+'\n')
        print('Written:', filename)
    return ele_names, remove_superslaves, write_devicenames


@app.cell(hide_code=True)
def _(mo):
    mo.md("""##Add to CU Master""")
    return


@app.cell
def _(BDIR, ele_names, os, write_devicenames):
    CU_FILE = f'{BDIR}/master/LCLScu_devicenames.bmad'
    CU_FILE_BAK = f'{BDIR}/master/LCLScu_devicenames-bak.bmad'
    os.rename(CU_FILE,CU_FILE_BAK)
    open(CU_FILE, 'a').close()  #make an empty file

    _models = ['cu_hxr', 'cu_sxr', 'cu_spec']
    _names = []
    for _m in _models:
        print(_m)
        _names += ele_names(_m)
    _unames = sorted(list(set(_names)))

    write_devicenames(_unames, CU_FILE)
    return CU_FILE, CU_FILE_BAK


@app.cell(hide_code=True)
def _(mo):
    mo.md("""##Add to SC Master""")
    return


@app.cell
def _(BDIR, ele_names, write_devicenames):
    SC_FILE = f'{BDIR}/master/LCLSsc_devicenames.bmad'

    _models = ['sc_hxr', 'sc_sxr', 'sc_diag0', 'sc_bsyd', 'sc_dasel']
    _names = []
    for _m in _models:
        print(_m)
        _names += ele_names(_m)
    _unames = sorted(list(set(_names)))

    write_devicenames(_unames, SC_FILE)
    return (SC_FILE,)


@app.cell(hide_code=True)
def _(mo):
    mo.md("""##Add to FACET-II""")
    return


@app.cell
def _(FDIR, ele_names, os, write_devicenames):
    os.environ['FACET2_LATTICE'] = '/home/mpe/DATA/new_repo/facet2-lattice/'
    if os.path.exists(FDIR):
        F2_FILE = f'{FDIR}/master/FACET2e_devicenames.bmad'
        _models = ['f2_elec']
        _names = []
        for _m in _models:
            print(_m)
            _names += ele_names(_m)
        _unames = sorted(list(set(_names)))

        write_devicenames(_unames, F2_FILE)
    return (F2_FILE,)


@app.cell
def _():
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
