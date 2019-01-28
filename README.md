This app is ...

* deployed on <a href="https://saezlab.shinyapps.io/footprint_scores" target="_blank">https://saezlab.shinyapps.io/signaling_resource</a>

* designed to interactively explore a large resource of TF/Pathway activities for perturbation and disease experiments in mice and humans.

* developed and maintained by Christian Holland (<a href="mailto:christian.holland@bioquant.uni-heidelberg.de" target="_blank"><i class="glyphicon glyphicon-envelope"></i></a>) at the <a href="http://saezlab.org" target="_blank">Saezlab</a>, Institute for Computational Biomedicine, University of Heidelberg.

* developed using <a href="https://shiny.rstudio.com" target="_blank">Shiny</a>.

---

<i class="fab fa-github"></i> Source code is available on <a href="https://github.com/saezlab/ShinyFootprintScores" target="_blank">GitHub</a>.

<i class="fas fa-question"></i> Please use <a href="https://github.com/saezlab/ShinyFootprintScores/issues" target="_blank">GitHub's issue system</a> to address questions, bugs or feedback. 

---

#### Transfer of regulatory knowledge from human to mouse for functional genomic analysis
**Abstract:** Transcriptome profiling followed by differential gene expression analysis often leads to unclear lists of genes which are hard to analyse and interpret. Functional genomic tools are useful approaches for downstream analysis, as they summarize the large and noisy gene expression space in a smaller number of biological meaningful features. In particular, methods that estimate the activity of processes by mapping transcripts level to process members are popular. Recently, footprints of either a pathway or transcription factor (TF) on gene expression showed superior performance over these mapping-based gene sets. These footprints are largely developed for human and their usability in the broadly-used model organism Mus musculus is uncertain. Evolutionary conservation of the gene regulatory system suggests that footprints of human pathways and TFs can functionally characterize mouse data. In this paper we analyze this hypothesis. We perform a comprehensive benchmark study exploiting two state-of-the-art footprint methods, DoRothEA and an extended version of PROGENy. These methods infer TF and pathway activity, respectively. Our results show that both can recover mouse perturbations, confirming our hypothesis that footprints are conserved between mice and humans. Subsequently, we illustrate the usability of PROGENy and DoRothEA by recovering pathway/TF-disease associations from newly generated disease sets. Additionally, we provide pathway and TF activity scores for a large collection of human and mouse perturbation and disease experiments. We believe that this resource, available for interactive exploration and download (saezlab.shinyapps.io/signaling_resource), can have broad applications including the study of diseases and therapeutics.
