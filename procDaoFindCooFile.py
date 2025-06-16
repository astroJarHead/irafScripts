def process_file(input_file, output_file):

'''
A function to take the Daofind output coordinate (coo) file 
and process this to edit out lines which are not desired for 
follow-on processing. The goal is to:

1) Remove satruated stars flocated using daofind
2) Exlcude stars located close to the edge of the imager which 
may suffer from instrumental effects or for which the sky fitting 
annulus may extend off the image Field of View. 

Parameters: 

    input_file: (str) Input coordinate file name
    output_file: (srt) Name of resulting output_file
'''

    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            # Strip the line of leading/trailing whitespace for processing
            stripped_line = line.strip()
            
            # Check if the line starts with a '#' sign
            if stripped_line.startswith('#'):
                # Write the line verbatim to the output
                outfile.write(line)
                continue
            
            # Split the line into columns based on whitespace
            columns = stripped_line.split()
            
            # Ensure there are at least 7 columns
            if len(columns) < 7:
                continue
            
            # Extract columns 1 and 2 as floats for comparison
            try:
                col1 = float(columns[0])
                col2 = float(columns[1])
            except ValueError:
                continue  # Skip lines where conversion fails
            
            # Check if column 3 SHarpness contains "INDEF"
            # If sharpness = "INDEF" -> saturated
            if columns[3] == "INDEF":
                continue
            
            # Apply logical tests
            # Check for Upper (y) and lower (y) edge using outer edge of sky annulus 
            # plus a little extra
            if (col1 < 48) or (col1 > 2000.0):
                continue

            # Check for Left (x) and right (x) edge using outer edge of sky annulus 
            # plus a little extra
            if (col0 < 48) or (col0 > 2000.0):
                continue

            # If all conditions are met, write the line to the output
            outfile.write(line)

    print(f"Edited output coofile {output_file} written.\n")