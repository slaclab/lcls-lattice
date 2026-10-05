#!/usr/bin/env python3
"""
Beam stay-clear (BSC) calculator.

Reads   <model>_twiss.dat  for every model in MODELS and ips.dump,
writes  BSC_<model>.txt    (one per model, raw per-element values)
        oracle_upload/BSC-AD_ACCEL-<optics>.txt   (collated, in IP order)

Starting point: J. Welch, LCLSII-TN-14-15, 2014.

Conventions
-----------
* Twiss files are in metres / GeV-times-1e9 (e_tot column is converted to GeV).
* "xid"/"yid" are stay-clear HALF-widths in mm; "dia" is 2*sqrt(xid^2 + yid^2) in mm.
  (The original script called these "full height" in comments, but they were halved.)
* Index conventions are unchanged from the original script, so ordinals in
  ips.dump still refer to rows of the twiss files.

Usage:  bsc.py [optics] [--twiss-dir DIR] [--ips ips.dump] [--outdir oracle_upload]
"""
from __future__ import annotations

import argparse
import warnings
from dataclasses import dataclass
from pathlib import Path

import numpy as np

# --------------------------------------------------------------------------
# Specifications
# --------------------------------------------------------------------------
ELECTRON_MASS_GEV = 511e-6

MIN_X0 = 8e-3        # minimum X-BSC diameter (m)
MIN_Y0 = 8e-3        # minimum Y-BSC diameter (m)
MIN_UND = 5e-3       # minimum X/Y-BSC diameter in the undulator (m)
MIN_DIAG0_AFTER_TCAV = 20e-3  # DIAG0 minimum diameter after an RF deflector (m)
DE1 = 0.120          # full core energy width in BC1
DE2 = 0.036          # full core energy width in BC2
DE4 = 0.010          # full core energy width after undulator or BSY dump
NSIG = 16            # max. number of sigma (betatron size)
STEER_UND = 1e-3     # max. steering range in undulator (+- this value, m)
STEER_ELSE = 2e-3    # max. steering range everywhere else (+- this value, m)
DX_R56 = 5e-3        # horizontal addition in R56-compensating chicanes (m)
BETAF = 2.0          # worst case beta scalar
ETAF = 1.25          # worst case dispersion scalar
EFEL = 0.02          # FEL energy loss after undulator
XF = 18e-3           # x-offset of beam at OTRDMP with X-band TCAV on (m)
XW = 12e-3           # x full width of streaked beam at OTRDMP, TCAV on (m)

# DASEL
A_DASEL = 65e-9      # effective beam admittance (m)
DP_DASEL = 0.02      # max relative energy error in the S30XL
D_DASEL = 0.002      # max residual beam orbit in S30XL (m)

# Energy windows (GeV, exclusive bounds) that identify the machine region
HEATER = (0.07, 0.12)   # heater or DIAG0
BC1 = (0.22, 0.28)
BC2 = (1.3, 1.9)
POST_LINAC = (3.7, 8.2)  # includes LCLS2cuS; 3.7/8.2 for LCLSII-HE (July 2017)

R56_CHICANES = ['CCDLU', 'CCDLD', 'CC31B', 'CC32B', 'CC31', 'CC32', 'CC35', 'CC36']

# Cavities whose names carry a trailing A/B that must be stripped.
CAVITY_PREFIXES = tuple(
    [f'CAVL{n:02d}5' for n in range(1, 36)] + ['CAVC012', 'CAVC022']
)


@dataclass(frozen=True)
class BeamParams:
    dE3: float            # full core energy width in post-linac
    Etrip: float          # energy lost to one trip (GeV)
    eN: float = 1e-6      # worst-case normalized emittance (~2x nominal)
    Ejit: float = 0.1e-2  # estimated FW relative energy jitter
    vern: float = 0.01    # energy vernier after linac
    chirp: float = 0.01   # FWHM energy spread from optional linear chirp


