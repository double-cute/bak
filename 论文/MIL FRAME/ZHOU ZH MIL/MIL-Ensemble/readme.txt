
***************************************************************************

		  ReadMe for the MIL-Ensemble Package

***************************************************************************

Description: This toolbox contains re-implementations of four different 
             multi-instance learners, i.e. Diverse Density, Citation-kNN, 
             Iterated-discrim APR, and EM-DD. Ensembles of these single 
             multi-instance learners can be built with this toolbox.
 
Reference:   Z.-H. Zhou and M.-L. Zhang. Ensembles of multi-instance 
             learners. In: Proceedings of the 14th European Conference on 
             Machine Learning (ECML'03), Cavtat-Dubrovnik, Croatia, LNAI 
             2837, 2003, pp.492-502.

ATTN:        This package is free for academic usage. You can run it at 
             your own risk. For other purposes, please contact Prof. 
             Zhi-Hua Zhou (zhouzh@nju.edu.cn).

Requirement: To use this package, the MATLAB environment must be available.

ATTN2:       This package was developed by Mr. Min-Ling Zhang (zhangml@lamda.
             nju.edu.cn). There is a ReadMe file roughly explaining the codes. 
             But for any problem concerning the code, please feel free to 
             contact Mr. Zhang.

***************************************************************************

This toolbox contains programs for four different multi-instance learners and 
their ensemble versions. In detail, this toolbox contains three parts:

1)Data Preparation
  This part includes three components:
    1.1) Original Musk data [1] from UCI machine learning repository
    1.2) Preprocessed Musk data for further usage
    1.3) functions for dividing the Musk data into 10 folds, which are called 
         before conducting 10-fold cross-validation experiments

2)Individual Algorithm
  This part includes programs for four different multi-instance learners:
    2.1) Iterated-Discrim APR [1], the main function is 'IDAPR'
    2.2) Citation-kNN [2], the main function is 'CKNN'
    2.3) Diverse Density [3], the main function is 'maxDD'
    2.4) EM-DD [4], the main function is 'EMDD'
  For more details of the above algorithms, please refer to the correponding 
  codes and comments.

3)Ensemble Algorithm
  This part includes programs for the Ensemble of four different multi-instance 
  learners:
    3.1) Ensemble of Iterated-Discrim APR
    3.2) Ensemble of Citation-kNN
    3.3) Ensemble of Diverse Density
    3.4) Ensemble of EM-DD
  For more details of the functionality of the above algorithms, please refer 
  to [5] and the corresponding codes and comments.

[1] T.G. Dietterich, R.H. Lathrop, and T. Lozano-Perez. Solving the multiple-
    instance problem with axis-parallel rectangles. Artificial Intelligence, 
    89(1-2): 31-71, 1997.
[2] J. Wang and J.-D. Zucker. Solving the multiple-instance problem: a lazy 
    learning approach. In: Proceedings of the 17th International Conference on 
    Machine Learning, San Francisco, CA: Morgan Kaufmann, 1119-1125, 2000.
[3] Maron O. Learning from ambiguity [PhD dissertation]. Department of Electrical 
    Engineering and Computer Science, MIT, 1998
[4] Q. Zhang and S. A. Goldman. EM-DD: an improved multi-instance learning 
    technique. In: Advances in Neural Processing Systems 14, Cambridge, MA: MIT 
    Press, 1073-1080, 2001.
[5] Z.-H. Zhou and M.-L. Zhang. Ensembles of multi-instance learners. In: Lecture 
    Notes in Computer Science 2837, Berlin: Springer-Verlag, 2003, 492-502.

***************************************************************************