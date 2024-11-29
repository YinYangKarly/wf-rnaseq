process GENERATE_PLOTS {
    tag "$meta.id"
    fair true

    conda "r-stringr"
    conda "r-ggplot2"

    input:
    tuple val (meta), path(tmapFileNew)

    output:
    tuple val (meta), path("${meta.id}_coverage_novel_transcripts.png")

    script:
    """
    #!${params.r_env}
    library(ggplot2)
    library(stringr)
    tmapFile <- read.csv("${tmapFileNew}", sep = "\t", header = TRUE)

    novel <- tmapFile[c("i", "j", "m", "n", "o", "r", "u", "y") %in% tmapFile\$class_code,]
    split_cov_column_novel <-str_split_fixed(novel\$ref_match_len.NA, " ", 2)
    split_cov_column_novel_df <- data.frame(split_cov_column_novel)
    number_novel <- strsplit(split_cov_column_novel_df\$X2, "=")

    number_cov_novel <- as.numeric(do.call("rbind", number_novel)[, 2])
    cov_div_len_novel = number_cov_novel / novel\$len
    cov_div_len_df_novel = data.frame(cov_div_len_novel)

    png("${meta.id}_coverage_novel_transcripts.png")
    ggplot(cov_div_len_df_novel, aes(x = cov_div_len_novel*1000)) + geom_histogram() +
      xlab("Log10 scale coverage") + ggtitle("Coverage distribution of RNA-Bloom2 novel transcripts") +
      theme(plot.title = element_text(hjust = 0.5))  + scale_x_log10()
    dev.off()
    """
}
