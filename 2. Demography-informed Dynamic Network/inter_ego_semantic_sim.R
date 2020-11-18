library(lsmeans)
library(emmeans)
library(ARTool)
library(ggpubr)
library(phia)

######### Load data ######### 
df = read.csv("data/NumPopAlters_condition_factorial.csv")
df$Condition = factor(df$Condition) # convert to nominal factor
df$NumPopAlters = factor(df$NumPopAlters) # convert to nominal factor


######### Plot with CI intervals ######### 
ggline(df, x = "NumPopAlters", y = "Cosine_sim", color = "Condition", add = c("mean_ci"))


####### ARTool ##########
mart = art(Cosine_sim ~ NumPopAlters * Condition, data=df) # uses LMM
anova(mart) # report anova

#main effects
emmeans(artlm(mart, "NumPopAlters"), pairwise ~ NumPopAlters,adjust=c("holm"))
emmeans(artlm(mart, "Condition"), pairwise ~ Condition,adjust=c("holm"))
#interaction
testInteractions(artlm(mart, "NumPopAlters:Condition"), pairwise=c("NumPopAlters", "Condition"), adjustment="holm")

# pairwise 2-tailed-tests
mu = aov(Cosine_sim ~ NumPopAlters*Condition, data=df) 
lsmeans(mu, pairwise~NumPopAlters*Condition, adjust="holm")

# Manual mann-whitnet U tests, alternative non-param results of the 2-tailed test. Insert if reviewers want.
# ctrl_df = df[df$Condition == "control",]
# pairwise_wilcox_test(
#  ctrl_df,
#  Cosine_sim ~ NumPopAlters,
#  p.adjust.method = "holm",
#  detailed = TRUE
#)

# trt_df = df[df$Condition == "treatment",]
# pairwise_wilcox_test(
#  trt_df,
#  Cosine_sim ~ NumPopAlters,
#  p.adjust.method = "holm",
#  detailed = TRUE,
#  paired=FALSE
#)
