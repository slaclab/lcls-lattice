


def desplit_ele(line, double_length=True, verbose=True):
    """
    De-splits elements. Converts form:
    ele_full: line (ele, other...eles, ele) to:
    ele_full: line = (ele)
    ele[L] = 2*ele[L]
    other eles[superimpose] = T
    other eles[ref] = ele
    
    Example:
    
    !Original split line: line = (qsx16, xcsx16, ycsx16, qsx16)
    qsx16_full: line = (qsx16)
    qsx16[L] = 2*qsx16[L]
    xcsx16[superimpose] = T
    xcsx16[ref] = qsx16
    ycsx16[superimpose] = T
    ycsx16[ref] = qsx16
    
    """
    # Check if this is a _full line
    original_line = line
    
    s = line.split(':')
    if len(s) ==1:
        return line
    ix = s[0].find('_full')
    if ix <0:
        return line
    # Should be. 
    ele, line = line.split(':')
    name = ele.split('_full')[0].lower()
    eles = [e.strip().lower() for e in (line.split('(')[1].split(')')[0]).split(',')]
    
    # Check for just one ele definition
    if len(eles)==1:
        if verbose:
            print('Info: line only has one ele:', original_line)
        return original_line
    
    # Make sure this is true
    if eles[0] != name or eles[-1] != name:
        if verbose:
            print('Warning: different starting and ending ele names: '+ original_line, '\n   Skipping.')
        return original_line
    
    if verbose:
        print(f'Desplitting ele: {name}')
    
    #assert eles[0] == name
    #assert eles[-1] == name
    insideeles = eles[1:-1]
    
    lines = ['\n', '!Old split line:'+line]
    lines.append(name+'_full: line = ('+name+')')
    if double_length:
        lines.append(name+'[L] = 2*'+name+'[L]')
    for e in insideeles:
        lines.append(e+'[superimpose] = T')
        lines.append(e+'[ref] = '+name)
    lines.append('\n')
    return '\n'.join(lines)
        
def desplit_eles(lines, verbose=True):
    return [desplit_ele(line, verbose=verbose) for line in lines]