import pandas as pd
csv_input_path = 'C:/Users/malli/OneDrive/Desktop/ΣΗΜΜΥ/3o_etos/databases/Hospital-data-management/formatted-data/medicine-ema-codes/article-57-product-data_en.csv'
csv_output_path = 'C:/Users/malli/OneDrive/Desktop/ΣΗΜΜΥ/3o_etos/databases/Hospital-data-management/formatted-data/medicine-ema-codes/formated_article-57-product-data_en.csv'
dataframe = pd.read_csv(csv_input_path, header = None, delimiter=';', names=['product_name','active_substance','route','country', 'marketing', 'master_file_location', 'email', 'phone'])
dataframe = dataframe.assign(active_substance=dataframe['active_substance'].str.split(',')).explode('active_substance')
dataframe = dataframe.assign(active_substance=dataframe['active_substance'].str.split('|')).explode('active_substance')
dataframe
dataframe.to_csv(csv_output_path, index=False, header=False, sep=';')