CU_PARAMS = BeamParams(dE3=0.1e-2, Etrip=0.235 / 2)  # largest value @ 2.5 GeV
SC_PARAMS = BeamParams(dE3=0.016, Etrip=0.016)       # one SSA trip


# --------------------------------------------------------------------------
# Model table: one place instead of three parallel lists.
# Listed in the order they appear in the collated output.
# --------------------------------------------------------------------------
@dataclass(frozen=True)
class ModelSpec:
    froot: int
    name: str
    params: BeamParams
    kind: str = 'standard'  # 'standard' or 'dasel'

    @property
    def is_cu(self) -> bool:
        return self.name.startswith('cu_')


MODELS = [
    ModelSpec(1,  'sc_sxr_beam0',   SC_PARAMS),
    ModelSpec(6,  'sc_hxr_beam0',   SC_PARAMS),
    ModelSpec(10, 'cu_hxr',         CU_PARAMS),
    ModelSpec(7,  'sc_bsyd_beam0',  SC_PARAMS),
    ModelSpec(8,  'sc_diag0_beam0', SC_PARAMS),
    ModelSpec(14, 'cu_sxr',         CU_PARAMS),
    ModelSpec(9,  'sc_dasel_beam0', SC_PARAMS, kind='dasel'),
    ModelSpec(17, 'sc_diag02',      SC_PARAMS),
    ModelSpec(18, 'sc_diagis',      SC_PARAMS),
]
SPEC_BY_FROOT = {m.froot: m for m in MODELS}
OUTPUT_ORDER = [m.froot for m in MODELS]


# --------------------------------------------------------------------------
# Lattice loading
# --------------------------------------------------------------------------
@dataclass
class Lattice:
    names: list[str]
    keys: list[str]
    s: np.ndarray
    beta_a: np.ndarray
    beta_b: np.ndarray
    phi_a: np.ndarray
    phi_b: np.ndarray
    eta_x: np.ndarray
    eta_y: np.ndarray
    e_tot: np.ndarray  # GeV

    def __len__(self):
        return len(self.names)

    def find(self, prefix: str) -> list[int]:
        """Indices of all elements whose name starts with `prefix`."""
        return [i for i, n in enumerate(self.names) if n.startswith(prefix)]

    def find_one(self, prefix: str, last: bool = False) -> int:
        idx = self.find(prefix)
        if not idx:
            raise ValueError(f"No element with name prefix '{prefix}' in lattice")
        return idx[-1] if last else idx[0]


def load_twiss(path: Path) -> Lattice:
    names, keys, rows = [], [], []
    with open(path) as f:
        for line in f:
            if not line.strip() or line.startswith('#'):
                continue
            parts = line.split()
            if len(parts) != 10:
                raise ValueError(f'{path}: expected 10 columns, got {len(parts)}: {line!r}')
            name = parts[0]
            #if name.startswith(CAVITY_PREFIXES):
            #    name = name[:-1]
            names.append(name)
            keys.append(parts[1])
            rows.append([float(x) for x in parts[2:]])
    d = np.array(rows, dtype=float).reshape(-1, 8)
    return Lattice(names, keys, d[:, 0], d[:, 1], d[:, 2], d[:, 3], d[:, 4],
                   d[:, 5], d[:, 6], d[:, 7] * 1e-9)


# --------------------------------------------------------------------------
# Per-model points of interest
# --------------------------------------------------------------------------
@dataclass
class Context:
    s_xrstart: float = 0.0      # undulator start
    s_xrterm: float = 0.0       # undulator exit (dump line start)
    s_tcx01: float = 1e10       # X-band TCAV exit (default: not in this beamline)
    s_tcxdg0: float = 1e10      # X-TCAV exit in DIAG0
    s_tcydg0: float = 1e10      # Y-TCAV exit in DIAG0
    bxf: float | None = None    # betaX at dump screen
    mxf: float | None = None    # phase advance to dump screen
    mx0: float | None = None    # phase advance at X-band TCAV center
    dE0: float = 0.058          # core energy width in heater area

    def require_tcav(self):
        missing = [k for k in ('bxf', 'mxf', 'mx0') if getattr(self, k) is None]
        if missing:
            raise ValueError(f'TCX01 present but OTRDMP/MTCX info missing: {missing}')


