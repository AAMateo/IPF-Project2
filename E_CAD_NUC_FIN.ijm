
//MACRO_3 E-cadhenin nucleus quantification
//***************************************//

waitForUser("Important", "Please, duplicate your images before starting the processing, this macro will affect permanently your data");

//Variables
inputDir = getDirectory("Choose your input folder");
filelist = getFileList(inputDir);
	
//Number of images loop
for (i = 0; i < lengthOf(filelist); i++) {
	if (endsWith(filelist[i], ".tif")) {
		open(inputDir + File.separator + filelist[i]);
		name = getTitle();
		print(name);
        rename("image_" + i); 
		}	
		
//Nucleus preprocessing
	run("Stack to Images");
	selectWindow("image_" + i + "-0001");
	run("Subtract Background...", "rolling=65");
	run("Mean...", "radius=2");
	setAutoThreshold("Default dark");
	run("Threshold...");
	setThreshold(7000, 65535, "raw");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Erode");
	run("Watershed");
	
//Measuring - Nucleus (generated as a new macro to avoid use the same log of E-cadhenin Foci
	run("Analyze Particles...", "size=300-Infinity display exclude clear summarize add");

//End of loop 1

}

//End of Macro_3

