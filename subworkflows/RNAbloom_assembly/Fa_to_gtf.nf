// Include modules and RNA-Bloom2  workflow
include { MINIMAP2_ALIGN as MINIMAP2_ALIGN_RNABLOOM2 }          from '../../modules/nf-core/minimap2/align/main.nf'
include { GFFREAD as GFFREAD_RNABLOOM2}                         from '../../modules/nf-core/gffread/main.nf'
include { BAM2GFF as BAM2GFF_RNABLOOM2 }                        from './modules/bam2gff.nf'
include { GFFCOMPARE as GFFCOMPARE_RNABLOOM2}                   from "../../modules/nf-core/gffcompare/main.nf"
include { REMOVE_PART_HEADER as REMOVE_PART_HEADER_RNABLOOM2 }  from './modules/Remove_header.nf'
include { GFFCOMPARE as GFFCOMPARE_RNABLOOM2_2 }                from "../../modules/nf-core/gffcompare/main.nf"
include { GFFCOMPARE as GFFCOMPARE_RNABLOOM2_PER_SAMPLE }       from "../../modules/nf-core/gffcompare/main.nf"
include { ADD_COVERAGE1 as ADD_COVERAGE1 }                      from "./modules/Add_coverage.nf"
include { ADD_COVERAGE2 as ADD_COVERAGE2 }                      from "./modules/Add_cov.nf"


workflow FATOGTF {
    // Definition of the input
    take:
        rnabloomtrans
        referenceFa
        referenceFastaFai
        referenceGtfFile
        
    // Main part to connect the modules
    main:
        REMOVE_PART_HEADER_RNABLOOM2(rnabloomtrans)
        MINIMAP2_ALIGN_RNABLOOM2(rnabloomtrans, referenceFa, true, false, false)
        BAM2GFF_RNABLOOM2(MINIMAP2_ALIGN_RNABLOOM2.out.bam)
        GFFREAD_RNABLOOM2(BAM2GFF_RNABLOOM2.out.gff, referenceFa[1])
        GFFCOMPARE_RNABLOOM2_PER_SAMPLE(GFFREAD_RNABLOOM2.out.gtf, referenceFa << referenceFastaFai[1], referenceGtfFile)
        ADD_COVERAGE1(rnabloomtrans)
        ADD_COVERAGE2(ADD_COVERAGE1.out.covInfo, GFFCOMPARE_RNABLOOM2_PER_SAMPLE.out.tmap)
        GFFREAD_RNABLOOM2.out.gtf.map {instance ->
        gtf = instance[1]
        return [[id:"combined"], gtf]}.groupTuple().set{GFFread_output}
        GFFCOMPARE_RNABLOOM2(GFFread_output, referenceFa << referenceFastaFai[1], referenceGtfFile)
        GFFCOMPARE_RNABLOOM2_2(GFFCOMPARE_RNABLOOM2.out.combined_gtf, referenceFa << referenceFastaFai[1], referenceGtfFile)
        
        
       gtf = GFFCOMPARE_RNABLOOM2_2.out.annotated_gtf.map {it[1]}.collect().concat(GFFCOMPARE_RNABLOOM2_2.out.combined_gtf.map {it[1]}.collect())
       gtf_with_meta_rnabloom2 = GFFCOMPARE_RNABLOOM2_2.out.annotated_gtf.collect().concat(GFFCOMPARE_RNABLOOM2_2.out.combined_gtf.collect())

    // What is emitted to the next workflow
    emit:
        fasta_changed_header = REMOVE_PART_HEADER_RNABLOOM2.out.fasta2
        minimap2_bam = MINIMAP2_ALIGN_RNABLOOM2.out.bam
        out_gff = BAM2GFF_RNABLOOM2.out.gff
        out_gtf = GFFREAD_RNABLOOM2.out.gtf
        out_gtf_def = gtf_with_meta_rnabloom2
}
