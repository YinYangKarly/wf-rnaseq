//include { RNABLOOM2 as Rnabloom2 } from "/exports/sascstudent/kaelias/scripts/wf-rnaseq-fusion//subworkflows/RNAbloom_assembly/RNA_Bloom2_workflow.nf"

process EXTRACTFASTA {
    tag "$meta.id"
    
    input:
        path(reads)
         
    output:
        tuple val(meta), file("rnabloom.transcripts.fa") from path(reads)
    
    script:
        "cat rmabloom2.transcripts.fa > rnabloom.transcripts.fa" 
}