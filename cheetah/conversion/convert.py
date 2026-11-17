""" convert simulations to cheetah format"""

import os
from cheetah import Segment

def convert_bmad_cu_hxr():
    """Convert BMAD CU HXR simulations to cheetah format"""
    lcls_lattice_path = os.environ["LCLS_LATTICE"]
    lat_file = os.path.join(lcls_lattice_path, "bmad", "models","cu_hxr","cu_hxr.lat.bmad")

    print("reading lattice file", lat_file)
    segment = Segment.from_bmad(lat_file)

    dump_file = os.path.join(lcls_lattice_path, "cheetah", "cu_hxr.json")
    print("dumping lattice to", dump_file)
    segment.to_lattice_json(dump_file)

def convert_bmad_cu_sxr():
    """Convert BMAD CU SXR simulations to cheetah format"""
    lcls_lattice_path = os.environ["LCLS_LATTICE"]
    lat_file = os.path.join(lcls_lattice_path, "bmad", "models","cu_sxr","cu_sxr.lat.bmad")

    print("reading lattice file", lat_file)
    segment = Segment.from_bmad(lat_file)

    dump_file = os.path.join(lcls_lattice_path, "cheetah", "cu_sxr.json")
    print("dumping lattice to", dump_file)
    segment.to_lattice_json(dump_file)

if __name__ == "__main__":
    convert_bmad_cu_hxr()
    convert_bmad_cu_sxr()