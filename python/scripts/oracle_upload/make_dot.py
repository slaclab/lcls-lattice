#!/usr/bin/env python3
import sys
import re

models = ['sc_sxr','sc_hxr','sc_bsyd','sc_dasel','sc_diag0','cu_sxr','cu_hxr','sc_diag02','sc_diagis',
          'sc_sxr2','sc_hxr2','sc_bsyd2','sc_dasel2']

class LatticeGraphGenerator:
    def __init__(self, output_file, width=0, height=0):
        self.defwidth = 700
        self.defheight = 70
        self.width = width if width > 0 else self.defwidth
        self.height = height if height > 0 else self.defheight

        self.output_file = output_file
        
        self.start = True
        self.isOpenRank = False
        self.linebegins = False
        self.lineends = False
        self.currenthierarchy = ""
        self.pathname = ""
        self.lastname = ""
        
        # Dictionaries
        self.elementOccurrencesm = {}
        self.elementtypem = {}
        self.elementSm = {}
        self.elementZm = {}
        self.elementdevNamem = {}
        self.elementnames = {}
        
        self.namei = 0
        #self.nr = 0  # Line counter

    def write(self, text, end='\n'):
        self.output_file.write(text + end)
        
    def process_line(self, line):
        """Process a single line from the precursor file"""
        #self.nr += 1
        fields = line.strip().split()
        
        if len(fields) < 5:
            return
        
        devname = fields[0]
        elementname = fields[1]
        elementtype = fields[2]
        s = float(fields[3])
        z = float(fields[4])
        
        # Build hierarchy string from remaining fields
        hierarchy = ' '.join(fields[5:]) if len(fields) > 5 else ""
        
        # Initialize on first line
        if self.start:
            # Extract pathname from first hierarchy
            parts = hierarchy.split()
            self.pathname = parts[0] if parts else "lattice"
            
            # Start the dot file
            self.write(f"digraph {self.pathname} {{")
            self.write(f'size = "{self.width}, {self.height}";')
            self.write('graph [ fontsize = 45 ];')
            self.write('node [ fontsize = 30, shape=plaintext ];')
            self.write('edge [ arrowsize=0.5 ];')
            self.write('graph [ rankdir = LR ];')
            self.write(f"subgraph cluster_{self.pathname} {{")
            self.write('graph [ fontsize = 200 ]', end='')
            self.write(f'label = "{self.pathname}"')
            self.write('color = "grey"')
            self.write(self.pathname, end='')
            
            self.currenthierarchy = hierarchy
            self.start = False
        
        # Detect BEG markers
        if re.match(r'^BEG[A-Z0-9_]+', elementname) and elementtype == "MARK":
            self.linebegins = True
            linename = re.sub(r'^BEG', '', elementname)
            #print(f"BEG{linename}", file=sys.stderr)
            
            if self.isOpenRank:
                self.write("}")
                self.isOpenRank = False
            
            self.write(f"\nsubgraph cluster_{linename} {{")
            self.write('graph [ fontsize = 150 ]', end='')
            
            self.write(f'label = "{linename}"')
            self.write('color = "grey"')
            self.currenthierarchy = hierarchy
        
        # Detect END markers
        if re.match(r'^END[A-Z0-9_]+', elementname) and elementtype == "MARK":
            self.lineends = True
            linename = re.sub(r'^END', '', elementname)
            #print(f"END{linename}", file=sys.stderr)
            
            if self.isOpenRank:
                self.write("}")
                self.isOpenRank = False
            
            self.write(f"}} /* {linename} */")
        
        # Process regular elements (skip END)
        if not (re.match(r'^(END)[A-Z0-9_]+', elementname) and elementtype == "MARK"):
            # Track occurrences
            if elementname not in self.elementOccurrencesm:
                self.elementOccurrencesm[elementname] = 0
            self.elementOccurrencesm[elementname] += 1
            nOccurrence = self.elementOccurrencesm[elementname]
            
            # Store element data
            self.elementtypem[elementname] = elementtype
            self.elementSm[f"{elementname}{nOccurrence}"] = s
            self.elementZm[f"{elementname}{nOccurrence}"] = z
            
            # Store device name for first occurrence only
            if nOccurrence == 1:
                self.elementdevNamem[elementname] = devname
                self.namei += 1
                self.elementnames[self.namei] = elementname
            
            #print(f"elem name: {elementname} occurrence: {nOccurrence}", file=sys.stderr)
            
            # Track first occurrence
            if nOccurrence == 1:
                occurrenceNodeName = elementname
            else:
                occurrenceNodeName = f"{elementname}_{nOccurrence}"
            
            # Create connections
            if self.linebegins or self.lineends:
                if self.lastname:
                    self.write(f"{self.lastname} -> {occurrenceNodeName}")
                self.write("{ rank = same")
                self.isOpenRank = True
                self.write(occurrenceNodeName, end='')
            else:
                if self.lastname:
                    self.write(f"-> {occurrenceNodeName}", end='')
                else:
                    self.write(occurrenceNodeName, end='')
            
            self.linebegins = False
            self.lineends = False
            self.lastname = occurrenceNodeName
    
    def finalize(self):
        """Generate the END block output"""
        # Close the path
        if self.isOpenRank:
            self.write("}")
            self.isOpenRank = False
        
        self.write(f"}} /* {self.pathname} */")
        
        # Write out the labels for each node
        for ei in sorted(self.elementnames.keys()):
            if ei != "":
                elname = self.elementnames[ei]
                nocc = self.elementOccurrencesm.get(elname, 1)
                devNamename = self.elementdevNamem.get(elname, "")
                
                self.write(f'{elname} [ label = <{elname} ', end='')
                # Add device name if it exists and is not "-"
                if devNamename and devNamename != "-":
                    self.write(f'<b>{devNamename}</b>', end='')
                self.write(f'<BR/>{self.elementtypem[elname]} '
                      f'{self.elementSm.get(elname + "1", 0):.6f} / '
                      f'{self.elementZm.get(elname + "1", 0):.6f}', end='')
                self.write(' >];')
                
                for iocc in range(2, nocc + 1):
                    nodeName = f"{elname}_{iocc}"
                    self.write(f'{nodeName} [ label = <{elname}({iocc}) ', end='')
                    # Add device name if it exists and is not "-"
                    if devNamename and devNamename != "-":
                        self.write(f'<b>{devNamename}</b>', end='')
                    self.write(f'<BR/>{self.elementtypem[elname]} '
                          f'{self.elementSm.get(elname + str(iocc), 0):.6f} / '
                          f'{self.elementZm.get(elname + str(iocc), 0):.6f}', end='')
                    self.write(' >];')
        
        self.write("}")  # end the main digraph


def main():
    for model in models:
        with open(f'{model}.dot', 'w') as f:
            generator = LatticeGraphGenerator(f)
        
            with open(f'{model}_lines.all', 'r') as infile:
                for line in infile:
                    generator.process_line(line)
        
            generator.finalize()


if __name__ == '__main__':
    main()
