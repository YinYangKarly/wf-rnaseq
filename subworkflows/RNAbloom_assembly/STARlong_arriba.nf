//Import modules
include { ARRIBA_ARRIBA as ARRIBA_RNABLOOM2 }                     from '../../modules/nf-core/arriba/arriba/main'
include { STARLONG as STAR_FOR_RNABLOOM2 }                        from './modules/STARlong.nf'
include { STAR_GENOMEGENERATE as Star_Genomegenerate}            from "../../modules/nf-core/star/genomegenerate/main.nf"

workflow STARLONG_ARRIBA {
    //Input are given for the workflow
    take:
        fastarnabloom2
        gtf
        fasta
        arriba_ref_blacklist
        arriba_ref_known_fusions
        arriba_ref_protein_domains
    
    //The main part of the workflow where modules are connected
    main:
        //If there is no path given to STAR indexed reference genome, generate the index for the reference genome
    	if (params.star_index == null) {
    	   Star_Genomegenerate(fasta[0,1], gtf)
    	}
        //Run STARlong alignment and then fusion detection with Arriba
        STAR_FOR_RNABLOOM2( fastarnabloom2, Star_Genomegenerate.out.index, gtf, params.star_ignore_sjdbgtf, '', params.seq_center ?: '')
        ARRIBA_RNABLOOM2 ( STAR_FOR_RNABLOOM2.out.bam_sorted, fasta, gtf, arriba_ref_blacklist, arriba_ref_known_fusions, [[],[]], [[],[]], arriba_ref_protein_domains )
       // versions = versions.mix(ARRIBA_RNABLOOM2.out.versions)

        arriba_fusions     = ARRIBA_RNABLOOM2.out.fusions
        arriba_fusion_fail = ARRIBA_RNABLOOM2.out.fusions_fail.map{ meta, file -> return file}

     //Emit the output of the workflow
     emit:
        bamFile         = STAR_FOR_RNABLOOM2.out.bam_sorted
        fusions         = arriba_fusions
        fusions_fail    = arriba_fusion_fail
}
