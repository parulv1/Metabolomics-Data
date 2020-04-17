## Metabolomics data
This contains the metabolomics profile data and the code to analyze it. Metabolomics data was used to find predictors of vincristine-induced peripheral neuropathy. See [the paper](https://www.medrxiv.org/content/10.1101/19013078v1) for details.

## Data description
Here is a description of each of the files:

1. "03JUNE16_BOX LAYOUT_Bindley Code.csv": Includes sample codes and the categories (time point and high/low neuropathy) they belong to
2. "03JUNE16_Sample Key_With_Demographics.xlsx": Includes the following details of the subjects: gender, age, dose, height, weight, BMI, BSA
3. "VincristineAmount.csv": Quantitated vincrisine amount in each sample
4. "MetabolomicsFiltered.csv": Metabolite profile matrix
5. "MissingDataImputation.R": Code to perform imputation of missing peaks of the metabolite profile matrix
6. "Metabolomics_CARET.R": Code to perform featue selection using the imputated metabolite profile matrices for each time point

## Contact
If you have questions regarding the usage of this data, please contact [Parul Verma](https://parulv1.github.io/).

## Cite
If you found this data useful, please cite the following work.

```
@article{Verma2019VIPNp,
title = {A {M}etabolomics {A}pproach for {E}arly {P}rediction of {V}incristine-{I}nduced {P}eripheral {N}europathy},
author = {Verma, Parul and Deveraj, Jayachandran and Skiles, Jodi L. and Sajdyk, Tammy and
          Ho, Richard H. and Hutchinson, Raymond and Wells, Elizabeth and Li, Lang and  
          Renbarger, Jamie and Cooper, Bruce and Ramkrishna, Doraiswami},
journal = {Preprint},
year = {2019},
url = {https://www.medrxiv.org/content/10.1101/19013078v1}
}
```


