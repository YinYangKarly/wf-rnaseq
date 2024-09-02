process JAFFAL {
    echo true
    label 'process_medium'

   // conda "bioconda::jaffa=2.3.0"
   // container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
     //   'https://depot.galaxyproject.org/singularity/jaffa:2.3--hdfd78af_0' :
       // 'quay.io/biocontainers/jaffa:2.3--hdfd78af_0' }"

    //container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
      //  'https://depot.galaxyproject.org-singularity-jaffa_2.2--hdfd78af_0' :
        //'quay.io/biocontainers/jaffa:2.2--hdfd78af_0' }"

    input:
    tuple val(meta), path(fastq)
    path jaffal_ref_dir

    output:
    tuple val(meta), path("*.fasta"), emit: jaffal_fastq
    path "*.csv"                    , emit: jaffal_results
    path "versions.yml"             , emit: versions

    when:
    task.ext.when == null || task.ext.when

///exports/sascstudent/kaelias/scripts/test_scripts/JAFFA-version-2.3/tools/bin/bpipe run -p refBase=$jaffal_ref_dir $jaffal_ref_dir/JAFFA_direct.groovy $fastq

    script:
    """
    /exports/sascstudent/kaelias/scripts/test_scripts/JAFFA-version-2.3/tools/bin/bpipe run ${jaffal_ref_dir}/JAFFAL.groovy $fastq

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        jaffa: \$( echo 'jaffa 2.3' )
    END_VERSIONS
    """
}
