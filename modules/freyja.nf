process freyja{ 

fasta_ref = file(params.reference)

publishDir "${params.outdir}/variants/", mode: 'copy', pattern:'*'
  tag "$name"



  input:

  tuple val(name), file(alignment), file(reference_genome) 
  

  output:
  tuple val(name), file("${name}_final.tsv"),               emit: abundances

  when: 
  !(name ==~ /^Blank.*/)

	shell:
	
  //rm ${params.outdir}/freyja_alignments/Blank*
	"""
  
  
    freyja variants ${alignment} --variants ${name}_freyja_variants.tsv --depths ${name}_freyja_depths --ref !{reference_genome}
	  freyja demix ${name}_freyja_variants.tsv ${name}_freyja_depths --output ${name}_final.tsv
  
	"""
}