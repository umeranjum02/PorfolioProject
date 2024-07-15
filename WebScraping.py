from bs4 import BeautifulSoup
import requests
import pandas as pd
url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
page = requests.get(url)
soup = BeautifulSoup(page.text,'html')
table = soup.find('table', class_ = 'wikitable sortable')
# print(table)
world_titles = table.find_all('th')
# print(world_titles)
world_table_titles = [titles.text.strip() for titles in world_titles]
# print(world_table_titles)
df = pd.DataFrame(columns = world_table_titles)
# print(df)
column_data = table.find_all('tr')
# print(column_data)
for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    # print(individual_row_data)
    length = len(df)
    df.loc[length] = individual_row_data 
    #print(df)
    df.to_csv(r'C:\Users\Umer Anjum\OneDrive\Desktop\My VS Code - Copy\Companies.csv', index = False)