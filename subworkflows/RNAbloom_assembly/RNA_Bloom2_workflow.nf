// Import module
include { RNABLOOM2_ASSEMBLY as Rnabloom }                from "./modules/rnabloom2.nf"

//Start of the workflow
workflow RNABLOOM2 {
    //Input are given for the workflow
    take:
        reads
        transcriptFast
        referenceFast
    
    //RNA-Bloom2 assembly
    main:
        Rnabloom(reads, transcriptFast)

    //Emit the output files of the workflow   
    emit:
        outputDir = Rnabloom.out
        fastaRNABloom = Rnabloom.out.fa
}
