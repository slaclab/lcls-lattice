# mad2dot.awk produces a picture of all the elements in a MAD v8 lattice.
# 
# Usage:
#  awk -f mad2dot.awk {<surveyfile>.tape}1+ [elementdevices.dat] <printfile>.print > output.dot
#
# mad2awk produces a directed graph (nodes joined by arrows) of the elements
# (and if availables their device names) that a beam would
# visit as it goes through the beampath described by MAD 8 output files. 
# 
# Input: Filename rules;
# 1. At least 1 survey tape file is requried and MUST be first. They must be 
# named *survey.tape - as comes out of Mad 8. Normally there will be only 1, corresponding
# to the print file (given last), but if more than one, the set of survey files must
# collectively include all of the elements in the print file.
# 2. There may be 0, 1 or more elementdevices files given too. If given, they must
# come after the survey file(s). They must be named *device.dat. 
# 3. The Print tape file MUST be given last. It must be named *.print - as 
# comes out of Mad 8.
#
# Output. mad2dot prints dot commands to standard output. To capture them in a file,
# redirect (>) the output to the filename of your choice, like > printname.dot 
# 
# Examples:
#
#  1. Subway map of "gun to the dump" of LCLS:
#       awk -v width=38 -v height=4 -f mad2dot.awk lcls_survey.tape \
#       elementdevices.dat lcls.print > lcls.dot
#
#  2. Subway map of the Gun Spectrometer line, and executing this script from the
#  lattice files directory where MAD is likely to have left them:
#      awk -v height=10  -f ../../../script/mad2dot.awk GSPEC_survey.tape \
#         ../../../script/elementdevices.dat gspec.print > gspec.dot
#        
# To view the resulting dot file, one a Mac you can use Graphviz. Or you can
# use regular dot visualizations. From Graphviz, use File->Export to create PDF,
# PNG or SVG files. 
#  
# Eg open -a /Applications/Graphviz.app gspec.dot
#
#---------------------------------------------------------------------------------
# Auth: Greg White, 8-Jan-2014, SLAC.
# Mod:  Greg White, 24-Oct-2019, Modified to use MARKer points named BEGx .. ENDx 
#                                to delimit lines, as opposed to MAD lines. Also added
#                                special handling for chicane BENDs named xA and xB so
#                                BEND appears once in line file named x. This fixes 
#                                prior absence of BENDs.
#       Greg White, 12-Mar-2015, Added element type Suml and Z to Lines file.
#       Greg White, 11-Apr-2014, Add ignoring comments in element device.dat files.
#                                More help in header on input files.
#       Greg White, 04-Apr-2014, Added note in header about requirement that survey 
#                                files must preceed tape files.  
#       Greg White, 26-Mar-2014, Upgraded header, added examples.
#       Greg White, Jan-2014, modified font size from 12/9
#  
#=================================================================================

# TODO: paper size is hard coded here for LCLS, at 387x39 inches. Smaller or
# diff sized accelerators should adjust this and the font sizes.
#
BEGIN { 
    # defwidth=387; defheight=39;
    defwidth=700; defheight=70;
    start = 1; isOpenRank = 0; linebegins=0; lineends=0; elementlines[""]=""; line[0]="";
    GRAPHHEADER="size = \"%d, %d\";\n graph [ fontsize = 45 ]; \nnode [ fontsize = 30, shape=plaintext ];\n edge [ arrowsize=0.5 ]\n";
    RANKDIR="graph [ rankdir = LR ]\n";
}

# Read LCLS_survey.tape file, finding each 5th record that starts an element's
# description, and build a hashmap from element-name to element type to be used
# later to put element types on element nodes in the output graph.  WORKAROUND
# 4-Apr-14: Added && NF>0 because LCLS2 survey includes non-blank lines at EOF
#
FILENAME ~ /survey\.tape$/ && (FNR-2)%4 == 1 && (NF>0) {
    surveyelementtype = substr($1,1,4);
    surveyelementname = substr($1,5);
    elementnametypem[surveyelementname]=surveyelementtype;
    surveyelementnames[si++]=surveyelementname;
    ## DBG print surveyelementtype " " surveyelementname > "/dev/stderr"; 
    next;
}