def find_context(lat: Lattice, model: str) -> Context:
    ctx = Context()
    for name, s, beta_a, phi_a in zip(lat.names, lat.s, lat.beta_a, lat.phi_a):
        if name[1:8] == 'XRSTART':
            ctx.s_xrstart = s
        elif name[1:7] == 'XRTERM':
            ctx.s_xrterm = s
        elif name[0:5] == 'TCX01':
            ctx.s_tcx01 = s
        elif name == 'MTCX' or name[0:5] == 'MTCXB':
            ctx.mx0 = phi_a
        elif name[0:6] == 'OTRDMP':
            ctx.bxf, ctx.mxf = beta_a, phi_a
    if model == 'sc_diag0_beam0':
        ctx.dE0 = 0.04
        ctx.s_tcydg0 = lat.s[lat.find_one('TCYDG0', last=True)]
        ctx.s_tcxdg0 = lat.s[lat.find_one('TCXDG0', last=True)]
    return ctx


def r56_mask(lat: Lattice) -> np.ndarray:
    """True for elements inside an R56-compensating chicane."""
    mask = np.zeros(len(lat), dtype=bool)
    for name in R56_CHICANES:
        beg, end = lat.find(f'{name}BEG'), lat.find(f'{name}END')
        if beg and end:
            mask[beg[0]:end[0] + 1] = True
    return mask


# --------------------------------------------------------------------------
# BSC computation
# --------------------------------------------------------------------------
@dataclass
class BscTable:
    names: list[str]
    keys: list[str]
    dia: np.ndarray    # mm
    xid: np.ndarray    # mm, half-width
    yid: np.ndarray    # mm, half-width
    valid: np.ndarray  # False for elements that were not computed (e.g. Cu linac before BSY)


def _between(x, window):
    return (x > window[0]) & (x < window[1])


def _standard(lat: Lattice, p: BeamParams, ctx: Context, chicane: np.ndarray, lo: int, hi: int):
    """Vectorized BSC for elements lo..hi-1. Returns (xid, yid) half-widths in mm."""
    sl = slice(lo, hi)
    s, E = lat.s[sl], lat.e_tot[sl]
    beta_a, beta_b = lat.beta_a[sl], lat.beta_b[sl]
    if np.any(E <= 0):
        bad = lat.names[lo + int(np.flatnonzero(E <= 0)[0])]
        raise ValueError(f'Non-positive energy at element {bad}')

    emit = p.eN / (E / ELECTRON_MASS_GEV)  # emittance along machine

    heater = _between(E, HEATER)
    bc1 = _between(E, BC1)
    bc2 = _between(E, BC2)
    post = _between(E, POST_LINAC)
    pre_und = post & (s < ctx.s_xrstart)
    in_und = post & (s >= ctx.s_xrstart) & (s <= ctx.s_xrterm)
    post_und = post & (s > ctx.s_xrterm)

    # Energy spread. Stays 0 outside these windows and inside the undulator.
    efel = EFEL if ctx.s_xrterm > 0 else 0.0
    esprd = np.select(
        [heater, bc1, bc2, pre_und, post_und],
        [ctx.dE0 + 2 * p.chirp + 2 * p.Ejit,
         DE1 + 2 * p.chirp + 2 * p.Ejit,
         DE2 + p.chirp + 2 * p.Ejit + p.Etrip / E,
         p.dE3 + p.chirp + p.vern + p.Ejit + p.Etrip / E,
         DE4 + p.chirp + p.vern + efel + p.Ejit + p.Etrip / E],
        default=0.0)

    steer = np.where(in_und, STEER_UND, STEER_ELSE)
    min_x = np.where(in_und, MIN_UND, MIN_X0)
    min_y = np.where(in_und, MIN_UND, MIN_Y0)
    min_x = np.where(heater & (s > ctx.s_tcxdg0), MIN_DIAG0_AFTER_TCAV, min_x)
    min_y = np.where(heater & (s > ctx.s_tcydg0), MIN_DIAG0_AFTER_TCAV, min_y)

    # X-band TCAV streak, downstream of TCX01
    xt = np.zeros_like(s)
    streak = post_und & (s > ctx.s_tcx01)
    if streak.any():
        ctx.require_tcav()
        xt[streak] = ((XF + XW / 2) * np.sqrt(beta_a[streak] / ctx.bxf)
                      * np.sin(lat.phi_a[sl][streak] - ctx.mx0)
                      / np.sin(ctx.mxf - ctx.mx0))

    dx = np.where(chicane[sl], DX_R56, 0.0)

    x = 500.0 * np.maximum(
        2 * NSIG * np.sqrt(emit * beta_a * BETAF)
        + ETAF * np.abs(lat.eta_x[sl]) * esprd + 2 * steer + 2 * xt + dx, min_x)
    y = 500.0 * np.maximum(
        2 * NSIG * np.sqrt(emit * beta_b * BETAF)
        + ETAF * np.abs(lat.eta_y[sl]) * esprd + 2 * steer, min_y)
    return x, y


