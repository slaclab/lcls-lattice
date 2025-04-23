from .xsif import fold_comments
from .desplit import desplit_eles
from .replace import replace_eles


def finalize_bmad(bmad_file, replacements={}, verbose=True, exclude_strs=[], shadows=[]):
    with open(bmad_file) as f:
        lines = f.readlines()
    
    # Desplit
    lines = desplit_eles(lines, verbose=verbose, exclude_strs=exclude_strs)    
    
    # Custom element replacements
    lines = replace_eles(lines, replacements, verbose=verbose, shadows=shadows)
        
    # fold
    lines = fold_comments(lines)
    
    # Write file in place. 
    with open(bmad_file, 'w') as f:
        for line in lines:
            f.write(line+'\n')
