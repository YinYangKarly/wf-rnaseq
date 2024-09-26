process ADD_COVERAGE2 {
    label "process_single"

  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:22.04' :
        'ubuntu:22.04' }"

    input:
    tuple val(meta), path(cov)
    tuple val(meta2), path(tmapFile)

    output:
    tuple val(meta), path("New_*.tmap"), optional: true, emit: tmapNew


    script:
    """
    #!/bin/bash
    awk 'FNR==NR{                        	                                                                         	 
        a[\$1]=\$NF                     	                                                       	 
        next                          	                                                                         	 
    }
    {
    print \$0,(\$4 in a?a[\$4]:"NA") 	                  	 
    }' ${cov} ${tmapFile} > New_${meta.id}.gtf.tmap
    """
}