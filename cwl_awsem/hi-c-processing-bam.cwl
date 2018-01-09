{
    "fdn_meta": {
        "title": "Hi-C Post-alignment Processing",
        "name": "hi-c-processing-bam",
        "data_types": [ "Hi-C" ],
        "category": "filter",
        "workflow_type": "Hi-C data analysis",
        "description": "Hi-C data processing pipeline"
    },
    "outputs": [
        {
            "id": "#annotated_bam",
            "type": [
                "File"
            ],
            "source": "#pairsam-filter.lossless_bamfile",
            "fdn_format": "bam",
            "fdn_output_type": "processed"
        },
        {
            "id": "#filtered_pairs_with_frags",
            "type": [
                "File"
            ],
            "source": "#addfragtopairs.pairs_with_frags",
            "fdn_format": "pairs",
            "fdn_output_type": "processed"
        }
    ],
    "cwlVersion": "draft-3",
    "steps": [
        {
            "fdn_step_meta": {
                "software_used": [ "pairsamtools_49489c" ],
                "description": "Parsing and sorting bam file",
                "analysis_step_types": [ "annotation", "sorting" ]
            },
            "outputs": [
                {
                    "id": "#pairsam-parse-sort.sorted_pairsam",
                    "fdn_format": "pairsam"
                }
            ],
            "inputs": [
                {
                    "id": "#pairsam-parse-sort.bam",
                    "source": "#input_bams",
                    "fdn_format": "bam"
                },
                {
                    "id": "#pairsam-parse-sort.chromsize",
                    "source": "#chromsize",
                    "fdn_format": "chromsize"
                },
                {
                    "id": "#pairsam-parse-sort.Threads",
                    "source": "#nthreads_parse_sort"
                }
            ],
            "run": "pairsam-parse-sort.cwl",
            "id": "#pairsam-parse-sort",
            "scatter": "#pairsam-parse-sort.bam"
        },
        {
            "fdn_step_meta": {
                "software_used": [ "pairsamtools_49489c" ],
                "description": "Merging pairsam files",
                "analysis_step_types": [ "merging" ]
            },
            "outputs": [
                {
                    "id": "#pairsam-merge.merged_pairsam",
                    "fdn_format": "pairsam"
                }
            ],
            "inputs": [
                {
                    "id": "#pairsam-merge.input_pairsams",
                    "source": "#pairsam-parse-sort.out_pairsam",
                    "fdn_format": "pairsam"
                },
                {
                    "id": "#pairsam-merge.nThreads",
                    "source": "#nthreads_merge"
                }
            ],
            "run": "pairsam-merge.cwl",
            "id": "#pairsam-merge"
        },
        {
            "fdn_step_meta": {
                "software_used": [ "pairsamtools_49489c" ],
                "description": "Marking duplicates to pairsam file",
                "analysis_step_types": [ "filter" ]
            },
            "outputs": [
                {
                    "id": "#pairsam-markasdup.dupmarked_pairsam",
                    "fdn_format": "pairsam"
                }
            ],
            "inputs": [
                {
                    "id": "#pairsam-markasdup.input_pairsam",
                    "source": "#pairsam-merge.merged_pairsam",
                    "fdn_format": "pairsam"
                }
            ],
            "run": "pairsam-markasdup.cwl",
            "id": "#pairsam-markasdup"
        },
        {
            "fdn_step_meta": {
                "software_used": [ "pairsamtools_49489c" ],
                "description": "Filtering duplicate and invalid reads",
                "analysis_step_types": [ "filter", "file format conversion" ]
            },
            "outputs": [
                {
                    "id": "#pairsam-filter.lossless_bamfile",
                    "fdn_format": "bam"
                },
                {
                    "id": "#pairsam-filter.filtered_pairs",
                    "fdn_format": "pairs"
                }
            ],
            "inputs": [
                {
                    "id": "#pairsam-filter.input_pairsam",
                    "source": "#pairsam-markasdup.out_markedpairsam",
                    "fdn_format": "pairsam"
                },
                {
                    "id": "#pairsam-filter.chromsize",
                    "source": "#chromsize",
                    "fdn_format": "chromsize"
                }
            ],
            "run": "pairsam-filter.cwl",
            "id": "#pairsam-filter"
        },
        {
            "fdn_step_meta": {
                "software_used": [ "pairix_0.3.3" ],
                "description": "Adding restriction enzyme site information",
                "analysis_step_types": [ "annotation" ]
            },
            "outputs": [
                {
                    "id": "#addfragtopairs.out_pairs",
                    "fdn_format": "pairs"
                }
            ],
            "inputs": [
                {
                    "id": "#addfragtopairs.input_pairs",
                    "source": "#pairsam-filter.dedup_pairs",
                    "fdn_format": "pairs"
                },
                {
                    "id": "#addfragtopairs.restriction_file",
                    "source": "#restriction_file",
                    "fdn_format": "juicer_format_restriction_site_file"
                }
            ],
            "run": "addfragtopairs.cwl",
            "id": "#addfragtopairs"
        }
    ],
    "requirements": [
        {
            "class": "InlineJavascriptRequirement"
        },
        {
            "class": "ScatterFeatureRequirement"
        }
    ],
    "class": "Workflow",
    "inputs": [
        {
            "id": "#input_bams",
            "type": [
                "null",
                {
                    "type": "array",
                    "items": "File"
                }
            ],
            "fdn_format": "bam"
        },
        {
            "id": "#chromsize",
            "type": [
                "File"
            ],
            "fdn_format": "chromsizes"
        },
        {
            "id": "#restriction_file",
            "type": [
                "File"
            ],
            "fdn_format": "juicer_format_restriction_site_file"
        },
        {
            "default": 8,
            "type": [
                "int"
            ],
            "id": "#nthreads_parse_sort"
        },
        {
            "default": 8,
            "type": [
                "int"
            ],
            "id": "#nthreads_merge"
        }
    ]
}