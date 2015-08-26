#!/bin/awk -f

# NOTE: This script requires lib.awk

##
# Input fields:
# $1:  CHROM
# $2:  POS
# $3:  ID
# $4:  REF
# $5:  ALT
# $6:  QUAL
# $7:  FILTER
# $8:  EA_AC
# $9:  AA_AC
# $10: TAC (total allele count)
##

BEGIN {
  FS="\t"
  OFS="\t"
  # Print the VCF header
  print_header(".includes/new_header.txt")
}

# Print variant records
/^[^#]/ {
  # Get EVS_EA_AC, EVS_EA_AN, EVS_EA_AF
  parse_ac_an_af($8, ea_ac_an_af)

  # Get EVS_AA_AC, EVS_AA_AN, EVS_AA_AF
  parse_ac_an_af($9, aa_ac_an_af)

  # Get EVS_ALL_AC, EVS_ALL_AN, EVS_ALL_AF
  parse_ac_an_af($10, all_ac_an_af)

  # Print record
  print $1, $2, $3, $4, $5, $6, $7, "DBSNP=" $11 ";EVS_ALL_AC=" all_ac_an_af[1] ";EVS_ALL_AN=" all_ac_an_af[2] ";EVS_ALL_AF=" all_ac_an_af[3] ";EVS_EA_AC=" ea_ac_an_af[1] ";EVS_EA_AN=" ea_ac_an_af[2] ";EVS_EA_AF=" ea_ac_an_af[3] ";EVS_AA_AC=" aa_ac_an_af[1] ";EVS_AA_AN=" aa_ac_an_af[2] ";EVS_AA_AF=" aa_ac_an_af[3]
}