def _dasel(lat: Lattice, lo: int, hi: int, mark: int):
    """DASEL BSC for elements lo..hi-1. `mark` is the index downstream of BLRDAS."""
    sl = slice(lo, hi)
    f = np.where(np.arange(lo, hi) <= mark, 0.5, 1.0)
    x = 1e3 * (np.sqrt(A_DASEL * lat.beta_a[sl]) + np.abs(lat.eta_x[sl] * DP_DASEL) + f * D_DASEL)
    y = 1e3 * (np.sqrt(A_DASEL * lat.beta_b[sl]) + np.abs(lat.eta_y[sl] * DP_DASEL) + f * D_DASEL)
    return x, y


def compute_model(spec: ModelSpec, lat: Lattice) -> BscTable:
    n = len(lat)
    lo, hi = 0, n
    if spec.is_cu:
        lo = lat.find_one('BEGCLTH_0')              # entrance to BSY (Cu linac)

    if spec.kind == 'dasel':
        lo = lat.find_one('BEGSPA')
        hi = lat.find_one('ENDBSYA', last=True) + 1
        mark = lat.find_one('BLRDAS', last=True)
        x, y = _dasel(lat, lo, hi, mark)
    else:
        ctx = find_context(lat, spec.name)
        x, y = _standard(lat, spec.params, ctx, r56_mask(lat), lo, hi)

    xid, yid = np.zeros(n), np.zeros(n)
    xid[lo:hi], yid[lo:hi] = x, y
    valid = np.zeros(n, dtype=bool)
    valid[lo:hi] = True

    # zero-out kicked '?' elements
    kicked = np.array([nm.endswith('?') for nm in lat.names], dtype=bool)
    xid[kicked] = 0.0
    yid[kicked] = 0.0

    dia = 2 * np.sqrt(xid ** 2 + yid ** 2)
    return BscTable(list(lat.names), list(lat.keys), dia, xid, yid, valid)


def share_max_per_name(t: BscTable) -> None:
    """All (non-drift) elements with the same name get the dia/xid/yid of the
    row with the largest dia. Modifies `t` in place."""
    groups: dict[str, list[int]] = {}
    for i in np.flatnonzero(t.valid):
        if t.keys[i] != 'Drift':
            groups.setdefault(t.names[i], []).append(i)
    for idx in groups.values():
        if len(idx) < 2:
            continue
        best = idx[int(np.argmax(t.dia[idx]))]
        for arr in (t.dia, t.xid, t.yid):
            arr[idx] = arr[best]


