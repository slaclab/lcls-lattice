#!/bin/env python3

from pytao import SubprocessTao, Tao

init_file = "tao.init"

tao = Tao(init_file=init_file, plot="mpl")
tao.plot(save="plots.pdf", backend="mpl")
