import marimo

__generated_with = "0.10.9"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    mo.stop  # disable reactive processing, as this workflow is procedural
    return (mo,)


@app.cell(hide_code=True)
def _(mo):
    mo.md("""##SLAC XSIF to Bmad convesion""")
    return


@app.cell
def _():
    # Patch in the slac2bmad package
    import sys
    sys.path.append('python')

    from slac2bmad.xsif import prepare_xsif, remove_comment_blocks, replace_set, replace_set_commands, fix_matrix, expand_names, fix_names, unfold_comments, fold_comments
    from slac2bmad.desplit import desplit_eles, desplit_ele
    from slac2bmad.replace import replace_element, replace_eles
    from slac2bmad.bmad import finalize_bmad

    from glob import glob
    import shutil

    from subprocess import run
    import json
    import os
    return (
        desplit_ele,
        desplit_eles,
        expand_names,
        finalize_bmad,
        fix_matrix,
        fix_names,
        fold_comments,
        glob,
        json,
        os,
        prepare_xsif,
        remove_comment_blocks,
        replace_element,
        replace_eles,
        replace_set,
        replace_set_commands,
        run,
        shutil,
        sys,
        unfold_comments,
    )


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""## Check Environment""")
    return


@app.cell
def _(os, run):
    LCLS_LATTICE_ENV = os.environ['LCLS_LATTICE']
    assert LCLS_LATTICE_ENV != ''
    lcls_lat_check_1 = run(f'ls {LCLS_LATTICE_ENV}/bmad/conversion',shell=True,capture_output=True)
    assert lcls_lat_check_1.returncode == 0

    BMAD_ENV = os.environ['ACC_ROOT_DIR']
    assert BMAD_ENV != ''
    bmad_env_check_1 = run(f'ls {BMAD_ENV}/util/dist_source_me',shell=True,capture_output=True)
    assert bmad_env_check_1.returncode == 0
    return BMAD_ENV, LCLS_LATTICE_ENV, bmad_env_check_1, lcls_lat_check_1


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""##Switches""")
    return


