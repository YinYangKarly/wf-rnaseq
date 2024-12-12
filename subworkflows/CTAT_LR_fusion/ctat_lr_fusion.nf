//Self-made module of CTAT-LR Fusion tool
process CTAT_LR_FUSION {
    tag "$meta.id"
    label 'process_high'
    fair true

   // container 'https://depot.galaxyproject.org/singularity/singularity:3.8.6'
    
    input:
    tuple val(meta), path(longread)
   
    output:
    tuple val(meta), path("ctat_LR_fusion_outdir/")

    script:
    """
    singularity exec -e  -B ${workflow.workDir} -B ${params.genome_lib} ${params.sing_ctat} \\ctat-LR-fusion -T ${longread} --genome_lib_dir ${params.genome_lib} --vis
    """

}
