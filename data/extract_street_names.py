import hashlib
import json
import pandas as pd

# First, we're going to load up the name/gender correlation data
# From the data source repo:
#  - F female
#  - 1F female if first part of name, otherwise mostly male
#  - ?F mostly female
#  - M male
#  - 1M male if first part of name, otherwise mostly female
#  - ?M mostly male
#  - ? unisex
names = pd.read_csv('firstnames.csv', delimiter=';')
female_names = set(names[(names['gender'].str.contains('F')) | 
                         (names['gender'] == '?') |
                         (names['gender'].str.contains('1'))]['name'])
male_names = set(names[(names['gender'].str.contains('M')) | 
                       (names['gender'] == '?') |
                       (names['gender'].str.contains('1'))]['name'])

# Next, we'll load in the streets data from the csv file generated by extract.sh
df = pd.read_csv('berlin-streets.csv', delimiter='\t', 
		 header=0, names=['oname', 'objectid', 'type', 'street'])
df.dropna(subset=['street'], inplace=True)
df['id'] = df.apply(lambda x: hashlib.sha1(x['street'].encode('utf-8')).hexdigest(), axis=1)
df.drop_duplicates(subset=['id'], inplace=True)

# Now add some columns to make the data model reflect the desired use case
df['extracted_name'] = df.apply(lambda x: ' '.join(x['street'].split('-')[0:-1])
				or None, axis=1)
df['maybe_person'] = df.apply(lambda x: True if x['extracted_name'] 
			      else None, axis=1)
df['maybe_woman'] = df.apply(lambda x: (True if set(x['extracted_name'].split(' ')).intersection(female_names)
                                        else None) if x['extracted_name'] else None, axis=1)
df['maybe_man'] = df.apply(lambda x: (True if set(x['extracted_name'].split(' ')).intersection(male_names)
                                      else None) if x['extracted_name'] else None, axis=1)
df['is_person'] = None
df['is_woman'] = None
df['is_man'] = None

# Export to json
json_str = json.dumps(json.loads(df.to_json(orient='records')), indent=2)
with open('streets.json', 'w') as outfile:
	outfile.write(json_str)


