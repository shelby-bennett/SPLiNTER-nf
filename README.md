# SPLiNTER-nf

SPLiNTER is a Nextflow DSL2 bioinformatics pipeline for the analysis of short read (Illumina) whole genome sequencing data of DNA extracted from wastewater. It was created by using a modified version of the [Monroe PE QC bioinformatics pipeline](https://github.com/LeuThrAsp/monroe_pe_assembly-nf) and [Freyja](https://github.com/andersen-lab/Freyja).

## Introduction
SPLiNTER uses uses a reference-based alignment to determine the number of SNPs in each sample and derive QC metrics and assembly data. Freyja is then used to calculate the relative lineage abundance.

## Dependencies
- Nextflow v21+
- conda3


## Usage
At this time, full paths are required to launch the pipeline. 

```
nextflow run ~/splinter-nf/main.nf --reads {input} -profile docker --primerPath {path_to_bedfile} 
             \ --reference {path_to_ref} --outdir {output}

```

### Future work
Future development will involve manipulating the Freyja output so that it is more usable in R
