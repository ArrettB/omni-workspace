
Hacked iFrame-ims-1.2 code

This project is a reversed engineered version of the iFrame-ims-1.2.jar code.  
The reverse engineering was done so we could fix some issues.  This file
describes the overall process.

1)  Extract iFrame-ims-1.2.jar into the original_classes folder
2)  Use jd decompile to decompile the source code
3)  Copy the relevant component source from the zipped source file (in this case SmartColumnComponent.java).
4)  Copy the remaining jar files from the original_classes folder
5)  Copy some components that were stupidly placed in the ims project for Omni.
6)  Compile the whole shebang.
7)  Create a jar file with the following
   a) The modified code
   b) The components from the ims project
   c) Original classes for all other pieces.

If you need to go through this process again, just grab the relevant source files out of the .zip file,
place in the source folder, and make your changes. 

Good luck!

Dave Andreasen
Kettle River Consulting
