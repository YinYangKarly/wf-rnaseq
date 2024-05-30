process MINIMAP2_ALIGN {
    tag "$meta.id"
    label 'process_high'

//    container "https://depot.galaxyproject.org/singularity/minimap2:2.28--he4a0461_0"
    container "https://depot.galaxyproject.org/singularity/mulled-v2-66534bcbb7031a148b13e2ad42583020b9cd25c4:3a70f8bc7e17b723591f6132418640cfdbc88246-0"
    input:
        tuple val(meta), path(reads)
        tuple val(meta2), path(reference)
        val bam_format
   

    output:
         tuple val(meta), path("${meta.id}.bam"), emit: bam
    
    script:
        def args  = task.ext.args ?: ''
        def prefix = task.ext.prefix ?: "${meta.id}"
        def bam_output = bam_format ? "-a | samtools sort -@ ${task.cpus} -o ${prefix}.bam" : "-o ${prefix}.paf"
    
    """
    minimap2 $args -t $task.cpus ${reference} ${reads} $bam_output
    """
 
}