# --------------------------------------------------------------------------
# I/O
# --------------------------------------------------------------------------
def write_model_file(path: Path, lat: Lattice, t: BscTable) -> None:
    with open(path, 'w') as f:
        f.write('#ELEMENT              S (m)        BSCd (mm)    +BSCx (mm)     -BSCx (mm)'
                '    +BSCy (mm)     -BSCy (mm)\n')
        for i in np.flatnonzero(t.valid):
            f.write('{:<16s}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}  {:>10.6e}\n'
                    .format(lat.names[i].rstrip('_'), lat.s[i], t.dia[i],
                            t.xid[i], -t.xid[i], t.yid[i], -t.yid[i]))


def read_ips(path: Path) -> list[tuple[int, int, str]]:
    """Read ips.dump, returned grouped by froot in OUTPUT_ORDER (file order within a group)."""
    entries = []
    with open(path) as f:
        for line in f:
            if not line.strip() or line.startswith('#'):
                continue
            parts = line.split()
            entries.append((int(parts[0]), int(parts[1]), parts[4]))
    return [e for froot in OUTPUT_ORDER for e in entries if e[0] == froot]


def write_collated(path: Path, ips, tables: dict[str, BscTable], markers: dict[str, int]) -> None:
    hxr_offset = markers['sc_hxr_beam0'] - markers['cu_hxr']
    path.parent.mkdir(parents=True, exist_ok=True)
    zero = f'{0:>10.6e}'
    with open(path, 'w') as f:
        f.write('#ELEMENT, Stayclear Dia (mm), +Horz (mm), -Horz (mm), +Vert (mm), -Vert (mm)\n')
        for froot, ordinal, name in ips:
            if ordinal < 0:
                if not name.startswith('FIXER'):
                    f.write(f'{name}, {zero}, {zero}, {zero}, {zero}, {zero}\n')
                continue
            spec = SPEC_BY_FROOT.get(froot)
            if spec is None:
                continue
            table = tables[spec.name]
            if spec.name == 'cu_hxr':
                # cu_hxr shares the SC HXR lattice from BEGBSYH onward
                if ordinal < markers['cu_hxr']:
                    continue
                table = tables['sc_hxr_beam0']
                ordinal += hxr_offset
            if not table.valid[ordinal] or table.names[ordinal].startswith('FIXER'):
                continue
            name_ = name.removesuffix('?')
            if table.names[ordinal] != name_:
                print(f'WARNING.  ips.dump name does not match twiss.dat name: '
                      f'model={spec.name} twiss.dat name=>{table.names[ordinal]}< ips.dump name>{name}<')
            # NB: spacing (", " vs ",") kept identical to the legacy script's output.
            f.write(f'{name}, {table.dia[ordinal]:>10.6e}, {table.xid[ordinal]:>10.6e},'
                    f'{-table.xid[ordinal]:>10.6e}, {table.yid[ordinal]:>10.6e},'
                    f'{-table.yid[ordinal]:>10.6e}\n')


# --------------------------------------------------------------------------
def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('optics', nargs='?', default='TEST')
    ap.add_argument('--twiss-dir', type=Path, default=Path('.'))
    ap.add_argument('--ips', type=Path, default=Path('ips.dump'))
    ap.add_argument('--outdir', type=Path, default=Path('oracle_upload'))
    ap.add_argument('--model-out-dir', type=Path, default=Path('.'),
                    help='where the per-model BSC_<model>.txt files go')
    args = ap.parse_args(argv)

    ips = read_ips(args.ips)

    tables: dict[str, BscTable] = {}
    markers: dict[str, int] = {}
    for spec in MODELS:
        print(f'model: {spec.name}')
        lat = load_twiss(args.twiss_dir / f'{spec.name}_twiss.dat')
        if spec.name in ('cu_hxr', 'sc_hxr_beam0'):
            markers[spec.name] = lat.names.index('BEGBSYH')
        table = compute_model(spec, lat)
        write_model_file(args.model_out_dir / f'BSC_{spec.name}.txt', lat, table)
        tables[spec.name] = table

    for table in tables.values():
        share_max_per_name(table)

    write_collated(args.outdir / f'BSC-AD_ACCEL-{args.optics}.txt', ips, tables, markers)


if __name__ == '__main__':
    main()
