## Prototyping IRAF cl script for testing how to 
## examine which CCD is stored in the header keyword 
## INSTRUME. Based on the response we either proceed 
## with whatever we have in mind to do, or exit the 
## script. This is to allow fopr instrument based 
## tests and so that I do not run a script intended 
## for one instrument on data from a different 
## instrument. 

## A fun little distraction on writing CL scripts too. 

# hedit ("g??d???.???.fits",
# "INSTRUME", ".", add=no, addonly=no, delete=no, verify=no, show=yes,
# update=no, > "instrument.txt")

# Call the Shell script that uses the tried and true ed editor
# to replace the '=' in the hedit output with a comma so that 
# the built-in IRAF function fscan can read the strings. 
# Note that the cl needs the '!' to escape the call to the shell.
# !../removeEquals.sh

list = "instrument.txt"

# WIthout a space between the comma follwing the image and 
# INSTRUME these are read into s1. Only two strings are 
# needed for reading.

#while ( fscan(list, s1, s2 ) !=EOF) {
#    print "s1 is: " (s1)
#    print "s2 is: " (s2)
#    print " " 
#}

scan (list, s1, s2)

# Test if we have the Sophia camera

print " "
print " Checking for the value of INSTRUME stored in the header."
print " "

if (s2 == "Sophia")
    print "Sophia CCD in use."
else
    print "**********"
    print "INSTRUME does not equal Sophia"
    print "Keyword INSTRUME = " (s2)
    print "Quitting script!!!"
    print "**********"
    print " "
    end