# Read devices dat file(s), and build a hashmap from element-name to element type
# to device name be used later to put device names on element nodes in the
# output graph. NOTE: Any number of elementdevices files can be on the command
# line, 0, 1 or more. If 0, then no _lines.dat files will be emitted and no
# elements will have an associated device in the _map.pdf files.
# Where >1 elementdevices file is given, and more than one contain the
# same element name, the device name given in the last file given wins.
# In that way, a nominal elementdevices data file can be given first,
# followed by an addendum. Eg, say Oracle hasn't been updated yet, but we
# have a list of new/changed device names in a file - then the first
# elementdevice*.dat file would contain the nominal list, and following
# elementdevices*.day fils can contain the new elements and thsoe with
# changed element or device names.  
# 
#
FILENAME ~ /elementdevices.*\.dat$/ { 
    if ( $0 !~/^#/ && NF==2) elementdevNamem[$1] = $2; 
    next; 
}

# Read the print file to get all the elements and in which lines they appear.
#
FILENAME ~ /\.print$/ && $0 ~ /Survey\./,/Linear Lattice Functions\./ {  

    # Process only the Survey rows, ignoring those records that don't have 11  
    # columns and start with either a "begin", "end" or number.
    #
    if ( NF==11 && $1~/begin|end|[[:digit:]]+/ ) 
     {
	 gsub(/[^A-Za-z0-9_]*/,"",$2);  # Strip name of chars illegal in dot file
	 if ( start == 1 )
	 {
	     # seed the array of line names with the pathname. Ad
	     pathname = $2;
	     line[linei] = pathname;

	     # Start the dot file 
	     printf("digraph %s {\n",$2);
	     if ( width == 0 ) width=defwidth;
	     if ( height == 0 ) height=defheight;
	     printf(GRAPHHEADER,width,height);
	     printf(RANKDIR);
	     printf("subgraph cluster_%s {\n",pathname);
	     printf("graph [ fontsize = 200 ]");     
	     printf("label = \"%s\"\n",pathname);
	     printf("color = \"grey\"\n");
	     printf("%s",pathname);

	     # Make the output lines file name out of the name of the print file.
	     lastname=$2;
	     baseFName=substr(FILENAME,match(FILENAME,/([^\/])+$/));
	     linesFName=baseFName;
	     sub(".print","_lines.dat",linesFName);
             # ok, done initialization things. Don't do this again.
	     start = 0; 
	 }

	 # Skip all other MAD line "begin" or "end" print file records. 
	 #
	 if ( $1 ~/^(begin|end)/ )
	 {
	     next;
	 }

	 # Recognize begining of area - a MARKer element who name begins "BEG"  
	 #
	 if ( $2 ~/^BEG[A-Z0-9_]+/ && elementnametypem[surveyelementnames[$1]] ~/^MARK/ )
	 {
	     linebegins=1;
	     # Get the full name from the survey file
	     linename=surveyelementnames[$1];
	     # Remove the "BEG" from the begining of the name, leaving what we use as the line name
	     sub("BEG","",linename);  
	     print "BEG" linename > "/dev/stderr"; 

	     linei++;
	     line[linei] = linename;
	     if ( isOpenRank == 1 )  # Close any open rank 
	     {
		 printf("}\n"); 
		 isOpenRank=0;
	     }
	     printf("\nsubgraph cluster_%s {\n",linename);
	     if ( linei < 3 ) 
		 printf("graph [ fontsize = 150 ]");     # 70
	     else if ( linei < 5 )
		 printf("graph [ fontsize = 100 ]");     # 50
	     else
		 printf("graph [ fontsize = 50 ]");     # 30

	     printf("label = \"%s\"\n",linename);
	     printf("color = \"grey\"\n");
	     name=linename;
	 }

	 # Recognize end of area - a MARKer element who name begins "END"  
	 #
	 if ( $2 ~/^END[A-Z0-9_]+/ && elementnametypem[surveyelementnames[$1]] ~/^MARK/ )
	 {
	     # End of line record encontered
	     #
	     lineends=1;
	     # Get the full name of the element from the array of all in the survey file 
	     linename=surveyelementnames[$1];
	     sub("END","",linename);
	     print "END" linename > "/dev/stderr"; 

	     if ( isOpenRank == 1 )  # Close any open rank  
	     {
		 printf("}\n"); 
		 isOpenRank=0;
	     }
	     printf("} /* %s */ \n",linename);  # Close cluster of line
	     linei--;
	     name=linename;
	 }
	 else
	 {
	     # Regular element record.  Subtlety: The print file truncates
	     # element names ($3), so that can't be used as the node name (since
	     # we'd get false inter-node connections).  Instead we use the 1st
	     # column "pos" as an index into the survey file's list of elements,
	     # where the full name is recorded.
	     #
	     sindex=$1;
	     elementname=surveyelementnames[sindex];

	     nOccurrence=$3;
	     if ( elementnametypem[elementname] ~/^SBEN/) {
		 #if ( elementname ~/A$/ ) 
		  #   nOccurrence=1
		 #else if ( elementname ~/B$/ ) 
		  #   nOccurrence=2
		 print elementname " " nOccurrence > "/dev/stderr";
	     }
	     #else
	#	 nOccurrence=$3;
		 
	     # Read and record occurrence number (to put in parenthesis in
	     # output), and S and Z.
	     #
	     # nOccurrence=$3;
	     elementNOccurrencesm[ elementname ] = nOccurrence;
	     elementSm[elementname nOccurrence] = $4;
	     elementZm[elementname nOccurrence] = $8;

	     ## DBG 
	     print "survey f index:" sindex "\t" "elem name: " elementname > "/dev/stderr"; 

	     # For each first occurrence, record the element name, and if it has a
	     # device name, also the device name of the element.
	     # name = elementname;

  	     if ( nOccurrence == 1 )
	     {
		 namei++;
		 elementnames[namei] = elementname;   # keep a list of all element names.
		 occurrenceNodeName = elementname;
		 
		 # Condition element name for match to device elements (as in Oracle). Bends are
		 # split in MAD, in 2 parts suffix "1" and "2". So prior to matching to survey
		 # file MAD elements, we must remove the last char.
		 #
		 name = elementname;   # Be default, elementdevice elem name is as in MAD.
		 if ( elementnametypem[elementname] ~/^SBEN/) 
		     name = substr(elementname,1,length(elementname)-1);

		 # If the element has a devName associated with it (from
		 # elementdevices .dat file, record the stack of lines to this point for
		 # output to the lines file. The lines.dat file shows the
		 # hierarchy of model lines in which each
		 # DEVNAME/element-occurrence pair resides. Note that, while it
		 # is an enforced convention (at SLAC) that one DEVNAME will be
		 # associated with at most 1 element (elements have 0 or 1
		 # DEVNAMEs), it is not enforced that all of the occurrences of
		 # the element are in the same vertex of the hierarchy of lines
		 # - still, we assume that's true here.
		 #
		 devName = "";
		 if ( name in elementdevNamem ) 
		 {
		     devName = elementdevNamem[ name ];
		     if ( devName != "-" )
		     {
			 # This method makes the assumption that there is no
			 # element that is simulataneously associated with a
			 # DEVNAME, and in more than one vertex.
			 #
			 linesstring="";
			 for ( l in line ) 
			 {
			     linesstring = sprintf("%s %s",linesstring, line[l]);
			 }
			 devNamelinesm[devName]=linesstring;
			 # print as we go so that output is by z.
			 print devName " " elementname " " \
			     elementnametypem[elementname] " " \
			     elementSm[elementname nOccurrence]	" " \
			     elementZm[elementname nOccurrence] " " \
			     devNamelinesm[devName]		    \
			     > linesFName;
		     } 
		 }
	     }
	     else 
	     {
		 occurrenceNodeName = sprintf("%s_%d",elementname,nOccurrence);
	     }
	     # Keep track of number of occurrences of all elements.
	     elementOccurrencesm[ elementname ] = nOccurrence;
	     
	     # If 1st element of a new line, or 1st element after end of a line
	     # then connect the last element of the previous line to the this
	     # first element of new line (or this 1st element after end of
	     # line), and start a new group of equal rank). Otherwise just
	     # regulary connect this element with the last in the present rank.
	     #
	     if ( linebegins == 1 || lineends == 1 )
	     {
		 printf("%s -> %s\n",lastname,occurrenceNodeName);
		 printf("{ rank = same\n");
		 isOpenRank=1;
		 printf("%s",occurrenceNodeName);
		 # print "[ image quadimg.xvg ]";   - print icons
	     }
	     else 
	     {
		 printf("-> %s",occurrenceNodeName);
	     }
	     
	     linebegins=0;
	     lineends=0;
	     lastname = occurrenceNodeName;   # Needs to be here, otherwise lines start 
	                        # with their linename 
	 }
     }
 }
END {

    # First close the path.
    if ( isOpenRank == 1 )  # Close any open rank  
    {
	printf("}\n"); 
	isOpenRank=0;
    }
    printf("} /* %s */ \n",pathname);  # Close cluster of line


    # Write out the labels used for each node at the end of the file. The node name
    # index is the MAD element name. 
    for ( ei in elementnames )
    {
	if ( ei != "" ) 
	{
	    elname = elementnames[ei];
	    devNamename = elementdevNamem[elname] ;
	    nocc = elementOccurrencesm[ elname ];
	    printf("%s [ label = <%s ",elname, elname)
	    if ( devNamename != "" ) printf("<b>%s</b>",devNamename); 
	    printf("<BR/>%s %f / %f", 
		   elementnametypem[elname], 
		   elementSm[elname "1"], elementZm[elname "1"]);
	    printf(" >];\n");

	    for ( iocc=2; iocc<=nocc; iocc++ )
	    {
		nodeName = elname "_" iocc;
		printf("%s [ label = <%s(%d) ",nodeName, elname, iocc);
		if ( devNamename != "" ) printf("<b>%s</b>",devNamename); 
		printf("<BR/>%s %f / %f", 
		   elementnametypem[elname], 
		   elementSm[elname iocc], elementZm[elname iocc]);
		printf(" >];\n");

	    }
	}
    }
    print "}"; # end the main digraph 

}
