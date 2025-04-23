


def replace_element(lines, ele_name, new_ele, verbose=True, shadows=None):
    """
    Searches through lines for:
    ele_name: <some definition>
    , comments it out, and writes new_ele string below the comment. 
    Considers & to continue the line. 
    """
    if shadows is None:
        shadows = []

    newlines = []
    inele = False
    is_shadow = False
    for line in lines:
        if inele:
            # Continued element definition.
            if is_shadow:
                newlines.append(line)
            else:
                newlines.append('!old '+line)
            if line.strip()[-1] not in (',', '&'):
                inele=False
                is_shadow = False
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
        if ele_name.lower() in shadows:
            is_shadow = True
        if is_shadow:
            for l in new_ele.splitlines():
                newlines.append('!new: '+l)
            newlines.append(line)
        else:
            newlines.append(new_ele)
            newlines.append('!old: '+line)
        if line.strip()[-1] in (',', '&'):
            # Element definition continues
            inele = True
    return newlines



def replace_eles(lines, replacements=None, verbose=True, shadows=None):
    """
    
    """
    if replacements is None:
        replacements = []
    newlines = lines
    for k in replacements:
        newlines = replace_element(newlines, k, replacements[k], verbose=verbose, shadows=shadows)
    return newlines





