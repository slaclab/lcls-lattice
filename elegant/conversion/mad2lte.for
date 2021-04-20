      PROGRAM       MAD2LTE

C-----------------------------------------------------------------------
C
C Abs:  This program converts a MAD "SURVEY" TAPE-file into an ELEGANT
C       "LTE" file.  The following assumptions about the contents of
C       the MAD TAPE-file are made:
C
C       - supported MAD element keywords are: LCAV, SBEN, QUAD, SEXT,
C         OCTU, SOLE, MULT, DRIF, MARK, INST, PROF, WIRE, SLMO, BLMO,
C         IMON, HKIC, VKIC, MONI, HMON, VMON, ECOL, RCOL, SROT and MATR
C       - all element names are at most 8 characters long
C       - all LCAV TYPE names are at most 8 characters long
C       - EITHER all bend magnets have been split into two pieces OR
C         all bend magnets are NOT split at all
C       - MULT elements define only a single order multipole
C
C       During the translation process, all LCAV element names are
C       replaced by their respective TYPE names, thus reducing the
C       total number of defined RFCW elements in the ELEGANT "LTE"
C       file.  All INST, PROF, WIRE, SLMO, BLMO, and IMON elements will
C       be converted to MARKs.
C
C Use:  mad2lte <infile> <outfile>
C
C       - <infile> is the MAD SURVEY tape-file to be converted
C       - <outfile> is the ELEGANT lte-file to be created
C
C Auth: 19-MAR-2000, M. Woodley
C
C-----------------------------------------------------------------------
C
C Mod:
C       18-JUL-2019, M. Woodley
C          Set "N_KICKS=20" in all LCAV definitions when LSC=.TRUE.;
C          set "LSC=1" by default
C       23-MAR-2016, M. Woodley
C          Add "LSC=0" to LSCDRIF definitions 
C       09-NOV-2015, M. Woodley
C          Add support for linear space charge; add "LCLS1" flag
C       02-OCT-2015, M. Woodley
C          Everything can have nonzero length
C       12-AUG-2014, M. Woodley
C          Use MARKer TYPE attributes to define WATCH, CENTER, WAKE,
C          and SCATTER elements; use LCAV TYPE="RFDF" to define TCAVs;
C          set LCAV CELL_LENGTH equal to LCAV length
C       05-NOV-2013, M. Woodley
C          Add support for MATRIX elements
C       10-SEP-2013, M. Woodley
C          Use PC wakefield files; add ZWAKE and TRWAKE flags
C       19-JAN-2012, M. Woodley
C          Changes to CSR output per P. Emma (Jan 2011 email);
C          read each SBEN's FINT value from bunch length file;
C          convert MATR elements to DRIF (nonzero length)
C       21-JUL-2011, M. Woodley
C          Add support for HMON and VMON
C       22-APR-2004, M. Woodley
C          Add support for MATR
C       07-NOV-2003, M. Woodley
C          Increase keyword maximums from 512 to 1024; add array size
C          checks; skip SBENs with zero angle when doing CSR
C       30-APR-2002, M. Woodley
C          Changes to ISR and CSR options (unsplit bends if necessary,
C          define CSRDRIFTs); add support for SOLE; remove beam loading
C          in LCAVs
C       29-OCT-2000, M. Woodley
C          Add support for INST, PROF, SLMO, BLMO, and IMON
C       22-OCT-2000, M. Woodley
C          Add coherent synchrotron radiation (CSR) option; add
C          (optional) beam loading in LCAVs
C       18-SEP-2000, M. Woodley
C          Add support for MULT, ECOL, and RCOL elements; add support
C          for K1 and K2 in SBENs
C       07-AUG-2000, M. Woodley
C          Update wakefield file names per P. Emma
C       24-MAY-2000, M. Woodley
C          Create Windows NT version
C       29-APR-2000, M. Woodley
C          Change RFCW CELL_LENGTH from 0.036 to 0.035; use explicit
C          TILT values in LTE-file; remove special name translation
C          stuff
C       29-MAR-2000, M. Woodley
C          DIMAD outputs bend angles and edge angles in degrees ...
C          convert to radians
C       24-MAR-2000, M. Woodley
C          Add incoherent synchrotron radiation (ISR) option; add
C          special name translation for LCLS decks
C       23-MAR-2000, M. Woodley
C          Allow non-zero length for correctors; add sextupoles; add
C          handling for DIMAD tape-files; allow TILT for SBEN, QUAD,
C          and SEXT elements
C
C-----------------------------------------------------------------------

      IMPLICIT      NONE

C-----------------------------------------------------------------------
C
C     P A R A M E T E R     D E C L A R A T I O N S
C
C-----------------------------------------------------------------------

      REAL*8        ZERO,RADDEG,LBAND,SBAND,CBAND,XBAND
      INTEGER*4     MXLCAV,MXSBEN,MXQUAD,MXSEXT,MXOCTU,MXMULT,MXSOLE,
     >              MXDRIF,MXSROT,MXCOLL,MXHKIC,MXVKIC,MXMISC,
     >              MXELEM,MXCSRD,MXLN

      PARAMETER   ( ZERO = 0.D0,
     >              RADDEG = 0.017453292519943,
     >              LBAND = 1.3D9,
     >              SBAND = 2.856D9,
     >              CBAND = 3.9D9,
     >              XBAND = 4*SBAND,
     >              MXLCAV = 1024,
     >              MXSBEN = 1024,
     >              MXQUAD = 1024,
     >              MXSEXT = 1024,
     >              MXOCTU = 1024,
     >              MXMULT = 1024,
     >              MXSOLE = 1024,
     >              MXDRIF = 1024,
     >              MXSROT = 1024,
     >              MXCOLL = 1024,
     >              MXHKIC = 1024,
     >              MXVKIC = 1024,
     >              MXMISC = 4096,
     >              MXELEM = 65536,
     >              MXCSRD = 1024,
     >              MXLN = MXELEM/8 )

