process ADD_COVERAGE1 {
    tag "$meta.id"
    fair true

    label "process_single"

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:22.04' :
        'ubuntu:22.04' }"

    input:
    tuple val(meta), path(fastaTranscript)
   
    output:
    tuple val(meta), path("Coverage_info.txt")  , optional: true, emit: covInfo

    script:
    """
    #!/bin/bash
    cat ${fastaTranscript} | grep ">" | awk '{print \$1,\$3}' | sed  "s/>//" > Coverage_info.txt
    """
}
