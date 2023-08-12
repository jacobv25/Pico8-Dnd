import os

# Ensure we're only looking for .lua files in the current directory
current_directory = os.getcwd()

# Get a list of all .lua files in the current directory
lua_files = [f for f in os.listdir(current_directory) if os.path.isfile(f) and f.endswith('.lua') and f != 'tokens.lua']

# Open the tokens.lua file for writing
with open('tokens.lua', 'w') as output_file:
    for lua_file in lua_files:
        with open(lua_file, 'r') as file:
            # Read the content of the current .lua file and write it to tokens.lua
            content = file.read()
            output_file.write(f'-- Content from {lua_file} --\n')
            output_file.write(content + '\n\n')

print("All .lua files have been merged into tokens.lua!")
