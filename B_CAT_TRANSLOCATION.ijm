
//MACRO_1 B-Cathenin translocation
//*******************************//

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
		
//Preporcessing
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
	
//Measuring - Measurement determined as mean intensity and selection inside the nucleus (DAPI channel, image 001)
	run("Create Selection");
	selectWindow("image_" + i + "-0002");
	run("Restore Selection");
	run("Measure");
	
//Measuring 2 - Measurement inverted to select and calculate the values of the areas outside the nucleus
	selectWindow("image_" + i + "-0001");
	run("Make Inverse");
	selectWindow("image_" + i + "-0002");
	run("Restore Selection");
	run("Measure");

//End of Loop 1

}