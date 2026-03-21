BEGIN {
    # defwidth=387; defheight=39;
    defwidth=700; defheight=70;
    start = 1; isOpenRank = 0; linebegins=0; lineends=0;
    GRAPHHEADER="size = \"%d, %d\";\n graph [ fontsize = 45 ]; \nnode [ fontsize = 30, shape=plaintext ];\n edge [ arrowsize=0.5 ]\n";
    RANKDIR="graph [ rankdir = LR ]\n";
}

FILENAME ~ /survey\.tape$/ && (FNR-2)%4 == 1 && (NF>0) {
    surveyelementtype = substr($1,1,4);
    surveyelementname = substr($1,5);
    elementnametypem[surveyelementname]=surveyelementtype;
    surveyelementnames[si++]=surveyelementname;
    ## DBG print surveyelementtype " " surveyelementname > "/dev/stderr";
    next;
}

FILENAME ~ /\.print$/ && $0 ~ /Survey\./,/Linear Lattice Functions\./ {

    # Process only the Survey rows, ignoring those records that don't have 11
    # columns and start with either a "begin", "end" or number.
    #
    if ( NF==11 && $1~/begin|end|[[:digit:]]+/ )
     {
         gsub(/[^A-Za-z0-9_]*/,"",$2);  # Strip name of chars illegal in dot file
         if ( start == 1 )
         {
             # seed the array of line names with the pathname.
             pathname = $2;

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

             # Done initialization things. Don't do this again.
             lastname=$2;
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

             if ( isOpenRank == 1 )  # Close any open rank
             {
                 printf("}\n");
                 isOpenRank=0;
             }
             printf("\nsubgraph cluster_%s {\n",linename);
             if ( NR < 100 )  # Simplified since we don't track linei anymore
                 printf("graph [ fontsize = 150 ]");
             else if ( NR < 200 )
                 printf("graph [ fontsize = 100 ]");
             else
                 printf("graph [ fontsize = 50 ]");

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
                 print elementname " " nOccurrence > "/dev/stderr";
             }

             # Read and record occurrence number (to put in parenthesis in
             # output), and S and Z.
             #
             elementNOccurrencesm[ elementname ] = nOccurrence;
             elementSm[elementname nOccurrence] = $4;
             elementZm[elementname nOccurrence] = $8;

             ## DBG
             print "survey f index:" sindex "\t" "elem name: " elementname > "/dev/stderr";

             # For each first occurrence, record the element name
             if ( nOccurrence == 1 )
             {
                 namei++;
                 elementnames[namei] = elementname;   # keep a list of all element names.
                 occurrenceNodeName = elementname;
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
            nocc = elementOccurrencesm[ elname ];
            printf("%s [ label = <%s ",elname, elname)
            printf("<BR/>%s %f / %f",
                   elementnametypem[elname],
                   elementSm[elname "1"], elementZm[elname "1"]);
            printf(" >];\n");

            for ( iocc=2; iocc<=nocc; iocc++ )
            {
                nodeName = elname "_" iocc;
                printf("%s [ label = <%s(%d) ",nodeName, elname, iocc);
                printf("<BR/>%s %f / %f",
                   elementnametypem[elname],
                   elementSm[elname iocc], elementZm[elname iocc]);
                printf(" >];\n");

            }
        }
    }
    print "}"; # end the main digraph

}
