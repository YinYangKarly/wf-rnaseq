include { ARRIBA_ARRIBA as ARRIBA_RNABLOOM2 }                     from '../../modules/nf-core/arriba/arriba/main'
include { STARLONG as STAR_FOR_RNABLOOM2 }                        from './modules/STARlong.nf'


workflow STARLONG_ARRIBA {
    take:
        fastarnabloom2
        starindex_ref
        gtf
        fasta
        arriba_ref_blacklist
        arriba_ref_known_fusions
        arriba_ref_protein_domains
    
    main:
        STAR_FOR_RNABLOOM2( fastarnabloom2, starindex_ref, gtf, params.star_ignore_sjdbgtf, '', params.seq_center ?: '')
        ARRIBA_RNABLOOM2 ( STAR_FOR_RNABLOOM2.out.bam_sorted, fasta, gtf, arriba_ref_blacklist, arriba_ref_known_fusions, [[],[]], [[],[]], arriba_ref_protein_domains )
       // versions = versions.mix(ARRIBA_RNABLOOM2.out.versions)

        arriba_fusions     = ARRIBA_RNABLOOM2.out.fusions
        arriba_fusion_fail = ARRIBA_RNABLOOM2.out.fusions_fail.map{ meta, file -> return file}

     emit:
        bamFile         = STAR_FOR_RNABLOOM2.out.bam_sorted
        fusions         = arriba_fusions
        fusions_fail    = arriba_fusion_fail
}