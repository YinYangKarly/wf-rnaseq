// Include modules and RNA-Bloom2  workflow
include { MINIMAP2_ALIGN as MINIMAP2_ALIGN_RNABLOOM2 }          from './modules/minimap2.nf'
include { GFFREAD_RNA as GFFREAD_RNABLOOM2}                     from './modules/gffread.nf'
include { BAM2GFF as BAM2GFF_RNABLOOM2 }                        from './modules/bam2gff.nf'

workflow FATOGTF {
    // Definition of the input
    take:
        rnabloomtrans
        referenceFa
        
    // Main part to connect the modules
    main:
        MINIMAP2_ALIGN_RNABLOOM2(rnabloomtrans, referenceFa,"bam")
        BAM2GFF_RNABLOOM2(MINIMAP2_ALIGN_RNABLOOM2.out.bam)
        GFFREAD_RNABLOOM2(BAM2GFF_RNABLOOM2.out.gff)
    
    // What is emitted to the next workflow
    emit:
        minimap2_bam = MINIMAP2_ALIGN_RNABLOOM2.out.bam
        out_gff = BAM2GFF_RNABLOOM2.out.gff
        out_gtf = GFFREAD_RNABLOOM2.out.gtf
}
