
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
    line = line.lower() # Always work with lower case
    
    s = line.split(':')
    if len(s) ==1:
        return original_line
    ix = s[0].find('_full')
    if ix <0:
        return original_line
    # Should be. 
    ele, line = line.split(':')
    ele = ele.strip()
    
    name = ele.split('_full')[0]
    eles = [e.strip() for e in (line.split('(')[1].split(')')[0]).split(',')]
    
    # Check for just one ele definition
    if len(eles)==1:
        if verbose:
            print('Info: line only has one ele:', original_line)
        return original_line
    
    # Make sure this is true
    if eles[0] != name or eles[-1] != name:
        #return original_line
        # This is okay though
        if (eles[0].endswith('1') and eles[-1].endswith('2')):
            double_length = False
            
            if verbose: print(f'Special desplit, names end with 1,2: {original_line}')
        elif (eles[0].endswith('a') and eles[-1].endswith('b')):
            double_length = False
            
            if verbose: print(f'Special desplit, names end with a,b: {original_line}') 
        elif len(eles) == 5 and eles[1].endswith('a'):
            assert eles[3].endswith('b')
            if verbose: print(f'Special padded desplit, inside names end with a,b: {original_line}')
            return process_padded_desplit(name, eles, note=f"Old split line: {original_line}")
        else:
            if verbose:
                print(name, eles[0])
                print(f'Warning: different starting and ending ele names: {original_line}, skipping.')
            return original_line
    
    if verbose:
        print(f'Desplitting ele: {name}')
    
    #assert eles[0] == name
    #assert eles[-1] == name
    insideeles = eles[1:-1]
    
    lines = ['\n', '!Old split line:'+original_line]
    lines.append(name+'_full: line = ('+name+')')
    if double_length:
        lines.append(name+'[L] = 2*'+name+'[L]')
    for e in insideeles:
        lines.append(e+'[superimpose] = T')
        lines.append(e+'[ref] = '+name)
    lines.append('\n')
    
    output = '\n'.join(lines)
    
    return output


def process_padded_desplit(name, eles, note=""):
    """
    
    Example:
        process_padded_desplit('cavl355', ['dcavmap', 'cavl355a', 'csp35', 'cavl355b', 'dcavmap'], "some note")
    returns:
 
    ! some note   
    cavl355_full: line = (dcavmap, cavl355, dcavmap)
        csp35[superimpose] = T
        csp35[ref] = cavl355
        csp35[ele_origin] = beginning
        csp35[ref_origin] = beginning
        csp35[offset] = cavl355a[L] 
        
    
    """
    
    pad = eles[0]
    assert eles[-1] == pad
    assert eles[1].startswith(name), eles[1]
    sele = eles[2]
    assert eles[3].startswith(name), eles[3]
    
    
    line = f"""! {note}   
{name}_full: line = ({pad}, {name}, {pad})
    {sele}[superimpose] = T
    {sele}[ref] = {name}
    {sele}[offset] = ({eles[1]}[L] - {eles[3]}[L]) / 2 
    """

    return line


        
def desplit_eles(lines, verbose=True):
    return [desplit_ele(line, verbose=verbose) for line in lines]
