# Companion Code for "Creativity in temporal social networks: How divergent thinking is impacted by one's choice of peers"

This repository holds the codebase for the paper,

Baten RA, Bagley D, Tenesaca A, Clark F, Bagrow JP, Ghoshal G, Hoque ME, Creativity in temporal social networks: How divergent thinking is impacted by one's choice of peers. _Journal of the Royal Society Interface_, (accepted; [arXiv preprint arXiv:1911.11395](https://arxiv.org/pdf/1911.11395.pdf)), September 2020


## What's in this Repository
1. All the preprocessing code is held in the preprocessing_code.ipynb file. Due to the copyright protection of the Alternative Uses Test, we cannot release the raw data which this file takes as input. Instead, sample data files are given in the data/ folder to enable the reader follow along the code. The code is explained with inline comments.

2. The analysis_code.ipynb file takes the preprocessed data, and generates the analysis results in the paper. 

3. The art_fig5.R file takes a data csv file as input, and analyzes the data using Aligned Rank Transform, a Linear Mixed Model based non-parametric test. This test controls for multiple comparisons as well as repeated measures in a factorial design setup.

4. The simulation_model.ipynb file holds the code for the agent-based simulation model described in the paper.

## Key Technologies Used
Key technologies/algorithms/models used in these files include 

- **Word2Vec**
- **Creativity Quotient** (uses **WordNet**) 
- **Linear Regression**
- **One-mode Projection of Bipartite Networks**
- **Word Mover's Distance**
- **Aligned Rank Transform** (uses **Linear Mixed Model**)
- **Agent-based Simulation**
- **Statistical Tests with Multiple Comparison and Repeated Measures Correction**