C-----------------------------------------------------------------------
C
C     S T R U C T U R E     D E C L A R A T I O N S
C
C-----------------------------------------------------------------------

      STRUCTURE   / LCAV_S /
        CHARACTER   TYPE*16
        REAL*8      FREQ
        REAL*8      CELL
        REAL*8      L
        REAL*8      VOLT
        REAL*8      PHI
        INTEGER*4   N
        LOGICAL*4   TCAV
      END STRUCTURE

      STRUCTURE   / SBEN_S /
        CHARACTER   NAME*16
        REAL*8      L
        REAL*8      ANG
        REAL*8      K1
        REAL*8      K2
        REAL*8      HGAP
        REAL*8      FINT
        REAL*8      TILT
        REAL*8      E1
        REAL*8      E2
        INTEGER*4   HALF    !0=not split,1=first half,2=second half
        INTEGER*4   TYPE    !1=SBEN,2=CSBEN,3=CSRCSBEN
        LOGICAL*4   DEF
        LOGICAL*4   UNSPLIT !has already been unsplit
      END STRUCTURE

      STRUCTURE   / QUAD_S /
        CHARACTER   NAME*16
        REAL*8      L
        REAL*8      K1
        REAL*8      TILT
      END STRUCTURE

      STRUCTURE   / SEXT_S /
        CHARACTER   NAME*16
        REAL*8      L
        REAL*8      K2
        REAL*8      TILT
      END STRUCTURE

      STRUCTURE   / OCTU_S /
        CHARACTER   NAME*16
        REAL*8      L
        REAL*8      K3
        REAL*8      TILT
      END STRUCTURE

      STRUCTURE   / MULT_S /
        CHARACTER   NAME*16
        REAL*8      L
        INTEGER*4   ORDER
        REAL*8      KNL
        REAL*8      TILT
      END STRUCTURE

      STRUCTURE   / SOLE_S /
        CHARACTER   NAME*16
        REAL*8      L
        REAL*8      KS
      END STRUCTURE

      STRUCTURE   / DRIF_S /
        CHARACTER   NAME*16
        REAL*8      L
      END STRUCTURE

      STRUCTURE   / SROT_S /
        CHARACTER   NAME*16
        REAL*8      ANG
      END STRUCTURE

      STRUCTURE   / COLL_S /
        CHARACTER   NAME*16
        REAL*8      L
        REAL*8      XSIZE
        REAL*8      YSIZE
        CHARACTER   TYPE
      END STRUCTURE

      STRUCTURE   / HKIC_S /
        CHARACTER   NAME*16
        REAL*8      L
      END STRUCTURE

      STRUCTURE   / VKIC_S /
        CHARACTER   NAME*16
        REAL*8      L
      END STRUCTURE

      STRUCTURE   / MISC_S /
        CHARACTER   NAME*16
        CHARACTER   KEYW*4
        CHARACTER   TYPE*16
        REAL*8      L
      END STRUCTURE

      STRUCTURE   / ELEM_S /
        CHARACTER   NAME*16
        CHARACTER   KEYW*4
        INTEGER*4   PTR
      END STRUCTURE

      STRUCTURE   / CSRD_S /
        CHARACTER   NAME*16
        REAL*8      L
        INTEGER*4   N
      END STRUCTURE

C-----------------------------------------------------------------------
C
C     V A R I A B L E     D E C L A R A T I O N S
C
C-----------------------------------------------------------------------

C                   Local variables

      REAL*8        SIGZ,L,P1,P2,P3,APER,ENERGY,P4,P5,P6,P7,P8,X,Y,Z,
     >              SUML,YAW,PITCH,ROLL,FINT,RHO,LCSR,FREQ

      INTEGER*4     NC,I,ICSD,NLCAV,NTCAV,NSBEN,NQUAD,NSEXT,NOCTU,
     >              NMULT,NSOLE,NDRIF,NSROT,NCOLL,NHKIC,NVKIC,NMISC,
     >              NMONI,NHMON,NVMON,NMATR,NINST,NPROF,NWIRE,NSLMO,
     >              NBLMO,NIMON,NMARK,NELEM,NCSRD,N,M,J,NL,NCL,NC1,
     >              NC2,NSTR

      INTEGER*4     NARGS,iargc

      LOGICAL*4     TEST,SPLIT,ISR,CSR,LSC,FIRST,INITIAL,EDGE1,LCLS1,
     >              DIMAD,NEW,TCAV,SPARSE,FOUND

      CHARACTER     INFILE*64,OUTFILE*64,MSG*64,TTYPE*8,TITLE*80,
     >              ZFILE*64,KEYW*4,NAME*16,TYPE*16,FDN*24,
     >              BEAMLINE(MXLN)*96,OUTSTR(16)*96,FMT*256,S*80

      RECORD      / LCAV_S /  LCAV(MXLCAV)
      RECORD      / SBEN_S /  SBEN(MXSBEN)
      RECORD      / QUAD_S /  QUAD(MXQUAD)
      RECORD      / SEXT_S /  SEXT(MXSEXT)
      RECORD      / OCTU_S /  OCTU(MXOCTU)
      RECORD      / MULT_S /  MULT(MXMULT)
      RECORD      / SOLE_S /  SOLE(MXSOLE)
      RECORD      / DRIF_S /  DRIF(MXDRIF)
      RECORD      / SROT_S /  SROT(MXSROT)
      RECORD      / COLL_S /  COLL(MXCOLL)
      RECORD      / HKIC_S /  HKIC(MXHKIC)
      RECORD      / VKIC_S /  VKIC(MXVKIC)
      RECORD      / MISC_S /  MISC(MXMISC)
      RECORD      / ELEM_S /  ELEM(MXELEM)
      RECORD      / CSRD_S /  CSRD(MXCSRD)

      DATA          TEST  / .FALSE. /,
     >              SPARSE  / .FALSE. /

C-----------------------------------------------------------------------
C
C     C O D E
C
C-----------------------------------------------------------------------

      IF (TEST) THEN
        INFILE = 'D:\LCLS2sc\20151001\elegant\LCLS2scS.tape'
        OUTFILE = 'D:\LCLS2sc\20151001\elegant\LCLS2scS.lte'
      ELSE
        NARGS = iargc()
        IF (NARGS.LT.2) THEN
          MSG = 'Specify input and output files on command line'
          WRITE (6,'(A)') TRIM(MSG)
          GOTO 999
        ELSE
          CALL GETARG (1,INFILE)
          CALL GETARG (2,OUTFILE)
        ENDIF
      ENDIF

      OPEN (50,FILE=INFILE,STATUS='OLD',READONLY,ERR=990)
      READ (50,'(8X,A8)',END=991,ERR=991) TTYPE
      IF (TTYPE.NE.'  SURVEY') THEN
        WRITE (6,'(1X,''Invalid TAPE file type ('',A,'')'')') TTYPE
        GOTO 999
      ENDIF
      READ (50,'(A)',END=991,ERR=991) TITLE

      WRITE (6,'(1X)')

      WRITE (6,'(''NC or SC RF? (0=NC,[1=SC]): '',$)')
      READ (5,'(Q,I)') NC,I
      IF (NC.EQ.0) THEN
        LCLS1 = .FALSE.
      ELSE
        LCLS1 = (I.EQ.0)
      ENDIF

      WRITE (6,'(''Are bends split? (0=no,[1=yes]): '',$)')
      READ (5,'(Q,I)') NC,I
      IF (NC.EQ.0) THEN
        SPLIT = .TRUE.
      ELSE
        SPLIT = (I.EQ.1)
      ENDIF

      WRITE (6,'(''Include ISR? ([0=no],1=yes): '',$)')
      READ (5,'(Q,I)') NC,I
      IF (NC.EQ.0) THEN
        ISR = .FALSE.
      ELSE
        ISR = (I.EQ.1)
      ENDIF

      WRITE (6,'(''Include CSR? ([0=no],1=yes): '',$)')
      READ (5,'(Q,I)') NC,I
      IF (NC.EQ.0) THEN
        CSR = .FALSE.
      ELSE
        CSR = (I.EQ.1)
      ENDIF
 
      WRITE (6,'(''Include LSC? ([0=no],1=yes): '',$)')
      READ (5,'(Q,I)') NC,I
      IF (NC.EQ.0) THEN
        LSC = .FALSE.
      ELSE
        LSC = (I.EQ.1)
      ENDIF
    
      WRITE (6,'(''Enter bunch length filename: '',$)')
      READ (5,'(A)') ZFILE
      OPEN (51,FILE=ZFILE,STATUS='OLD',READONLY,ERR=992)
      READ (51,*,END=993,ERR=993) ICSD

      WRITE (6,'(1X)')

      NLCAV = 0
      NTCAV = 0
      NSBEN = 0
      NQUAD = 0
      NSEXT = 0
      NOCTU = 0
      NMULT = 0
      NSOLE = 0
      NDRIF = 0
      NSROT = 0
      NCOLL = 0
      NHKIC = 0
      NVKIC = 0
      NMISC = 0
      NMONI = 0
      NHMON = 0
      NVMON = 0
      NMATR = 0
      NINST = 0
      NPROF = 0
      NWIRE = 0
      NSLMO = 0
      NBLMO = 0
      NIMON = 0
      NMARK = 0
      NELEM = 0

      FIRST = .TRUE.
      INITIAL = .TRUE.
      EDGE1 = .TRUE.

    1 READ (50,800,END=2,ERR=991)
     >  KEYW,NAME,L,P1,P2,P3,APER,TYPE,ENERGY,
     >  P4,P5,P6,P7,P8,FDN,
     >  X,Y,Z,SUML,
     >  YAW,PITCH,ROLL

