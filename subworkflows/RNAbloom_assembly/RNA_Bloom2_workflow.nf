// Include module for rnabloom2.
include { RNABLOOM2_ASSEMBLY as Rnabloom }                from "./modules/rnabloom2.nf"

workflow RNABLOOM2 {
    take:
        reads
        transcriptFast
        referenceFast
    
    main:
        Rnabloom(reads, transcriptFast)
       
    emit:
        outputDir = Rnabloom.out
        fastaRNABloom = Rnabloom.out.fa
}
