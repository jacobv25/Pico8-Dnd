import os

# Ensure we're only looking for .lua files in the current directory
current_directory = os.getcwd()

# Get a list of all .lua files in the current directory
lua_files = [f for f in os.listdir(current_directory) if os.path.isfile(f) and f.endswith('.lua') and f != 'tokens.lua']

# Open the tokens.p8 file for writing
with open('tokens.p8', 'w') as output_file:
    # Write the starting lines
    output_file.write('pico-8 cartridge // http://www.pico-8.com\n')
    output_file.write('version 41\n')
    output_file.write('__lua__\n\n')

    for lua_file in lua_files:
        with open(lua_file, 'r') as file:
            # Read the content of the current .lua file and write it to tokens.p8
            content = file.read()
            output_file.write(f'-- Content from {lua_file} --\n')
            output_file.write(content + '\n\n')
    
    # Write the ending line
    output_file.write('__gfx__')

print("All .lua files have been merged into tokens.p8!")
