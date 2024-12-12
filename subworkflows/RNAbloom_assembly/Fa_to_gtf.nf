// Imported modules
include { MINIMAP2_ALIGN as MINIMAP2_ALIGN_RNABLOOM2 }          from '../../modules/nf-core/minimap2/align/main.nf'
include { GFFREAD as GFFREAD_RNABLOOM2}                         from '../../modules/nf-core/gffread/main.nf'
include { BAM2GFF as BAM2GFF_RNABLOOM2 }                        from './modules/bam2gff.nf'
include { GFFCOMPARE as GFFCOMPARE_RNABLOOM2}                   from "../../modules/nf-core/gffcompare/main.nf"
include { REMOVE_PART_HEADER as REMOVE_PART_HEADER_RNABLOOM2 }  from './modules/Remove_header.nf'
include { GFFCOMPARE as GFFCOMPARE_RNABLOOM2_2 }                from "../../modules/nf-core/gffcompare/main.nf"
include { GFFCOMPARE as GFFCOMPARE_RNABLOOM2_PER_SAMPLE }       from "../../modules/nf-core/gffcompare/main.nf"
include { ADD_COVERAGE1 as ADD_COVERAGE1 }                      from "./modules/Add_coverage.nf"
include { ADD_COVERAGE2 as ADD_COVERAGE2 }                      from "./modules/Add_cov.nf"
include { GENERATE_PLOTS as GENERATE_PLOTS }                     from "./modules/Coverage_plots.nf"

//Start of the workflow
workflow FATOGTF {
    //Input are given for the pipeline
    take:
        rnabloomtrans
        referenceFa
        referenceFastaFai
        referenceGtfFile
        
    // Main part to connect the modules
    main:
        //Adjust the fasta header of RNA-Bloom2
        REMOVE_PART_HEADER_RNABLOOM2(rnabloomtrans)
        
        //Align fasta file with minimap against the human reference genome
        MINIMAP2_ALIGN_RNABLOOM2(rnabloomtrans, referenceFa, true, false, false)
        
        //Use bam2gff to convert the BAM file to gff file
        BAM2GFF_RNABLOOM2(MINIMAP2_ALIGN_RNABLOOM2.out.bam)

        //Use gffread to convert the gff file to gtf file
        GFFREAD_RNABLOOM2(BAM2GFF_RNABLOOM2.out.gff, referenceFa[1])
       
        //Use gffcompare to run it on per sample for novel transcript detection per sample   
        GFFCOMPARE_RNABLOOM2_PER_SAMPLE(GFFREAD_RNABLOOM2.out.gtf, referenceFa << referenceFastaFai[1], referenceGtfFile)
        
        //Create a list the transcripts name and their coverage
        ADD_COVERAGE1(rnabloomtrans)

        //Add the coverage information to the gtf.tmap file
        ADD_COVERAGE2(ADD_COVERAGE1.out.covInfo, GFFCOMPARE_RNABLOOM2_PER_SAMPLE.out.tmap)
        
        //Generate the coverage distribution plots
        GENERATE_PLOTS(ADD_COVERAGE2.out.tmapNew)
        
        //Combines all samples of the Gffread output together into a single list, which is then used in Gffcompare
        GFFREAD_RNABLOOM2.out.gtf.map {instance ->
        gtf = instance[1]
        return [[id:"combined"], gtf]}.groupTuple().set{GFFread_output}
        GFFCOMPARE_RNABLOOM2(GFFread_output, referenceFa << referenceFastaFai[1], referenceGtfFile)
        GFFCOMPARE_RNABLOOM2_2(GFFCOMPARE_RNABLOOM2.out.combined_gtf, referenceFa << referenceFastaFai[1], referenceGtfFile)
        
       //Runs Gffcompare with grouped output of gffread, referencegenome, and referenceGtfFile if present. 
       gtf = GFFCOMPARE_RNABLOOM2_2.out.annotated_gtf.map {it[1]}.collect().concat(GFFCOMPARE_RNABLOOM2_2.out.combined_gtf.map {it[1]}.collect())
       
       //It won't use the referenceGtfFile when performing Gff_Compare, which means it uses the novel approach, which creates combined_gtf output rather than annotated.
       gtf_with_meta_rnabloom2 = GFFCOMPARE_RNABLOOM2_2.out.annotated_gtf.collect().concat(GFFCOMPARE_RNABLOOM2_2.out.combined_gtf.collect())

    //Emit the output of the workflow
    emit:
        fasta_changed_header = REMOVE_PART_HEADER_RNABLOOM2.out.fasta2
        minimap2_bam = MINIMAP2_ALIGN_RNABLOOM2.out.bam
        out_gff = BAM2GFF_RNABLOOM2.out.gff
        out_gtf = GFFREAD_RNABLOOM2.out.gtf
        out_gtf_def = gtf_with_meta_rnabloom2
}
