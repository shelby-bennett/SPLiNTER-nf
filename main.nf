#!/usr/bin/env nextflow



//Description: Workflow for quality control of raw illumina reads

//Author: Kevin Libuit

//DSL2 adjustment: Lynn Dotrang

nextflow.enable.dsl = 2

//starting parameters


params.reads = ""

params.outdir = ""

//params.primerSet = workflow.projectDir + "/configs/neb_vss2b.primer.bed"

params.primerPath = ""

params.reference = ""

params.report = ""

params.pipe = ""

//setup channel to read in and pair the fastq files

Channel

    .fromFilePairs(  "${params.reads}/*{R1,R2,_1,_2}*.{fastq,fq}.gz", size: 2 )

    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.reads}\nNB: Path needs to be enclosed in quotes!\nIf this is single-end data, please specify --singleEnd on the command line." }

    .set { raw_reads }


Channel

  .fromPath(params.primerPath, type:'file')

  .ifEmpty{

    println("A bedfile for primers is required. Set with 'params.primerPath'.")

    exit 1

  }

  .view { "Primer BedFile : $it"}

  .set { primer_bed }


Channel 

	.fromPath(params.reference, type:'file')
	
  .ifEmpty{ 
    println("No reference genome was selected. Set with 'params.reference'")
    
    exit 1
    
}
	
  .set { reference_genome } 


// include the workflow
include { splinter               }        from './workflows/splinter.nf'
include { assembly_results       }        from './modules/assembly_results.nf'
include { aggregate              }        from './modules/aggregate.nf'

//if you say nothing next to the workflow name (do not name process) then it will be the main workflow
workflow {
    splinter(raw_reads, primer_bed, reference_genome)

    //MODULE: assembly_results
    ch_cg_pipeline_results = splinter.out.ch_samtools_cov.collect()
    ch_pangolin_lineage = splinter.out.ch_pangolin_lineage.collect()
    assembly_results(ch_cg_pipeline_results, ch_pangolin_lineage)

    //MODULE: aggregate

    ch_freyja_abundance = splinter.out.ch_freyja_abundance.collect()
    aggregate(ch_freyja_abundance)
}
