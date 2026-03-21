#!/usr/bin/env python3
import sys
import re

class LatticeGraphGenerator:
    def __init__(self, width=0, height=0):
        self.defwidth = 700
        self.defheight = 70
        self.width = width if width > 0 else self.defwidth
        self.height = height if height > 0 else self.defheight
        
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
        self.nr = 0  # Line counter
        
    def process_line(self, line):
        """Process a single line from the precursor file"""
        self.nr += 1
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
            print(f"digraph {self.pathname} {{")
            print(f'size = "{self.width}, {self.height}";')
            print('graph [ fontsize = 45 ];')
            print('node [ fontsize = 30, shape=plaintext ];')
            print('edge [ arrowsize=0.5 ];')
            print('graph [ rankdir = LR ];')
            print(f"subgraph cluster_{self.pathname} {{")
            print('graph [ fontsize = 200 ]', end='')
            print(f'label = "{self.pathname}"')
            print('color = "grey"')
            print(self.pathname, end='')
            
            self.currenthierarchy = hierarchy
            self.start = False
        
        # Detect BEG markers
        if re.match(r'^BEG[A-Z0-9_]+', elementname) and elementtype == "MARK":
            self.linebegins = True
            linename = re.sub(r'^BEG', '', elementname)
            print(f"BEG{linename}", file=sys.stderr)
            
            if self.isOpenRank:
                print("}")
                self.isOpenRank = False
            
            print(f"\nsubgraph cluster_{linename} {{")
            print('graph [ fontsize = 150 ]', end='')
            
            print(f'label = "{linename}"')
            print('color = "grey"')
            self.currenthierarchy = hierarchy
        
        # Detect END markers
        if re.match(r'^END[A-Z0-9_]+', elementname) and elementtype == "MARK":
            self.lineends = True
            linename = re.sub(r'^END', '', elementname)
            print(f"END{linename}", file=sys.stderr)
            
            if self.isOpenRank:
                print("}")
                self.isOpenRank = False
            
            print(f"}} /* {linename} */")
        
        # Process regular elements (skip BEG/END)
        if not (re.match(r'^(BEG|END)[A-Z0-9_]+', elementname) and elementtype == "MARK"):
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
            
            print(f"elem name: {elementname} occurrence: {nOccurrence}", file=sys.stderr)
            
            # Track first occurrence
            if nOccurrence == 1:
                self.namei += 1
                self.elementnames[self.namei] = elementname
                occurrenceNodeName = elementname
            else:
                occurrenceNodeName = f"{elementname}_{nOccurrence}"
            
            # Create connections
            if self.linebegins or self.lineends:
                if self.lastname:
                    print(f"{self.lastname} -> {occurrenceNodeName}")
                print("{ rank = same")
                self.isOpenRank = True
                print(occurrenceNodeName, end='')
            else:
                if self.lastname:
                    print(f"-> {occurrenceNodeName}", end='')
                else:
                    print(occurrenceNodeName, end='')
            
            self.linebegins = False
            self.lineends = False
            self.lastname = occurrenceNodeName
    
    def finalize(self):
        """Generate the END block output"""
        # Close the path
        if self.isOpenRank:
            print("}")
            self.isOpenRank = False
        
        print(f"}} /* {self.pathname} */")
        
        # Write out the labels for each node
        for ei in sorted(self.elementnames.keys()):
            if ei != "":
                elname = self.elementnames[ei]
                nocc = self.elementOccurrencesm.get(elname, 1)
                devNamename = self.elementdevNamem.get(elname, "")
                
                print(f'{elname} [ label = <{elname} ', end='')
                # Add device name if it exists and is not "-"
                if devNamename and devNamename != "-":
                    print(f'<b>{devNamename}</b>', end='')
                print(f'<BR/>{self.elementtypem[elname]} '
                      f'{self.elementSm.get(elname + "1", 0):.6f} / '
                      f'{self.elementZm.get(elname + "1", 0):.6f}', end='')
                print(' >];')
                
                for iocc in range(2, nocc + 1):
                    nodeName = f"{elname}_{iocc}"
                    print(f'{nodeName} [ label = <{elname}({iocc}) ', end='')
                    # Add device name if it exists and is not "-"
                    if devNamename and devNamename != "-":
                        print(f'<b>{devNamename}</b>', end='')
                    print(f'<BR/>{self.elementtypem[elname]} '
                          f'{self.elementSm.get(elname + str(iocc), 0):.6f} / '
                          f'{self.elementZm.get(elname + str(iocc), 0):.6f}', end='')
                    print(' >];')
        
        print("}")  # end the main digraph


def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py precursor_file.dat", file=sys.stderr)
        sys.exit(1)
    
    generator = LatticeGraphGenerator()
    
    with open(sys.argv[1], 'r') as f:
        for line in f:
            generator.process_line(line)
    
    generator.finalize()


if __name__ == '__main__':
    main()