@app.cell
def _():
    INCLUDE_DEFERRED = True # Set to False before running `deferred.ipynb`
    return (INCLUDE_DEFERRED,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""##Chance Set commands""")
    return


@app.cell
def _(replace_set):
    replace_set('SET,  afa, afa, 1a')
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""##Expand names, correct matrix element syntax""")
    return


@app.cell
def _(expand_names, fix_matrix, fix_names):
    fix_matrix('RM(3,4)')  
    expand_names('  afa APER BLMO')
    fix_names(['sfafasfa safa APER RM(1,2)'])
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""##Folding and unfolding comments""")
    return


@app.cell
def _(fold_comments, unfold_comments):
    def test():
        L0 = ['123\n', '123    !comment\n', '   \n', '  !simple comment\n', '123!456#789\n']
        L1 = unfold_comments(L0)
        L2 = fold_comments(L1)
        print(L0)
        print(L1)
        print(L2)
    test()
    return (test,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""##Desplitting (in Bmad)""")
    return


@app.cell
def _(desplit_ele):
    line0 = 'qsx16_full: line = (qsx16, xcsx16, ycsx16, qsx16)'    
    line1 = 'qsx16_full: line = (qsx16,  qsx16a)'  
    line2 = 'qsx16_full: line = (qsx16)'  
    print(desplit_ele(line0))
    return line0, line1, line2


@app.cell
def _(desplit_ele):
    desplit_ele('WIG2H_full : LINE=(WIG2H1,YCWIGH,WIG2H2)')
    return


@app.cell
def _(desplit_eles, line0):
    desplit_eles(['fafaa', line0])
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""##Custom element replacements (in Bmad)""")
    return


@app.cell
def _():
    NEWELES = {}

    NEWELES['umasxh'] = """
    !------- SXR Undulator -------
    my_umasxh_k = 5.0
    umasxh: wiggler, 
            type = "VGHPU",
            L_period = 0.039, 
            n_period = 87, 
            b_max = my_umasxh_k * 2*pi*m_electron / (c_light * 0.039), 
            L = 87*0.039, 
            ds_step = 0.039*10

    umasxh[L] = umasxh[L]/2 ! Will be doubled in desplitting process. 
    !---------------------------------
    """

    NEWELES['umahxh'] = """
    !------- HXR Undulator -------
    my_umahxh_k = 2.0
    umahxh: wiggler, 
            type = "HGVPU",
            L_period = 0.026, 
            n_period = 129, 
            b_max = my_umahxh_k * 2*pi*m_electron / (c_light * 0.026), 
            L = 129*0.026, 
            tilt=pi/2,
            ds_step = 0.026*10

    umahxh[L] = umahxh[L]/2 ! Will be doubled in desplitting process. 
    !---------------------------------
        """




    NEWELES['pssxh'] = """
    !------- SXR Phase Shifter -------
    !
    ! B_max = 2pi/lambda * sqrt(2*PHASE_INTEGRAL / L)
    ! 
    pssxh_phase_integral = 3814e-9  !T^2 m^3, maximum, from: T^2mm^3 (180-3814)
    pssxh_L        = 0.0825   ! m 
    pssxh_L_period = 0.075 ! m 
    pssxh: wiggler, type = "phase shifter", 
        L = pssxh_L,
        b_max = 2*pi / pssxh_L_period * sqrt(2 * pssxh_phase_integral / pssxh_L  ),
        n_period = 1
    pssxh[L] = pssxh[L]/2 ! Will be doubled in desplitting process. 
    !---------------------------------
    """



    NEWELES['pshxh'] = """
    !------- HXR Phase Shifter -------
    !
    ! B_max = 2pi/lambda * sqrt(2*PHASE_INTEGRAL / L)
    ! 
    pshxh_phase_integral = 490e-9  !T^2 m^3, maximum, from: T^2mm^3 (80-490)
    pshxh_L        = 0.0495 ! m 
    pshxh_L_period = 0.045 ! m 
    pshxh: wiggler, type = "phase shifter", 
        L = pshxh_L,
        b_max = 2*pi / pshxh_L_period * sqrt(2 * pshxh_phase_integral / pshxh_L  ),
        n_period = 1
    pshxh[L] = pshxh[L]/2 ! Will be doubled in desplitting process. 
    !---------------------------------
    """



    #-----------------
    # XLEAP-II wigglers
    NEWELES['umxl1h'] = """
    !------- XLEAP-II wigglers -------
    umxl0h: wiggler, 
            type = "LCLS-I",
            L_period = 0.555, 
            n_period = 6, 
            b_max = 0, ! = K * 2*pi*m_electron / (c_light * 0.55), 
            L = 6*0.555
            !ds_step = 0.55*10

    umxl0h[L] = umxl0h[L]/2 ! Will be doubled in desplitting process. 
    !---------------------------------

    umxl1h: umxl0h

    """

    # Inherit from umxl0h
    NEWELES['umxl2h'] = """
    umxl2h: umxl0h
    """

    NEWELES['umxl3h'] = """
    umxl3h: umxl0h
    """

    NEWELES['umxl4h'] = """
    umxl4h: umxl0h
    """

    # This needs to be extended
    NEWELES['duqxl'] = """
    ! Extend to account for real WIGGLER elements for XLEAP
    duqxl: drift, L = 0.2166 + 0.03
    """
    return (NEWELES,)


@app.cell
def _(INCLUDE_DEFERRED, json):
    # CU only replacements


    CU_NEWELES = {}

    CU_NEWELES['lh_und'] = """
    !------- Laser Heater Undulator for Copper Linac -------
    my_lh_und_k = 1.38523
    lh_und: wiggler, 
            type = "laser_heater_undulator",
            L_period = 0.054, 
            n_period = 10, 
            b_max = my_lh_und_k * 2*pi*m_electron / (c_light * 0.054), 
             L = 10*0.054 ! Was: 0.506263, 
            ds_step = 0.054

    lh_und[L] = lh_und[L]/2 ! Will be doubled in desplitting process. 
    !---------------------------------
        """

    CU_NEWELES['dh03a'] = """
    ! Shorten so that lh_und has an integer number of poles
    dh03a: drift, l = 0.09290825 - ( 10*0.054 - 0.506263 ) /2, type = "CSR"
    """

    CU_NEWELES['dh03b'] = """
    ! Shorten so that lh_und has an integer number of poles
    dh03b: drift, l = 0.08401830- ( 10*0.054 - 0.506263 ) /2, type = "CSR"
    """

    # Add these replacements
    CU_LINAC_REPLACEMENTS = json.load(open('replacements/good_cu_linac_replacements.json'))
    for name, replace in CU_LINAC_REPLACEMENTS.items():
        CU_NEWELES[name.lower()+'_full'] = replace

    # Add deferred elements    
    if INCLUDE_DEFERRED:
        CU_NEWELES.update(json.load(open('replacements/deferred_cu_replacements.json')))

    print(CU_NEWELES.keys())
    return CU_LINAC_REPLACEMENTS, CU_NEWELES, name, replace


@app.cell
def _(INCLUDE_DEFERRED, json):
    # SC Only replacements

    SC_NEWELES = {}

    SC_NEWELES['umhtr'] = """
    !------- Laser Heater Undulator for SC Linac -------
    my_umhtr_k = 0.960143

    umhtr: wiggler, 
            type = "laser_heater_undulator",
            L_period = 0.054, 
            n_period = 10, 
            b_max = my_umhtr_k * 2*pi*m_electron / (c_light * 0.054), 
            L = 10*0.054 ! Was: 0.506263, 
            ds_step = 0.054

    umhtr[L] = umhtr[L]/2 ! Will be doubled in desplitting process. 
    !---------------------------------
        """
    # 
    SC_NEWELES['dh02c'] = """
    ! Shorten so that umhtr has an integer number of poles
    dh02c: drift, l = 0.2795065 - ( 10*0.054 - 0.506263 ) /2 , type = "CSR" !0.297036
    """

    SC_NEWELES['dh02d'] = """
    ! Shorten so that umhtr has an integer number of poles
    dh02d: drift, l = 0.2724707 - ( 10*0.054 - 0.506263 ) /2, type = "CSR" !0.2900002
    """

    # Not needed. Desplitting handles cavities now.
    # Add these repalcements
    #SC_LINAC_REPLACEMENTS = json.load(open('replacements/good_sc_linac_replacements.json'))
    #for name, replace in SC_LINAC_REPLACEMENTS.items():
    #    SC_NEWELES[name.lower()+'_full'] = replace


    # Add deferred elements 
    if INCLUDE_DEFERRED:
        SC_NEWELES.update(json.load(open('replacements/deferred_sc_replacements.json')))

    print(SC_NEWELES.keys())
    return (SC_NEWELES,)


@app.cell
def _():
    print("!---------------------\n! CAVL015 LCAVITY\nCAVL015_full: line = (CAVL015)\n! contains zero length elements:\n    CSP01[superimpose] = T\n    CSP01[ref] = CAVL015\n    CSP01[ref_origin] = beginning\n    CSP01[offset] = 0.659221562\n\n")
    return


@app.cell
def _(CU_NEWELES, NEWELES, SC_NEWELES):
    def all_replacements(master_file):
        dat = {}
        dat.update(NEWELES)
        if master_file.startswith('CU_'):
            print('CU replacements')
            dat.update(CU_NEWELES)
            return dat
        elif master_file.startswith('SC_'):
            print('SC replacements')
            dat.update(SC_NEWELES)
            return dat
        else:
            raise 
    #all_replacements('CU_')
    return (all_replacements,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""##Convert All""")
    return


@app.cell
def _(run):
    run('rm -r temp',shell=True)
    run('mkdir temp',shell=True)
    run('rm -f *xsif *bmad *digested*',shell=True)
    run('cp $LCLS_LATTICE/mad/*.xsif .',shell=True)
    return


@app.cell
def _(os, prepare_xsif):
    XSIF_FILES=[f for f in os.listdir() if f.endswith('.xsif')]
    print(XSIF_FILES)
    for f in XSIF_FILES:
        prepare_xsif(f, save=False)
    return XSIF_FILES, f


@app.cell
def _(run):
    run('mv *xsif temp/',shell=True)
    return


@app.cell
def _(os):
    CU_MASTERS = [f for f in os.listdir('../../mad') if f.startswith('CU_') and f.endswith('xsif')]
    SC_MASTERS = [f for f in os.listdir('../../mad') if f.startswith('SC_') and f.endswith('xsif')]
    CU_MASTERS, SC_MASTERS
    return CU_MASTERS, SC_MASTERS


@app.cell
def _(run):
    TEMPDIR = './temp/'
    WORKDIR = './work/'
    run('pwd')
    print(f'mkdir {WORKDIR}')
    run(f'mkdir work',shell=True)
    return TEMPDIR, WORKDIR


@app.cell
def _(os):
    DEST = os.path.expandvars('$LCLS_LATTICE/bmad/master/')
    print(DEST)
    return (DEST,)


@app.cell
def _(
    DEST,
    TEMPDIR,
    WORKDIR,
    all_replacements,
    finalize_bmad,
    glob,
    run,
    shutil,
):
    def process_master(master):

        print(f'Converting {master}')

        shutil.copytree(TEMPDIR, WORKDIR, dirs_exist_ok=True)

        # New method
        SCRIPT = f'python $ACC_ROOT_DIR/util_programs/mad_to_bmad/mad8_to_bmad.py --no_prepend_vars -f {master}'

        res = run(SCRIPT, shell=True, cwd=WORKDIR)

        assert res.returncode == 0

        BMAD_FILES=glob(WORKDIR+'/*bmad')

        REPLACEMENTS = all_replacements(master)

        for f in BMAD_FILES:
            finalize_bmad(f, replacements=REPLACEMENTS, verbose=False)   

        print(f'    Copying all to {DEST}')
        for f in BMAD_FILES:
            #print(f'copying {f} to {DEST}')
            shutil.copy(f, DEST)
    run('pwd')    
    process_master('SC_SXR.xsif')
    return (process_master,)


@app.cell
def _(CU_MASTERS, process_master):
    for _m in CU_MASTERS:
        process_master(_m)
    return


@app.cell
def _(SC_MASTERS, process_master):
    for _m in SC_MASTERS:
        process_master(_m)
    return


@app.cell
def _(TEMPDIR, WORKDIR, run):
    run(f'rm -r {TEMPDIR}',shell=True)
    run(f'rm -r {WORKDIR}',shell=True)
    return


if __name__ == "__main__":
    app.run()
