import json
import pandas as pd


def do_something_to_json(raw_json, output_json):
    pass


def process_lm_history_CSV(input, output):
    with open(input, 'r', encoding='utf-8') as input_file:
        df = pd.read_csv(input_file)

        # do something to dataframe
        df = df.groupby(['Year','Month','product','businessunit']) \
                .agg({
                        'organisation_name':'nunique',
                        'active_user_limit':'sum'
                    })

        # save as csv to specified desination
        df.to_csv(output) # only use index=False for dataframes that do not have grouped/aggregate data
        input_file.close()



def process_awhere_JSON(input, output):
    with open(input, 'r', encoding='utf-8') as input_file, open(output, 'w', encoding='utf-8') as output_file:
        line = input_file.readline()
        while line:
            # process json data by line here
            json_format = {}        
            raw_row = json.loads(line)
            row = do_something_to_json(raw_row, json_format)
            if row:
                output_file.write(json.dumps(row) + '\n')
            line = input_file.readline()
        output_file.close()
        input_file.close()