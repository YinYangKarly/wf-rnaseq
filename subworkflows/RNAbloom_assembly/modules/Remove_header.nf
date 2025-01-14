process REMOVE_PART_HEADER {
    tag "$meta.id"
    label "process_single"
    fair true

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:22.04' :
        'ubuntu:22.04' }"
    
    input:
    tuple val(meta), path(fasta)

    output:
    tuple val(meta), path("${meta.id}_withoutlengtcov.fa"), emit: fasta2
//| tr ">" "@" 
    script:
    """
    #!/bin/bash
    cat ${fasta} | awk -F ' ' '{print \$1}' > ${meta.id}_withoutlengtcov.fa 
    """
}
