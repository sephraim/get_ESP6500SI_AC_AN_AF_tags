#!/bin/bash

# Convert the downloadable ESP6500 VCF file into a more readable
# format that separates out the allele counts + frequencies in a way
# that is similar to 1000 Genomes.
#
# Requirements:
#   - bcftools must be in your $PATH
#
# Input:
#   - Original ESP6500 .vcf/vcf.gz/bcf/bcf.gz file
# Output:
#   - Altered ESP6500 .vcf.gz file (easier to read allele counts + freqs)
#   - Tabix index file
#
# Example usage:
# ./improve_ESP6500_VCF_readability.sh esp6500.sample.vcf esp6500.sample.NEW.vcf.gz

echo "Creating new EVS file for easier readability..."
bcftools query \
  -f '%CHROM\t%POS\t%ID\t%REF\t%ALT\t%QUAL\t%FILTER\t%INFO/EA_AC\t%INFO/AA_AC\t%TAC\t%DBSNP\n' \
  $1 \
  | awk -f .includes/lib.awk -f .includes/calculate_AC-AN-AF.awk \
  | bcftools convert -O z -o $2
echo "Done! Output written to $2"

echo "Creating tabix index file..."
bcftools index -ft $2
echo "Done! Output written to $2.tbi"
