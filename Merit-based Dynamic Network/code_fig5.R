library(lsmeans)
library("emmeans")
library("ARTool")
library(phia)
library(lme4) 
library(lmerTest)
library(car) 
library(multcomp)
library(reshape2)	
library(rstatix)
library(plyr)
library(ez)
library(dplyr)
library(xtable)
library("ggpubr")

######### Load data ######### 
df = read.csv("data/fig5.csv")
View(df)
df$egoID = factor(df$egoID) # convert to nominal factor
df$NumPopularAlters = factor(df$NumPopularAlters) # convert to nominal factor
df$roundID = factor(df$roundID) # convert to nominal factor
summary(df)


######### Plot fig 5 with CI intervals ######### 
df_plot <- df %>% select(NumPopularAlters, Jaccard,u, r, Q) 
my_sum <- df_plot %>%
  group_by(NumPopularAlters) %>%
  summarise( 
    n=n(),
    mean_u=mean(u),
    sd_u=sd(u),
    mean_r=mean(r),
    sd_r=sd(r),
    mean_Q=mean(Q),
    sd_Q=sd(Q),
    mean_j=mean(Jaccard),
    sd_j=sd(Jaccard)
  ) %>%
  mutate( se_u=sd_u/sqrt(n))  %>%
  mutate( se_r=sd_r/sqrt(n))  %>%
  mutate( se_Q=sd_Q/sqrt(n))  %>%
  mutate( se_j=sd_j/sqrt(n))  %>%
  mutate( ic_u=se_u * qt((1-0.05)/2 + .5, n-1))  %>%
  mutate( ic_r=se_r * qt((1-0.05)/2 + .5, n-1))  %>%
  mutate( ic_j=se_j * qt((1-0.05)/2 + .5, n-1))  %>%
  mutate( ic_Q=se_Q * qt((1-0.05)/2 + .5, n-1)) 

ggplot(my_sum) + geom_bar( aes(x=NumPopularAlters, y=mean_j), stat="identity", fill="skyblue", alpha=0.7) +
  geom_errorbar( aes(x=NumPopularAlters, ymin=mean_j-ic_j, ymax=mean_j+ic_j), width=0.4, 
                 colour="orange", alpha=0.9, size=1.5) + ggtitle("Jaccard")

ggplot(my_sum) + geom_bar( aes(x=NumPopularAlters, y=mean_u), stat="identity", fill="skyblue", alpha=0.7) +
  geom_errorbar( aes(x=NumPopularAlters, ymin=mean_u-ic_u, ymax=mean_u+ic_u), width=0.4, 
                 colour="orange", alpha=0.9, size=1.5) + ggtitle("u")

ggplot(my_sum) + geom_bar( aes(x=NumPopularAlters, y=mean_r), stat="identity", fill="skyblue", alpha=0.7) +
  geom_errorbar( aes(x=NumPopularAlters, ymin=mean_r-ic_r, ymax=mean_r+ic_r), width=0.4, 
                 colour="orange", alpha=0.9, size=1.5) + ggtitle("r")

ggplot(my_sum) + geom_bar( aes(x=NumPopularAlters, y=mean_Q), stat="identity", fill="skyblue", alpha=0.7) +
  geom_errorbar( aes(x=NumPopularAlters, ymin=mean_Q-ic_Q, ymax=mean_Q+ic_Q), width=0.4, 
                 colour="orange", alpha=0.9, size=1.5) + ggtitle("Q")


####### ARTool ##########
mJ = art(Jaccard ~ NumPopularAlters * roundID + (1|egoID), data=df) # uses LMM
anova(mJ) # report anova
emmeans(artlm(mJ, "NumPopularAlters"), pairwise ~ NumPopularAlters,adjust=c("holm"))
testInteractions(artlm(mJ, "NumPopularAlters:roundID"), pairwise=c("NumPopularAlters", "roundID"), adjustment="holm")

mu = art(u ~ NumPopularAlters * roundID + (1|egoID), data=df) # uses LMM
anova(mu) # report anova
emmeans(artlm(mu, "NumPopularAlters"), pairwise ~ NumPopularAlters,adjust=c("holm"))

mr = art(r ~ NumPopularAlters * roundID + (1|egoID), data=df) # uses LMM
anova(mr) # report anova
emmeans(artlm(mr, "NumPopularAlters"), pairwise ~ NumPopularAlters,adjust=c("holm"))

mQ = art(Q ~ NumPopularAlters * roundID + (1|egoID), data=df) # uses LMM
anova(mQ) # report anova
emmeans(artlm(mQ, "NumPopularAlters"), pairwise ~ NumPopularAlters,adjust=c("holm"))



