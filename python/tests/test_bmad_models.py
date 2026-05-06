from pytao import Tao
import pytest
import os

mdir = os.path.expandvars("$LCLS_LATTICE/bmad/models")

# Select models for testing. 
MODELS = [
 'cu_sxr',
 'cu_spec',
 'sc_diag0',
 'cu_hxr',
 'sc_dasel',
 'sc_sxr',
 'sc_hxr',
 'sc_bsyd',
 'sc_diag02',
 'sc_diagis',
 'sc_hxr2',
 'sc_sxr2',
 'sc_bsyd2',
 'sc_dasel2',
]


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
