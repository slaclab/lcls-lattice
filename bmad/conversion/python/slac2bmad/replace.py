


def replace_element(lines, ele_name, new_ele, verbose=True):
    """
    Searches through lines for:
    ele_name: <some definition>
    , comments it out, and writes new_ele string below the comment. 
    Considers & to continue the line. 
    """
    newlines = []
    inele = False
    for line in lines:
        if inele:
            # Continued element definition.
            newlines.append('!old '+line)
            if line.strip()[-1] != '&':
                inele=False
            continue
        
        s = line.split(':')
        if len(s) == 1:
            newlines.append(line)
            continue
        if s[0].strip().lower() != ele_name.lower():
            newlines.append(line)
            continue
        # Should be a match    
        if verbose:
            print('Found ele:', ele_name)
        newlines.append(new_ele)
        newlines.append('!old: '+line)
        if line.strip()[-1] == '&':
            # Element definition continues
            inele = True
    return newlines



def replace_eles(lines, replacements, verbose=True):
    """
    
    """
    newlines = lines
    for k in replacements:
        newlines = replace_element(newlines, k, replacements[k], verbose=verbose)
    return newlines





