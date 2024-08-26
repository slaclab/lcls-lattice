from distgen import Generator
import pytest
import os

def find_distgen_yaml_files(start_dir):
    distgen_yaml_paths = []
    for dirpath, _, filenames in os.walk(start_dir):
        if 'distgen.yaml' in filenames:
            distgen_yaml_paths.append(os.path.join(dirpath, 'distgen.yaml'))
    return distgen_yaml_paths

start_directory = os.path.expandvars("$LCLS_LATTICE")
distgen_yaml_files = find_distgen_yaml_files(start_directory)

def test_path():
    assert os.path.exists(start_directory)

def run_distgen(yaml_file):
    G = Generator(yaml_file)
    G.run()

@pytest.mark.parametrize("yaml_file", distgen_yaml_files)
def test_model(yaml_file):
    run_distgen(yaml_file)

