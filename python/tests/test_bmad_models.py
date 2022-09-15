from pytao import Tao
import pytest
import os

mdir = os.path.expandvars("$LCLS_LATTICE/bmad/models")

# Select models for testing. 
MODELS = [
    'cu_sxr',
 #'hxr',
 'cu_spec',
# 'lcls_complex',
 'sc_diag0',
 'cu_hxr',
# 'cu_inj',
 'sc_dasel',
 #'cu_linac',
 'sc_inj',
 'sc_sxr',
 'sc_hxr',
 'sc_bsyd']


def run_tao(model):
    init = f"-init {mdir}/{model}/tao.init -noplot"
    print(init)
    tao = Tao(init)
    return tao

def test_path():
    assert os.path.exists(mdir)

@pytest.mark.parametrize("model", MODELS)
def test_model(model):
    tao = run_tao(model)
    name = tao.branch1(1,0)["name"]
    assert name.lower() == model.lower()
