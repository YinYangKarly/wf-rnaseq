process BAM2GFF {
    tag "$meta.id"

    container "https://depot.galaxyproject.org/singularity/spliced_bam2gff:1.3--he881be0_1"

    input:
        tuple val(meta), path(bam)

    output:
        tuple val(meta), path("${meta.id}.gff"), emit: gff
    
    script:
    def args  = task.ext.args ?: ''
   // def prefix = task.ext.prefix ?: "${meta.id}"
    """
    spliced_bam2gff -M $bam > ${meta.id}.gff
    """

}