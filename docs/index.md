# lcls-lattice

The LCLS accelerator complex consists of multiple electron sources and multiple beam paths.

[**lcls-lattice**](http://github.com/slaclab/lcls-lattice) is a repository of lattice files for the various accelerators in the LCLS accelerator complex.  It also includes
scripts for optics codes for developing and analyzing those lattice files.

![Screenshot](img/lcls_complex.png)



## Design models

===  "Copper Linac"

    ### mad8

    ![mad8 Cu master xsif](mad/LCLS2cu_master.xsif)
    ![mad8 Cu master mad8](mad/LCLS2cu_master.mad8)

    ### Bmad
		![Bmad cu_hxr lattice](bmad/models/cu_hxr/cu_hxr.lat.bmad)
		![Bmad sc_hxr lattice](bmad/models/sc_hxr/sc_hxr.lat.bmad)
    
===  "Superconducting Linac"

    ![mad8 SC master xsif](mad/LCLS2sc_master.xsif)
    ![mad8 SC master mad8](mad/LCLS2sc_master.mad8)
    


## Simulation software
- [Bmad and Tao](https://github.com/bmad-sim) for charged particle beam dynamics.
- [LUME-Impact](https://christophermayes.github.io/lume-impact/) for running [Impact-T](https://github.com/impact-lbl/IMPACT-T) from Python.
- [tensorflow](https://www.tensorflow.org/) for neural network-based machine learning (ML) surrogate models. 
