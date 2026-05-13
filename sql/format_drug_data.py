import pandas as pd
csv_input_path = 'C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/medicine-ema-codes/med-data.csv'
csv_output_path = 'C:/Users/maril/Desktop/DBLab/Hospital-data-management/formatted-data/medicine-ema-codes/formatted-med-data.csv'
dataframe = pd.read_csv(csv_input_path, header = None, delimiter=';', names=['product_name','active_substance','route','country', 'marketing', 'master_file_location', 'email', 'phone'])
dataframe = dataframe.assign(active_substance=dataframe['active_substance'].str.split(',')).explode('active_substance')
dataframe = dataframe.assign(active_substance=dataframe['active_substance'].str.split('|')).explode('active_substance')
dataframe
dataframe.to_csv(csv_output_path, index=False, header=False, sep=';')