import pandas as pd

df1 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-A-mock-data.csv", header = None, delimiter=';')
df2 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-B-mock-data1.csv", header = None, delimiter=';')
df3 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-B-mock-data2.csv", header = None, delimiter=';')
df4 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-B-mock-data3.csv", header = None, delimiter=';')
df5 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-B-mock-data4.csv", header = None, delimiter=';')
df6 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-B-mock-data5.csv", header = None, delimiter=';')
df7 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-B-mock-data6.csv", header = None, delimiter=';')
df8 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/category-B-mock-data7.csv", header = None, delimiter=';')
iatrikesPrakseisDF= pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/iatrikes-prakseis.csv", header = None, delimiter=';')

fullDF2 = pd.concat([df1, df2, df3, df4, df5, df6, df7, df8], ignore_index=True)
finalIatrikesPrakseisDF = pd.concat([iatrikesPrakseisDF, fullDF2], axis=1, ignore_index=True)
finalIatrikesPrakseisDF.to_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/iatrikes-prakseis/formatted-iatrikes-prakseis.csv", index=False, header=False, sep=';')