C     DIMAD tape files have the NAME field shifted to the right by 8
C     columns and shortened to 8 columns

      IF (FIRST) THEN
        DIMAD = (NAME(1:8).EQ.'        ')
        FIRST = .FALSE.
      ENDIF
      IF (DIMAD) THEN
        NAME = NAME(9:16)
      ENDIF

      IF (INITIAL) THEN

C       skip the INITIAL data (MAD only)

        INITIAL = .FALSE.
        IF (.NOT.DIMAD) GOTO 1
      ENDIF

      IF (KEYW.EQ.'LCAV') THEN

C       MAD LCAVs will be converted to ELEGANT RFCWs; replace element
C       NAME with element TYPE in the ELEGANT beamline; special
C       handling for TYPE="RFDF"

        NEW = .TRUE.
        TCAV = .FALSE.
        IF (TYPE.EQ.'RFDF            ') THEN
          TCAV = .TRUE.
          NTCAV = NTCAV+1
          TYPE = NAME
        ENDIF
        IF (NLCAV.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NLCAV))
            I = I+1
            IF (TYPE.EQ.(LCAV(I).TYPE)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NLCAV.EQ.MXLCAV) GOTO 995
          NLCAV = NLCAV+1
          I = NLCAV
          LCAV(I).TYPE = TYPE
          FREQ = 1.D6*P5           !Hz
          IF (FREQ.EQ.SBAND) THEN
            LCAV(I).CELL = 3.5D-2  !m
          ELSEIF (FREQ.EQ.XBAND) THEN
            LCAV(I).CELL = 8.75D-3 !m
          ELSEIF (FREQ.EQ.LBAND) THEN
            LCAV(I).CELL = L       !m
          ELSEIF (FREQ.EQ.CBAND) THEN
            LCAV(I).CELL = L       !m
          ELSE
            LCAV(I).CELL = L       !m
          ENDIF
          LCAV(I).FREQ = FREQ      !Hz
          LCAV(I).L = L            !m
          LCAV(I).VOLT = 1.D6*P6   !eV
          LCAV(I).PHI = 360.D0*P7  !degree
          LCAV(I).N = 1
          LCAV(I).TCAV = TCAV
        ELSE
          LCAV(I).N = LCAV(I).N+1
        ENDIF
        NAME = TYPE

      ELSE IF (KEYW.EQ.'SBEN') THEN
        NEW = .TRUE.
        IF (NSBEN.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NSBEN))
            I = I+1
            IF (NAME.EQ.(SBEN(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NSBEN.EQ.MXSBEN) GOTO 995
          NSBEN = NSBEN+1
          I = NSBEN
          SBEN(I).NAME = NAME
          SBEN(I).L = L         !m
          SBEN(I).ANG = P1      !radian
          SBEN(I).K1 = P2       !1/m**2
          SBEN(I).K2 = P3       !1/m**3
          SBEN(I).HGAP = APER   !m
          SBEN(I).FINT = -1.D0  !not specified
          IF (SPLIT) THEN
            IF (EDGE1) THEN
              SBEN(I).E1 = P5   !radian
              SBEN(I).E2 = ZERO !radian
              SBEN(I).HALF = 1
            ELSE
              SBEN(I).E1 = ZERO !radian
              SBEN(I).E2 = P6   !radian
              SBEN(I).HALF = 2
            ENDIF
            EDGE1 = (.NOT.EDGE1)
          ELSE
            SBEN(I).E1 = P5     !radian
            SBEN(I).E2 = P6     !radian
            SBEN(I).HALF = 0
          ENDIF
          SBEN(I).TILT = P4     !radian
          IF (CSR) THEN
            SBEN(I).TYPE = 3
          ELSE
            IF (ISR) THEN
              SBEN(I).TYPE = 2
            ELSE
              SBEN(I).TYPE = 1
            ENDIF
          ENDIF
          SBEN(I).DEF = .TRUE.
          SBEN(I).UNSPLIT = .FALSE.
          IF (DIMAD) THEN

C           convert DIMAD bend and edge angles from degrees

            SBEN(I).ANG = SBEN(I).ANG*RADDEG
            SBEN(I).E1 = SBEN(I).E1*RADDEG
            SBEN(I).E2 = SBEN(I).E2*RADDEG
          ENDIF
        ENDIF

      ELSE IF (KEYW.EQ.'QUAD') THEN
        NEW = .TRUE.
        IF (NQUAD.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NQUAD))
            I = I+1
            IF (NAME.EQ.(QUAD(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NQUAD.EQ.MXQUAD) GOTO 995
          NQUAD = NQUAD+1
          I = NQUAD
          QUAD(I).NAME = NAME
          QUAD(I).L = L        !m
          QUAD(I).K1 = P2      !1/m**2
          QUAD(I).TILT = P4    !radian
        ENDIF

      ELSE IF (KEYW.EQ.'SEXT') THEN
        NEW = .TRUE.
        IF (NSEXT.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NSEXT))
            I = I+1
            IF (NAME.EQ.(SEXT(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NSEXT.EQ.MXSEXT) GOTO 995
          NSEXT = NSEXT+1
          I = NSEXT
          SEXT(I).NAME = NAME
          SEXT(I).L = L        !m
          SEXT(I).K2 = P3      !1/m**3
          SEXT(I).TILT = P4    !radian
        ENDIF

      ELSE IF (KEYW.EQ.'OCTU') THEN
        NEW = .TRUE.
        IF (NOCTU.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NOCTU))
            I = I+1
            IF (NAME.EQ.(OCTU(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NOCTU.EQ.MXOCTU) GOTO 995
          NOCTU = NOCTU+1
          I = NOCTU
          OCTU(I).NAME = NAME
          OCTU(I).L = L        !m
          OCTU(I).K3 = P5      !1/m**4
          OCTU(I).TILT = P4    !radian
        ENDIF

      ELSE IF (KEYW.EQ.'MULT') THEN
        NEW = .TRUE.
        IF (NMULT.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NMULT))
            I = I+1
            IF (NAME.EQ.(MULT(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NMULT.EQ.MXMULT) GOTO 995
          NMULT = NMULT+1
          I = NMULT
          MULT(I).NAME = NAME
          MULT(I).L = L         !m
          IF (P1.NE.ZERO) THEN
            MULT(I).ORDER = 0   !dipole
            MULT(I).KNL = P1    !radian
            MULT(I).TILT = P4   !radian
          ELSE IF (P2.NE.ZERO) THEN
            MULT(I).ORDER = 1   !quadrupole
            MULT(I).KNL = P2    !1/m
            MULT(I).TILT = P6   !radian
          ELSE IF (P3.NE.ZERO) THEN
            MULT(I).ORDER = 2   !sextupole
            MULT(I).KNL = P3    !1/m**2
            MULT(I).TILT = P7   !radian
          ELSE IF (P5.NE.ZERO) THEN
            MULT(I).ORDER = 3   !octupole
            MULT(I).KNL = P5    !1/m**3
            MULT(I).TILT = P8   !radian
          ELSE

C           default to 0th order, zero strength (as a placeholder)

            MULT(I).ORDER = 0   !dipole
            MULT(I).KNL = ZERO  !radian
            MULT(I).TILT = ZERO !radian
          ENDIF
        ENDIF

      ELSE IF (KEYW.EQ.'SOLE') THEN
        NEW = .TRUE.
        IF (NSOLE.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NSOLE))
            I = I+1
            IF (NAME.EQ.(SOLE(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NSOLE.EQ.MXSOLE) GOTO 995
          NSOLE = NSOLE+1
          I = NSOLE
          SOLE(I).NAME = NAME
          SOLE(I).L = L        !m
          SOLE(I).KS = P5      !1/m
        ENDIF

      ELSE IF (KEYW.EQ.'DRIF') THEN
        NEW = .TRUE.
        IF (NDRIF.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NDRIF))
            I = I+1
            IF (NAME.EQ.(DRIF(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NDRIF.EQ.MXDRIF) GOTO 995
          NDRIF = NDRIF+1
          I = NDRIF
          DRIF(I).NAME = NAME
          DRIF(I).L = L        !m
        ENDIF

      ELSE IF (KEYW.EQ.'SROT') THEN
        NEW = .TRUE.
        IF (NSROT.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NSROT))
            I = I+1
            IF (NAME.EQ.(SROT(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NSROT.EQ.MXSROT) GOTO 995
          NSROT = NSROT+1
          I = NSROT
          SROT(I).NAME = NAME
          SROT(I).ANG = P5     !radian
        ENDIF

      ELSE IF ((KEYW.EQ.'ECOL').OR.
     >         (KEYW.EQ.'RCOL')) THEN
        IF (SPARSE) GOTO 1
        NEW = .TRUE.
        IF (NCOLL.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NCOLL))
            I = I+1
            IF (NAME.EQ.(COLL(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NCOLL.EQ.MXCOLL) THEN
            KEYW = 'COLL'
            GOTO 995
          ENDIF
          NCOLL = NCOLL+1
          I = NCOLL
          COLL(I).NAME = NAME
          COLL(I).L = L            !m
          COLL(I).XSIZE = P4       !m
          COLL(I).YSIZE = P5       !m
          COLL(I).TYPE = KEYW(1:1)
        ENDIF
        KEYW = 'COLL'

      ELSE IF (KEYW.EQ.'HKIC') THEN
        IF (SPARSE) GOTO 1
        NEW = .TRUE.
        IF (NHKIC.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NHKIC))
            I = I+1
            IF (NAME.EQ.(HKIC(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NHKIC.EQ.MXHKIC) GOTO 995
          NHKIC = NHKIC+1
          I = NHKIC
          HKIC(I).NAME = NAME
          HKIC(I).L = L        !m
        ENDIF

      ELSE IF (KEYW.EQ.'VKIC') THEN
        IF (SPARSE) GOTO 1
        NEW = .TRUE.
        IF (NVKIC.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NVKIC))
            I = I+1
            IF (NAME.EQ.(VKIC(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NVKIC.EQ.MXVKIC) GOTO 995
          NVKIC = NVKIC+1
          I = NVKIC
          VKIC(I).NAME = NAME
          VKIC(I).L = L        !m
        ENDIF

      ELSE IF ((KEYW.EQ.'MONI').OR.
     >         (KEYW.EQ.'HMON').OR.
     >         (KEYW.EQ.'VMON').OR.
     >         (KEYW.EQ.'MATR').OR.
     >         (KEYW.EQ.'INST').OR.
     >         (KEYW.EQ.'PROF').OR.
     >         (KEYW.EQ.'WIRE').OR.
     >         (KEYW.EQ.'SLMO').OR.
     >         (KEYW.EQ.'BLMO').OR.
     >         (KEYW.EQ.'IMON').OR.
     >         (KEYW.EQ.'MARK')) THEN
        NEW = .TRUE.
        IF (NMISC.GT.0) THEN
          I = 0
          DO WHILE (NEW.AND.(I.LT.NMISC))
            I = I+1
            IF (NAME.EQ.(MISC(I).NAME)) NEW = .FALSE.
          ENDDO
        ENDIF
        IF (NEW) THEN
          IF (NMISC.EQ.MXMISC) THEN
            GOTO 995
          ENDIF
          NMISC = NMISC+1
          I = NMISC
          MISC(I).NAME = NAME
          MISC(I).KEYW = KEYW
          MISC(I).TYPE = TYPE
          MISC(I).L = L       !m
          IF (KEYW.EQ.'MONI') NMONI = NMONI+1
          IF (KEYW.EQ.'HMON') NHMON = NHMON+1
          IF (KEYW.EQ.'VMON') NVMON = NVMON+1
          IF (KEYW.EQ.'MATR') NMATR = NMATR+1
          IF (KEYW.EQ.'INST') NINST = NINST+1
          IF (KEYW.EQ.'PROF') NPROF = NPROF+1
          IF (KEYW.EQ.'WIRE') NWIRE = NWIRE+1
          IF (KEYW.EQ.'SLMO') NSLMO = NSLMO+1
          IF (KEYW.EQ.'BLMO') NBLMO = NBLMO+1
          IF (KEYW.EQ.'IMON') NIMON = NIMON+1
          IF (KEYW.EQ.'MARK') NMARK = NMARK+1
        ENDIF

      ELSE
        WRITE (6,'(1X,''Invalid MAD keyword ('',A,'')'')') KEYW
        GOTO 999
      ENDIF

C     add an element name to the beamline list

      IF (NELEM.EQ.MXELEM) THEN
        WRITE (6,'(1X,''Too many elements'')')
        GOTO 999
      ENDIF
      NELEM = NELEM+1
      ELEM(NELEM).NAME = NAME
      ELEM(NELEM).KEYW = KEYW
      ELEM(NELEM).PTR = I

      GOTO 1

    2 CONTINUE

C     handle CSR (unsplit bends if necessary; define CSRDRIFs)

      IF (CSR) THEN
        NCSRD = 0
        N = 0
        DO WHILE (N.LT.NELEM)
          N = N+1
          IF ((ELEM(N).KEYW).EQ.'SBEN') THEN
            I = ELEM(N).PTR
            READ (51,*,END=993,ERR=993) NAME,SIGZ,FINT
            ELEM(N).NAME = NAME
            SBEN(I).NAME = NAME
            SBEN(I).FINT = FINT
            IF (SPLIT) THEN
              M = N
              FOUND = .FALSE.
              DO WHILE (.NOT.FOUND)
                M = M+1
                IF ((ELEM(M).KEYW).EQ.'SBEN') THEN
                  J = ELEM(M).PTR
                  FOUND = .TRUE.
                ENDIF
                ELEM(M).PTR = 0
              ENDDO
              IF (.NOT.(SBEN(I).UNSPLIT)) THEN
                SBEN(I).L = SBEN(I).L+SBEN(J).L
                SBEN(I).ANG = SBEN(I).ANG+SBEN(J).ANG
                SBEN(I).E2 = SBEN(J).E2
                SBEN(I).HALF = 0
                SBEN(I).UNSPLIT = .TRUE.
                SBEN(J).DEF = .FALSE.
              ENDIF
              N = M
            ENDIF
            IF ((SBEN(I).ANG).EQ.ZERO) GOTO 3
            RHO = SBEN(I).L/SBEN(I).ANG
            LCSR = (24.D0*SIGZ*RHO**2)**(1.D0/3.D0)
            M = N
            FOUND = .FALSE.
            SUML = ZERO
            DO WHILE ((M.LT.NELEM).AND.(.NOT.FOUND))
              M = M+1
              IF ((ELEM(M).KEYW).EQ.'DRIF') THEN
                J = ELEM(M).PTR
                IF ((DRIF(J).L).GT.ZERO) THEN
                  IF (NCSRD.EQ.MXCSRD) THEN
                    KEYW = 'CSRD'
                    GOTO 995
                  ENDIF
                  NCSRD = NCSRD+1
                  I = NCSRD
                  WRITE (CSRD(I).NAME,'(''CS'',I2.2,I4.4)') ICSD,I
                  CSRD(I).L = DRIF(J).L
                  CSRD(I).N = CEILING(5.D0*CSRD(I).L/LCSR)
                  ELEM(M).NAME = CSRD(I).NAME
                  ELEM(M).KEYW = 'CSRD'
                  ELEM(M).PTR = I
                  SUML = SUML+CSRD(I).L
                  IF (SUML.GE.(5.D0*LCSR)) THEN
                    FOUND = .TRUE.
                    N = M
                  ENDIF
                ENDIF
              ELSE IF ((ELEM(M).KEYW).EQ.'SBEN') THEN
                FOUND = .TRUE.
                N = M-1
              ENDIF
            ENDDO
    3       CONTINUE
          ENDIF
        ENDDO
      ENDIF

C     construct beamline strings

      NL = 1
      NCL = 0
      WRITE (BEAMLINE(NL),'(96X)')
      DO N = 1,NELEM
        IF ((ELEM(N).PTR).NE.0) THEN
          NC = LEN_TRIM(ELEM(N).NAME)
          IF ((NCL+NC+1).GT.88) THEN
            NL = NL+1
            NCL = 0
            WRITE (BEAMLINE(NL),'(96X)')
          ENDIF
          NC1 = NCL+1
          NC2 = NCL+NC+1
          BEAMLINE(NL)(NC1:NC2) = ELEM(N).NAME(1:NC)//','
          NCL = NC2
        ENDIF
      ENDDO

C     write the ELEGANT lte-file

      OPEN (60,FILE=OUTFILE,STATUS='UNKNOWN',CARRIAGECONTROL='LIST',
     >  ERR=994)

      NC = LEN_TRIM(TITLE)
      S = ' '
      DO I = 1,NC
        S(I:I) = '='
      ENDDO
      IF (LCLS1) THEN
        FMT = '(''! '',A/''! '',A//''C: CHARGE,TOTAL= 0.25E-09'')'
      ELSE
        FMT = '(''! '',A/''! '',A//''C: CHARGE,TOTAL= 100.0E-12'')'
      ENDIF
      WRITE (60,FMT) TITLE(1:NC),S(1:NC)

C     element definitions

      IF (NLCAV.GT.NTCAV) THEN
        WRITE (60,'(1X/''!RFCW:''/''!===='')')
        DO I = 1,NLCAV
          IF (LCAV(I).TCAV) GOTO 4
          TCAV = LCAV(I).TCAV
          FREQ = LCAV(I).FREQ
          FMT = '(A,'': RFCW,FREQ='',1PE16.9,'',L='',1PE16.9)'
          WRITE (OUTSTR(1),FMT) LCAV(I).TYPE,FREQ,LCAV(I).L
          FMT = '(''VOLT="'',1PE16.9,'' 1 *"'''//
     >          ','',PHASE="'',1PE16.9,'' 90 +"'')'
          WRITE (OUTSTR(2),FMT) LCAV(I).VOLT,LCAV(I).PHI
          FMT = '(''CHANGE_P0=1,END1_FOCUS=1,END2_FOCUS=1'''//
     >          ','',CELL_LENGTH='',1PE16.9)'
          WRITE (OUTSTR(3),FMT) LCAV(I).CELL
          IF (FREQ.EQ.SBAND) THEN
            IF (LCLS1) THEN
              OUTSTR(4) = 'ZWAKEFILE="Sz_1um_75mm.sdds"'
              OUTSTR(5) = 'TRWAKEFILE="Sx_1um_75mm.sdds"'
            ELSE
              OUTSTR(4) = 'ZWAKEFILE="Sz_p5um_10mm.sdds"'
              OUTSTR(5) = 'TRWAKEFILE="Sx_p5um_10mm.sdds"'
            ENDIF
          ELSE IF (FREQ.EQ.XBAND) THEN
            IF (LCLS1) THEN
              OUTSTR(4) = 'ZWAKEFILE="Sz_10um_75mm_xband.sdds"'
              OUTSTR(5) = 'TRWAKEFILE="Sx_50um_75mm_xband.sdds"'
            ELSE
              OUTSTR(4) = 'ZWAKEFILE="Sz_20um_25mm_xband.sdds"'
              OUTSTR(5) = 'TRWAKEFILE="Sx_50um_10mm_xband.sdds"'
            ENDIF
          ELSE IF (FREQ.EQ.LBAND) THEN
            OUTSTR(4) = 'ZWAKEFILE='//
     >        '"zWake_1.3GHz_OneCavity_dz2um_TESLA2003-09.sdds"'
            OUTSTR(5) = 'TRWAKEFILE='//
     >        '"xWake_1.3GHz_OneCavity_dz2um_TESLA2003-09.sdds"'
          ELSE IF (FREQ.EQ.CBAND) THEN
            OUTSTR(4) = 'ZWAKEFILE='//
     >        '"zWake_3.9GHz_OneCavity_dz2um_TESLA2004-01.sdds"'
            OUTSTR(5) = 'TRWAKEFILE='//
     >        '"xWake_3.9GHz_OneCavity_dz2um_TESLA2004-01.sdds"'
          ELSE
            OUTSTR(4) = 'ZWAKEFILE="undefined"'
            OUTSTR(5) = 'TRWAKEFILE="undefined"'
          ENDIF
          OUTSTR(6) =
     >      'TCOLUMN="t",WXCOLUMN="W",WYCOLUMN="W",WZCOLUMN="W"'
          IF (LSC) THEN
            OUTSTR(7) = 'INTERPOLATE=1,N_KICKS=20,SMOOTHING=1,'//
     >        'ZWAKE=1,TRWAKE=1,LSC=1'
            OUTSTR(8) =
     >        'LSC_BINS=500,LSC_HIGH_FREQUENCY_CUTOFF0=0.255,'//
     >        'LSC_HIGH_FREQUENCY_CUTOFF1=0.255'
            NSTR = 8
          ELSE
            OUTSTR(7) = 'INTERPOLATE=1,N_KICKS=20,SMOOTHING=1,'//
     >        'ZWAKE=1,TRWAKE=1'
            NSTR = 7
          ENDIF
          CALL WRELE (OUTSTR,NSTR)
    4     CONTINUE
        ENDDO
      ENDIF

      IF (NTCAV.GT.0) THEN
        WRITE (60,'(1X/''!RFDF:''/''!===='')')
        DO I = 1,NLCAV
          IF (.NOT.(LCAV(I).TCAV)) GOTO 5
          FMT = '(A,'': RFDF,FREQUENCY='',1PE16.9,'',L='',1PE16.9)'
          WRITE (OUTSTR(1),FMT) LCAV(I).TYPE,LCAV(I).FREQ,LCAV(I).L
          FMT = '(''VOLTAGE="'',1PE16.9,'' 1 *",PHASE=90'')'
          WRITE (OUTSTR(2),FMT) LCAV(I).VOLT
          NSTR = 2
          CALL WRELE (OUTSTR,NSTR)
    5     CONTINUE
        ENDDO
      ENDIF
            
      IF (NSBEN.GT.0) THEN
        IF (CSR) THEN
          WRITE (60,'(1X/''!CSRCSBEN:''/''!========'')')
        ELSE
          IF (ISR) THEN
            WRITE (60,'(1X/''!CSBEN:''/''!====='')')
          ELSE
            WRITE (60,'(1X/''!SBEN:''/''!===='')')
          ENDIF
        ENDIF
        DO I = 1,NSBEN
          IF (SBEN(I).DEF) THEN
            FMT = '(A,'': '',A,'',L='',1PE16.9)'
            IF ((SBEN(I).TYPE).EQ.2) THEN
              WRITE (OUTSTR(1),FMT) SBEN(I).NAME,'CSBEN',SBEN(I).L
            ELSE IF ((SBEN(I).TYPE).EQ.3) THEN
              WRITE (OUTSTR(1),FMT) SBEN(I).NAME,'CSRCSBEN',SBEN(I).L
            ELSE
              WRITE (OUTSTR(1),FMT) SBEN(I).NAME,'SBEN',SBEN(I).L
            ENDIF
            FMT = '(''ANGLE='',1PE16.9)'
            WRITE (OUTSTR(2),FMT) SBEN(I).ANG
            IF ((SBEN(I).HALF).EQ.1) THEN
              FMT = '(''EDGE1_EFFECTS=1,E1='',1PE16.9)'
              WRITE (OUTSTR(3),FMT) SBEN(I).E1
              WRITE (OUTSTR(4),'(''EDGE2_EFFECTS=0'')')
            ELSE IF ((SBEN(I).HALF).EQ.2) THEN
              WRITE (OUTSTR(3),'(''EDGE1_EFFECTS=0'')')
              FMT = '(''EDGE2_EFFECTS=1,E2='',1PE16.9)'
              WRITE (OUTSTR(4),FMT) SBEN(I).E2
            ELSE
              FMT = '(''EDGE1_EFFECTS=1,E1='',1PE16.9)'
              WRITE (OUTSTR(3),FMT) SBEN(I).E1
              FMT = '(''EDGE2_EFFECTS=1,E2='',1PE16.9)'
              WRITE (OUTSTR(4),FMT) SBEN(I).E2
            ENDIF
            NSTR = 4
            IF (((SBEN(I).HGAP).NE.ZERO).AND.
     >          ((SBEN(I).FINT).NE.-1.D0)) THEN
              NSTR = NSTR+1
              FMT = '(''HGAP='',1PE16.9,'',FINT='',1PE16.9)'
              WRITE (OUTSTR(NSTR),FMT) SBEN(I).HGAP,SBEN(I).FINT
            ELSE IF ((SBEN(I).HGAP).NE.ZERO) THEN
              NSTR = NSTR+1
              FMT = '(''HGAP='',1PE16.9)'
              WRITE (OUTSTR(NSTR),FMT) SBEN(I).HGAP
            ELSE IF ((SBEN(I).FINT).NE.-1.D0) THEN
              NSTR = NSTR+1
              FMT = '(''FINT='',1PE16.9)'
              WRITE (OUTSTR(NSTR),FMT) SBEN(I).FINT
            ENDIF
            IF ((SBEN(I).K1).NE.ZERO) THEN
              NSTR = NSTR+1
              FMT = '(''K1='',1PE16.9)'
              WRITE (OUTSTR(NSTR),FMT) SBEN(I).K1
            ENDIF
            IF ((SBEN(I).K2).NE.ZERO) THEN
              NSTR = NSTR+1
              FMT = '(''K2='',1PE16.9)'
              WRITE (OUTSTR(NSTR),FMT) SBEN(I).K2
            ENDIF
            IF ((SBEN(I).TILT).NE.ZERO) THEN
              NSTR = NSTR+1
              FMT = '(''TILT='',1PE16.9)'
              WRITE (OUTSTR(NSTR),FMT) SBEN(I).TILT
            ENDIF
            IF (CSR) THEN
              NSTR = NSTR+1
              OUTSTR(NSTR) =
     >          'SG_HALFWIDTH=2,SG_ORDER=1,STEADY_STATE=0,BINS=200'
              NSTR = NSTR+1
              OUTSTR(NSTR) =
     >          'N_KICKS=20,INTEGRATION_ORDER=4,ISR=1,CSR=1'
            ELSE IF (ISR) THEN
              NSTR = NSTR+1
              OUTSTR(NSTR) = 'N_KICKS=10,INTEGRATION_ORDER=4,ISR=1'
            ENDIF
            CALL WRELE (OUTSTR,NSTR)
          ENDIF
        ENDDO
      ENDIF

      IF (NQUAD.GT.0) THEN
        WRITE (60,'(1X/''!QUAD:''/''!===='')')
        FMT = '(A,'': QUAD,L='',1PE16.9,'',K1='',1PE16.9,'//
     >    ':,'',TILT='',1PE16.9)'
        DO I = 1,NQUAD
          IF ((QUAD(I).TILT).NE.ZERO) THEN
            WRITE (60,FMT) QUAD(I).NAME,QUAD(I).L,QUAD(I).K1,
     >        QUAD(I).TILT
          ELSE
            WRITE (60,FMT) QUAD(I).NAME,QUAD(I).L,QUAD(I).K1
          ENDIF
        ENDDO
      ENDIF

      IF (NSEXT.GT.0) THEN
        WRITE (60,'(1X/''!SEXT:''/''!===='')')
        FMT = '(A,'': SEXT,L='',1PE16.9,'',K2='',1PE16.9,'//
     >    ':,'',TILT='',1PE16.9)'
        DO I = 1,NSEXT
          IF ((SEXT(I).TILT).NE.ZERO) THEN
            WRITE (60,FMT) SEXT(I).NAME,SEXT(I).L,SEXT(I).K2,
     >        SEXT(I).TILT
          ELSE
            WRITE (60,FMT) SEXT(I).NAME,SEXT(I).L,SEXT(I).K2
          ENDIF
        ENDDO
      ENDIF

      IF (NOCTU.GT.0) THEN
        WRITE (60,'(1X/''!OCTU:''/''!===='')')
        FMT = '(A,'': OCTU,L='',1PE16.9,'',K3='',1PE16.9,'//
     >    ':,'',TILT='',1PE16.9)'
        DO I = 1,NOCTU
          IF ((OCTU(I).TILT).NE.ZERO) THEN
            WRITE (60,FMT) OCTU(I).NAME,OCTU(I).L,OCTU(I).K3,
     >        OCTU(I).TILT
          ELSE
            WRITE (60,FMT) OCTU(I).NAME,OCTU(I).L,OCTU(I).K3
          ENDIF
        ENDDO
      ENDIF

      IF (NMULT.GT.0) THEN
        WRITE (60,'(1X/''!MULT:''/''!===='')')
        FMT = '(A,'': MULT,L='',1PE16.9,'',ORDER='',I1,'//
     >    ''',KNL='',1PE16.9,:,'',TILT='',1PE16.9)'
        DO I = 1,NMULT
          IF ((MULT(I).TILT).NE.ZERO) THEN
            WRITE (60,FMT) MULT(I).NAME,MULT(I).L,MULT(I).ORDER,
     >        MULT(I).KNL,MULT(I).TILT
          ELSE
            WRITE (60,FMT) MULT(I).NAME,MULT(I).L,MULT(I).ORDER,
     >        MULT(I).KNL
          ENDIF
        ENDDO
      ENDIF

      IF (NSOLE.GT.0) THEN
        WRITE (60,'(1X/''!SOLE:''/''!===='')')
        FMT = '(A,'': SOLE,L='',1PE16.9,'',KS='',1PE16.9)'
        DO I = 1,NSOLE
          WRITE (60,FMT) SOLE(I).NAME,SOLE(I).L,SOLE(I).KS
        ENDDO
      ENDIF

      IF (NDRIF.GT.0) THEN
        IF (LSC) THEN
          WRITE (60,'(1X/''!LSCDRIF:''/''!======='')')
          FMT = '(A,'': LSCDRIF,L='',1PE16.9,'//
     >      ''',INTERPOLATE=1,SMOOTHING=1,&''/'//
     >      '''  BINS=500,HIGH_FREQUENCY_CUTOFF0=0.255,'//
     >      'HIGH_FREQUENCY_CUTOFF1=0.255,LSC=1'')'
        ELSE
          WRITE (60,'(1X/''!DRIF:''/''!===='')')
          FMT = '(A,'': DRIF,L='',1PE16.9)'
        ENDIF
        DO I = 1,NDRIF
          WRITE (60,FMT) DRIF(I).NAME,DRIF(I).L
        ENDDO
      ENDIF

      IF (NCSRD.GT.0) THEN
        WRITE (60,'(1X/''!CSRDRIF:''/''!======='')')
        FMT = '(A,'': CSRDRIF,L='',1PE16.9,'',USE_STUPAKOV=1,'//
     >    'N_KICKS='',I3,'',CSR=1'')'
        DO I = 1,NCSRD
          WRITE (60,FMT) CSRD(I).NAME,CSRD(I).L,CSRD(I).N
        ENDDO
      ENDIF

      IF (NSROT.GT.0) THEN
        WRITE (60,'(1X/''!ROTA:''/''!===='')')
        FMT = '(A,'': ROTA,TILT='',1PE16.9)'
        DO I = 1,NSROT
          WRITE (60,FMT) SROT(I).NAME,SROT(I).ANG
        ENDDO
      ENDIF

      IF (NCOLL.GT.0) THEN
        WRITE (60,'(1X/''!COLL:''/''!===='')')
        FMT = '(A,'': '',A1,''COL,L='',1PE16.9,'//
     >    ''',X_MAX='',1PE16.9,'',Y_MAX='',1PE16.9)'
        DO I = 1,NCOLL
          WRITE (60,FMT) COLL(I).NAME,COLL(I).TYPE,COLL(I).L,
     >      COLL(I).XSIZE,COLL(I).YSIZE
        ENDDO
      ENDIF

      IF (NHKIC.GT.0) THEN
        WRITE (60,'(1X/''!HKIC:''/''!===='')')
        FMT = '(A,'': HKIC'',:,'',L='',1PE16.9)'
        DO I = 1,NHKIC
          IF ((HKIC(I).L).NE.ZERO) THEN
            WRITE (60,FMT) HKIC(I).NAME,HKIC(I).L
          ELSE
            WRITE (60,FMT) HKIC(I).NAME
          ENDIF
        ENDDO
      ENDIF

      IF (NVKIC.GT.0) THEN
        WRITE (60,'(1X/''!VKIC:''/''!===='')')
        FMT = '(A,'': VKIC'',:,'',L='',1PE16.9)'
        DO I = 1,NVKIC
          IF ((VKIC(I).L).NE.ZERO) THEN
            WRITE (60,FMT) VKIC(I).NAME,VKIC(I).L
          ELSE
            WRITE (60,FMT) VKIC(I).NAME
          ENDIF
        ENDDO
      ENDIF

C     LCAV
C     TCAVs
C     SBEN/CSBEN/CSRCSBEN
C     QUAD
C     SEXT
C     OCTU
C     MULT
C     SOLE
C     DRIF
C     CSDRIF
C     ROTA
C     RCOL/ECOL
C     HKIC
C     VKIC
C     misc: MONI/HMON/VMON
C     misc: MATR
C     misc: INST,PROF,WIRE,SLMO,BLMO,IMON -> DRIF, L=..., GROUP="..."
C     misc: MARK

      IF (NMONI.GT.0) THEN
        WRITE (60,'(1X/''!MONI:''/''!===='')')
        FMT = '(A,'': MONI'',:,'',L='',1PE16.9)'
        DO I = 1,NMISC
          IF ((MISC(I).KEYW).EQ.'MONI') THEN
            IF ((MISC(I).L).GT.ZERO) THEN
              WRITE (60,FMT) MISC(I).NAME,MISC(I).L
            ELSE
              WRITE (60,FMT) MISC(I).NAME
            ENDIF
          ENDIF
        ENDDO
      ENDIF

      IF (NHMON.GT.0) THEN
        WRITE (60,'(1X/''!HMON:''/''!===='')')
        FMT = '(A,'': HMON'',:,'',L='',1PE16.9)'
        DO I = 1,NMISC
          IF ((MISC(I).KEYW).EQ.'HMON') THEN
            IF ((MISC(I).L).GT.ZERO) THEN
              WRITE (60,FMT) MISC(I).NAME,MISC(I).L
            ELSE
              WRITE (60,FMT) MISC(I).NAME
            ENDIF
          ENDIF
        ENDDO
      ENDIF

      IF (NVMON.GT.0) THEN
        WRITE (60,'(1X/''!VMON:''/''!===='')')
        FMT = '(A,'': VMON'',:,'',L='',1PE16.9)'
        DO I = 1,NMISC
          IF ((MISC(I).KEYW).EQ.'VMON') THEN
            IF ((MISC(I).L).GT.ZERO) THEN
              WRITE (60,FMT) MISC(I).NAME,MISC(I).L
            ELSE
              WRITE (60,FMT) MISC(I).NAME
            ENDIF
          ENDIF
        ENDDO
      ENDIF

      IF (NMATR.GT.0) THEN
        WRITE (60,'(1X/''!MATR:''/''!===='')')
        FMT = '(A,'': MATR,L='',1PE16.9,'',ORDER=1,'//
     >    'FILENAME="'',A,''.rmat"'')'
        DO I = 1,NMISC
          IF ((MISC(I).KEYW).EQ.'MATR') THEN
            WRITE (60,FMT) MISC(I).NAME,MISC(I).L,TRIM(MISC(I).TYPE)
          ENDIF
        ENDDO
      ENDIF

      IF ((NINST.GT.0).OR.
     >    (NPROF.GT.0).OR.
     >    (NWIRE.GT.0).OR.
     >    (NSLMO.GT.0).OR.
     >    (NBLMO.GT.0).OR.
     >    (NIMON.GT.0)) THEN
        WRITE (60,'(1X/''!MISC:''/''!===='')')
        FMT = '(A,'': DRIF,L='',1PE16.9,'',GROUP="'',A,''"'')'
        DO I = 1,NMISC
          IF (((MISC(I).KEYW).NE.'MONI').AND.
     >        ((MISC(I).KEYW).NE.'HMON').AND.
     >        ((MISC(I).KEYW).NE.'VMON').AND.
     >        ((MISC(I).KEYW).NE.'MATR').AND.
     >        ((MISC(I).KEYW).NE.'MARK')) THEN
            WRITE (60,FMT) MISC(I).NAME,MISC(I).L,MISC(I).KEYW
          ENDIF
        ENDDO
      ENDIF

      IF (NMARK.GT.0) THEN
        WRITE (60,'(1X/''!MARK:''/''!===='')')
        DO I = 1,NMISC
          IF ((MISC(I).KEYW).EQ.'MARK') THEN
            IF ((MISC(I).TYPE).EQ.'WATCH           ') THEN
              FMT = '(A,'': WATCH,FILENAME="'',A,''.out"'')'
              WRITE (60,FMT) MISC(I).NAME,TRIM(MISC(I).NAME)
            ELSE IF ((MISC(I).TYPE).EQ.'CENTER          ') THEN
              FMT = '(A,'': CENTER'')'
              WRITE (60,FMT) MISC(I).NAME
            ELSE IF ((MISC(I).TYPE).EQ.'WAKE            ') THEN
              FMT = '(A,'': WAKE,INPUTFILE="'',A,''", &'')'
              WRITE (60,FMT) MISC(I).NAME,TRIM(MISC(I).NAME)
              FMT = '(''  FACTOR=2400,TCOLUMN="t",WCOLUMN="W"'//
     >          ',N_BINS=0,SMOOTHING=1'')'
              WRITE (60,FMT)
            ELSE IF ((MISC(I).TYPE).EQ.'SCATTER         ') THEN
              FMT = '(A,'': SCATTER'')'
              WRITE (60,FMT) MISC(I).NAME
            ELSE
              FMT = '(A,'': MARK'')'
              WRITE (60,FMT) MISC(I).NAME
            ENDIF
          ENDIF
        ENDDO
      ENDIF

C     beamline definition

      FMT = '(1X/''!BEAMLINE:''/''!========''/''MYLINE : LINE=(C, &'')'
      WRITE (60,FMT)
      FMT = '(2X,A)'
      DO I = 1,NL
        NC = LEN_TRIM(BEAMLINE(I))
        IF (I.EQ.NL) THEN
          WRITE (60,FMT) BEAMLINE(I)(1:NC-1)//')'
        ELSE
          WRITE (60,FMT) BEAMLINE(I)(1:NC)//' &'
        ENDIF
      ENDDO

      CLOSE (60)

      GOTO 999

C-----------------------------------------------------------------------
C
C     F O R M A T     S T A T E M E N T S
C
C-----------------------------------------------------------------------

  800 FORMAT (A4,A16,F12.6,4E16.9,1X,A16,1X,E16.9/5E16.9,1X,A24/
     >  4E16.9/3E16.9)

C-----------------------------------------------------------------------
C
C     R E T U R N
C
C-----------------------------------------------------------------------

  990 WRITE (6,'(1X,''Input file OPEN error'')')
      GOTO 999

  991 WRITE (6,'(1X,''Input file READ error'')')
      GOTO 999

  992 WRITE (6,'(1X,''Sigma Z file OPEN error'')')
      GOTO 999

  993 WRITE (6,'(1X,''Sigma Z file READ error'')')
      GOTO 999

  994 WRITE (6,'(1X,''Output file OPEN error'')')
      GOTO 999

  995 WRITE (6,'(1X,''Too many '',A4,''s'')') KEYW

  999 STOP
      END

      SUBROUTINE WRELE (OUTSTR,NSTR)
      IMPLICIT      NONE

C     -----------------------------------------------------------------

      INTEGER*4     NSTR
      CHARACTER     OUTSTR(16)*96

      INTEGER*4     I,NC

C     -----------------------------------------------------------------

      DO I = 1,NSTR
        NC = LEN_TRIM(OUTSTR(I))
        IF (I.EQ.1) THEN
          WRITE (60,'(A,'', &'')') OUTSTR(I)(1:NC)
        ELSE IF ((I.GT.1).AND.(I.LT.NSTR)) THEN
          WRITE (60,'(2X,A,'', &'')') OUTSTR(I)(1:NC)
        ELSE
          WRITE (60,'(2X,A)') OUTSTR(I)(1:NC)
        ENDIF
      ENDDO

      RETURN
      END
