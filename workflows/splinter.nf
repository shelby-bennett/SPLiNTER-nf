#!/usr/bin/env nextflow



//Description: Workflow for quality control of raw illumina reads and Wastewater variant analysis

//Original monroe Author: Kevin Libuit

// Monroe DSL2 adjustment: Lynn Dotrang

// Wastewater implementation: Shelby Bennett
nextflow.enable.dsl = 2

//starting parameters



/*
========================================================================================
    IMPORT MODULES
========================================================================================
*/

include { preProcess             }        from '../modules/preProcess.nf'
include { trimmomatic            }        from '../modules/trimmomatic.nf'
include { cleanreads             }        from '../modules/cleanreads.nf'
include { ivar                   }        from '../modules/ivar.nf'
include { samtools               }        from '../modules/samtools_coverage.nf'
include { pangolin_typing        }        from '../modules/pangolin_typing.nf'
include { assembly_results       }        from '../modules/assembly_results.nf'
include { freyja                 }        from '../modules/freyja.nf'




workflow splinter {

  take:
  raw_reads
  bed
  ref

  main:
  
  //MODULE: preProcess
  preProcess(raw_reads)

  //MODULE: trimmomatic
  trimmomatic(preProcess.out.reads)

  //MODULE: cleanreads
  cleanreads(trimmomatic.out.trimmed_reads)

  //MODULE: ivar
  //ch_cleaned_reads_combine = cleanreads.out.cleaned_reads.combine(bed)

  ivar(cleanreads.out.cleaned_reads.combine(bed))

  //MODULE: samtools_coverage
  samtools(ivar.out.alignment_file)

  //MODULE: pangolin_typing
  pangolin_typing(ivar.out.assembled_genomes)

  //MODULE: assembly_results; moved to main.nf
  //assembly_results(samtools.out.alignment_qc.collect(),pangolin_typing.out.pangolin_lineages.collect())

  //MODULE: freyja
  freyja(ivar.out.freyja_alignment_file.combine(ref))



  emit:

  ch_samtools_cov = samtools.out.alignment_qc
  ch_pangolin_lineage = pangolin_typing.out.pangolin_lineages
  ch_freyja_abundance = freyja.out.abundances
}
