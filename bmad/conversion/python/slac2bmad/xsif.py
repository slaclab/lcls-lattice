



import re
import os

def remove_comment_blocks(lines, prefix='!=!'):
    """
    Removes comment blocks of the form:
    COMMENT
    text
    ...
    ENDCOMMENT
    
    """
    out = []
    inside = False
    for line in lines:
        if line.strip().upper().startswith('COMMENT'):
            inside = True
            out.append(prefix+line)
        if line.strip().upper().startswith('ENDCOMMENT'):
            assert inside, 'ERROR: nexted comments not supported.'
            inside = False
            out.append(prefix+line)
        elif inside:
            out.append(prefix+line)
        else:
            out.append(line)
    return out

def remove_fdn_calls(lines, prefix='!=!'):
    """
    removes call to fdn file, as this file contains
    unusual xsif syntax that mad8_to_bmad.py does not parse correctly.
    """
    out = []
    inside = False
    for line in lines:
        if 'fdn' in line.lower():
            out.append(prefix+line)
        else:
            out.append(line)
    return out

def replace_set(line):
    """
    Replaces SET commands
    """
    return re.sub(r' *SET *, * (\w*) *, *(\w*)', r'\1 = \2', line)

def replace_set_commands(lines):
    return [replace_set(line) for line in lines]




#-------------------------------
# Matrix elements (RM)

def fix_matrix(line):
    """
    Replaces RM(1,2) with R12
    """
    return re.sub(r'RM\(([1-6]),([1-6])\)', r'R\1\2', line)



#-------------------------------
# Names

FULLNAMES = {
    'APER':'aperture',
    'LCAV':'lcavity',
    'IMON':'MARKER',
    'WIRE':'MARKER',
    'PROF':'MONITOR',
    'BLMO':'MONITOR'
}

def expand_names(line):
    for k, v in FULLNAMES.items():
        # Skip ones that are fine
        line = re.sub(k,v,line)
    return line


def fix_names(lines):
    out = []
    for line in lines:
        line = expand_names(line)
        line = fix_matrix(line)
        out.append(line)
    return out



#-------------------------------
# Comments

c = '!'
c2 = '! INLINE--#'
c3 = '! SIMPLE --#'
empty = '! EMPTY --#'

def unfold_comments(lines):
    '''
    Break a line with a comment at the end into two pieces. Preserve whitespace.
    '''
    newlines = []
    for line in lines:
        ix = line.find(c)
        if ix>-1:
            # There is a comment in this line
            # Get whitespace too
            m=re.search('\\s*'+c+'.*', line)
            firstpart = line[0:ix].rstrip()
            if firstpart.strip() =='':
                # Simple comment with whitespace
                newlines.append(c3+m.group(0))
            else:
                # Inline comment
                newlines.append(c2+m.group(0))
                newlines.append(line[0:ix].rstrip())
        elif len(line.strip()) ==0:
            # Empty line
            newlines.append(empty)
        else:
            newlines.append(line.rstrip())

    return newlines


def fold_comments(lines):
    '''
    Fold lines starting with c2 into next line
    '''
    newlines = []
    x = None
    for line in lines:
        line = line.rstrip()
        ix = line.find(c2)
        ix3 = line.find(c3)
        if line.strip() == empty :
            # Empty line
            newlines.append('')
        elif ix3 ==0:
            # Simple comment
            newlines.append(line[len(c3):])
        elif ix == 0:
            # No comments, just return line
            x = line[len(c2):]
        else:
            if x:
                newlines.append(line[0:] + x )
                x = None
            else:
                newlines.append(line.rstrip())
    return newlines





#-------------------------------
# Master routine to prepare XSIF


def prepare_xsif(xsif_file, save=True):
    """
    Prepares an XSIF file for conversion. 
    """
    path, file = os.path.split(xsif_file)
    basename = file.split('.')[0]
    outname = basename+'.bmad'
    print('Preparing', file)
    
    with open(xsif_file) as f:
        lines = f.readlines()
        
    # Remove comment blocks
    lines = remove_comment_blocks(lines)
    
    # Replace set commands
    lines = replace_set_commands(lines)
    
    # Fix names, matrix
    lines = fix_names(lines)
    
    # Unfold comments
    lines = unfold_comments(lines)

    #lines = remove_fdn_calls(lines)
    
    # Save
    if save:
        os.rename(xsif_file, xsif_file+'_save')
    
    
    with open(xsif_file, 'w') as f:
        for line in lines:
            f.write(line+'\n')
