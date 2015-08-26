# Print Header
#
# Import a header from a file and print it.
#
# @author Sean Ephraim
# @param file Name of header file
function print_header(file) {
  # Print header
  while (( getline < file) > 0 ) {
     print
  }
  close(file)
}

# Parse AC AN AF
#
# Parse out and compute the AC, AN, and AF for an EVS variant.
#
# Example variant:
# 22 24199764 rs66928071 AC ACC,ACCCC,ACCC,A ... EA_AC=792,151,754,865,4244;...
# Example input (e.g. EA_AC):
#   "792,151,754,865,4244"
# Example output (i.e. AC, AN, AF):
#   ["792,151,754,865", "6806", "0.116368,0.0221863,0.110785,0.127094"]
#
# @author Sean Ephraim
# @param orig_ac  Original string containing allele counts in the order of AltAlleles,RefAllele 
# @param ac_an_af Array to store the final AC, AN, and AF values
function parse_ac_an_af(orig_ac, ac_an_af) {
  len_alts_ref = split(orig_ac, alts_ref, ",")
  ac = alts_ref[1] # AC (first only)
  an = 0           # AN
  for (i = 1; i <= len_alts_ref; i++) {
    # Add up all counts (ref and alt) to make AN
    an += alts_ref[i]

    # Append any subsequent ACs
    if (i > 1 && i < len_alts_ref) {
      ac = ac "," alts_ref[i]
    }
  }

  # Calculate AF
  for (i = 1; i < len_alts_ref; i++) {
    if (i == 1) {
      # Add first AF
      af = alts_ref[i]/an
    }
    else {
      # Append any subsequent AFs
      af = af "," alts_ref[i]/an
    }
  }

  # Set AC, AN, AF
  ac_an_af[1] = ac
  ac_an_af[2] = an
  ac_an_af[3] = af
}
