import os
import re

def find_p8_file():
    for file in os.listdir('.'):
        if file.endswith('.p8'):
            return file
    return None

def read_file(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def include_file_content(match):
    file_path = match.group(1)
    return read_file(file_path)

def parse_and_include_files(p8_file_path):
    content = read_file(p8_file_path)
    content = re.sub(r'#include "(.*?)"', include_file_content, content)
    return content

def create_token_count_file(content):
    with open('token_count.p8', 'w') as out_file:
        out_file.write(content)

def main():
    p8_file_path = find_p8_file()
    
    if p8_file_path:
        print(f'Found p8 file: {p8_file_path}')
        content = parse_and_include_files(p8_file_path)
        create_token_count_file(content)
    else:
        print('No p8 file found in the current directory.')

if __name__ == "__main__":
    main()
