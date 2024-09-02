process ZIPPING {   
    tag "$meta.id"
    
    container 'https://depot.galaxyproject.org/singularity/ubuntu:20.04'
    
    input:
    tuple val(meta), path(longread)
   
    output:
    tuple val(null), file("*.fastq") , emit: fastqfile
   
    shell:
    '''
    gunzip -c !{longread} > !{meta.id}.fastq
    '''
}