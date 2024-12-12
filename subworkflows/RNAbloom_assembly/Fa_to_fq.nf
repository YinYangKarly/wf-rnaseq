//Import module
include { SEQTK_SEQ as SEQTK_RNABLOOM2 } from "../../modules/nf-core/seqtk/seq/main.nf"

//Start of the workflow
workflow FATOFQ {
    //Input is given for the workflow
    take: 
    fasta

    //Perform seqtk seq on the RNA-Bloom2 fasta file in the main part of the workflow.
    main:
    SEQTK_RNABLOOM2(fasta)

    //Emit the output file of the workflow (fastq.gz)
    emit:
    fastq = SEQTK_RNABLOOM2.out.fastx
}