from .xsif import fold_comments
from .desplit import desplit_eles
from .replace import replace_eles


def finalize_bmad(bmad_file, replacements={}, verbose=True, desplit=True):
    with open(bmad_file) as f:
        lines = f.readlines()
    
    # Desplit
    if desplit:
        lines = desplit_eles(lines, verbose=verbose)    
    
    # Custom element replacements
    lines = replace_eles(lines, replacements, verbose=verbose)
        
    # fold
    lines = fold_comments(lines)
    
    # Write file in place. 
    with open(bmad_file, 'w') as f:
        for line in lines:
            f.write(line+'\n')
