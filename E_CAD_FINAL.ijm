
//MACRO_2 E-Cadhenin FOCI quantification
//************************************//

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
	run("Stack to Images");
	
//Nucleus preporcessing
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

//E-cadhenin preprocessing
	selectWindow("image_" + i + "-0003");
	run("Duplicate...", " ");
	run("Gaussian Blur...", "sigma=15");
	selectWindow("image_" + i + "-0003");
	imageCalculator("Subtract create", "image_" + i + "-0003","image_" + i + "-0003-1");
	selectWindow("Result of image_" + i + "-0003");
	setAutoThreshold("Default dark");
	run("Threshold...");
	selectWindow("image_" + i + "-0003");
	selectWindow("Result of image_" + i + "-0003");
	setThreshold(10000, 65535, "raw");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Erode");
	
//Measuring - cytoplasmic region
	selectWindow("image_" + i + "-0001");
	run("Create Selection");
	selectWindow("Result of image_" + i + "-0003");
	run("Restore Selection");
	run("Analyze Particles...", "size=10-Infinity display exclude clear summarize add");

//Measuring 2 - Inverted selection - membrane
	selectWindow("image_" + i + "-0001");
	run("Create Selection");
	run("Make Inverse");
	selectWindow("Result of image_" + i + "-0003");
	run("Restore Selection");
	run("Analyze Particles...", "size=10-Infinity display exclude clear summarize add");
	
//Closing
	selectWindow("image_" + i + "-0001");
	close();
	selectWindow("image_" + i + "-0002");
	close();
	selectWindow("image_" + i + "-0003");
	close();
	selectWindow("image_" + i + "-0003-1");
	close();
	selectWindow("Result of image_" + i + "-0003");
	close();

//End of loop 1

}

//End of Macro_2


	