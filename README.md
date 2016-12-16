# BoutonDetection

The analysis of axonal synapses (boutons) is often required when studying structural plasticity in the brain. To date, this type analysis has been largely manual or semi-automated, and relies on a step that traces the axon before detecting boutons, which if fails, limits the ability to detect axonal boutons. In this paper, we propose a new algorithm that does not require tracing the axon to detect axonal boutons in 3D two-photon images taken from the mouse cortex. To find the most appropriate techniques for this task we compared several well-known algorithms for interest point detection and feature descriptor generation. 

## The final algorithm proposed has the following main steps: ##
1. A Laplacian of Gaussians (LoG) based feature enhancement module to accentuate the appearance of boutons. 

2.  A Speeded Up Robust Features (SURF) interest point detector to find candidate locations for feature extraction. 

3.  Non-maximum suppression to eliminate candidates that were detected more than once in the same local region. 

4.  Generation of feature descriptors based on Gabor filters. 

5.  A Support Vector Machine (SVM) classifier, trained on features from labelled data, was lastly used to separate the features into bouton and non-bouton instances. 

We found that our method achieved a Recall of 95%, Precision of 76%, and F1 score of 84%. On average, Recall and F1 score were significantly better than the current state-of-the-art method, while Precision was not significantly different. In conclusion, in this article we demonstrate our approach, which is independent of axon tracing, can detect boutons to a high level of accuracy, and improves on the detection performance of existing approaches. 
