include { SEQTK_SEQ as SEQTK_RNABLOOM2 } from "../../modules/nf-core/seqtk/seq/main.nf"

workflow FATOFQ {
    take: 
    fasta

    main:
    SEQTK_RNABLOOM2(fasta)

    emit:
    fastq = SEQTK_RNABLOOM2.out.fastx
}