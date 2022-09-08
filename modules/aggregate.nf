process aggregate {
	publishDir "${params.outdir}", mode: 'copy'
	
	input:
	file(freyja_abundances)

	output:
	file("aggregated_results.tsv")

	shell:
	"""
	mkdir tmp

	mv !{freyja_abundances} tmp/.

	freyja aggregate tmp/ --output aggregated_results.tsv 
	"""

}