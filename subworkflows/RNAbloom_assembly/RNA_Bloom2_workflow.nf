// Include module for rnabloom2
// Include subworkflow fa to gtf.
include { RNABLOOM2_ASSEMBLY as Rnabloom }                from "./modules/rnabloom2.nf"
//include { FATOGTF as Fatogtf }                            from "./Fa_to_gtf.nf"

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
