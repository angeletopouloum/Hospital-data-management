import pandas as pd

df1 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/eksetaseis/cost-mock-data-1.csv", header = None, delimiter=';', names=['cost'])
df2 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/eksetaseis/cost-mock-data-2.csv", header = None, delimiter=';', names=['cost'])
df3 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/eksetaseis/cost-mock-data-3.csv", header = None, delimiter=';', names=['cost'])
df4 = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/eksetaseis/cost-mock-data-4.csv", header = None, delimiter=';', names=['cost'])
eksetaseisDF = pd.read_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/eksetaseis/eksetaseis.csv", header = None, delimiter=';', names=['lab_code', 'lab_description', 'category'])

fullDF1 = pd.concat([df1, df2, df3, df4], ignore_index=True)
finalEksetaseisDF = pd.concat([eksetaseisDF, fullDF1], axis=1, ignore_index=True)
finalEksetaseisDF.to_csv("C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/eksetaseis/formatted-eksetaseis.csv", index=False, header=False, sep=';')
