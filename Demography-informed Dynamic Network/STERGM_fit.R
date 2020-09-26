library(igraph)
library(statnet)
library(intergraph)
library(ergm)
library(sna)
library(network)
library(foreign)
library(ergm.userterms)
library(Matrix)
library(ergm.count)
library(coda)
library(tergm)

logit2prob <- function(logit){
  odds <- exp(logit)
  prob <- odds / (1 + odds)
  return(prob)
}

# user input
start.round = 1
end.round = 6
condition = "tf" # cf for control, tf for treatment

#preprocessing
cc = ""
if (condition=="cf") {
    cc="FULL10_control" #FULL8 is final, full9 has cq ###FULL4 works, FULL2 is the entire old+new control
} else if (condition=="tf") {
    cc="FULL10_treatment"
} 

network_collection <- list()

for (i in start.round:end.round){
  # load connection info
  dir = paste("data/R",toString(i),"_",cc,"_network.csv", sep = "")
  bip_edgelist = read.csv(dir, stringsAsFactors = F) #data frame
  bipMatrix = table(bip_edgelist)
  class(bipMatrix) <- "matrix" #we convert it from a table to a matrix
  bipNet <- graph.incidence(bipMatrix, mode = c("all"))
  
  # load attributes
  attr_dir = paste("data/R",toString(i),"_",cc,"_attr.csv", sep = "")
  attributes = read.csv(attr_dir, stringsAsFactors = F) #data frame
  
  # link attributes to nodes
  linked_ids <- match(V(bipNet)$name, attributes$name)
  
  # convert to ergm network
  teamnet <- network(bipMatrix, directed=FALSE, loops=FALSE, bipartite=TRUE,
                      matrix.type="bipartite")
  
  teamnet%v%"gender" <- attributes$gender[linked_ids]
  teamnet%v%"race" <- attributes$race[linked_ids]
  teamnet%v%"age" <- attributes$age[linked_ids]
  teamnet%v%"unique" <- attributes$unique[linked_ids]
  teamnet%v%"shapley" <- attributes$shapley[linked_ids]
  teamnet%v%"cq" <- attributes$cq[linked_ids]
  teamnet%v%"trial" <- attributes$trial[linked_ids]
  
  network_collection[[i]] <- teamnet
}

# fit STERGM model
set.seed(1234)
samp.fit <- stergm(network_collection,
                   formation= ~edges+b2cov("unique")+b1star(1, attr="gender")+b1star(1, attr="race"),
                   dissolution = ~edges+b2cov("unique")+b1star(1, attr="gender")+b1star(1, attr="race"),
                   estimate = "CMLE",
                   times=start.round:end.round)

summary(samp.fit)

#gof.fit <- gof(samp.fit)
#plot(gof.fit)
#print(gof.fit)

