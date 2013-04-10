require 'rubygems'
require 'plist'

BUNDLE_DIR = "arc/arc/Assets/TextMateBundles/"
OUTPUT_FILE = "arc/arc/General/TMBundleProcessing/BundleConf.plist"
THEME_DIR = "arc/arc/Assets/Themes/"
THEME_OUTPUT_FILE = "arc/arc/General/TMBundleProcessing/ThemeConf.plist"
#filters the extension and dir path
def cleaned_name(fname, dir)
	ps = fname.split(dir)[1].split('.')
	return ps[0,ps.length-1].join('.')
end

def dirless_name(fname,dir)
	return fname.split(dir)[1]
end
# task to generate BundleConfig.plist
# Structure of object produce:
#{'fileTypes':{fileType:[bundles]} , 'bundles':{bundleName:1}}
task :bundle do
	global_fileTypes = {}
	global_bundles = {}
	files = Dir[BUNDLE_DIR+"*.plist"]
#	puts files
	if files
		files.each do |fname|
			global_bundles[cleaned_name(fname, BUNDLE_DIR)] = 1
			puts cleaned_name(fname, BUNDLE_DIR)
		 	parsed = Plist::parse_xml(fname)
		 	ftypes = parsed['fileTypes']
		 	if ftypes
		 		ftypes.each do |ftype|
		 			if !global_fileTypes[ftype]
		 				global_fileTypes[ftype] = []
		 			end
		 		global_fileTypes[ftype].push(dirless_name(fname, BUNDLE_DIR))
		 		end
	 		end
		end	
	end
	global = {}
	global['fileTypes'] = global_fileTypes
	global['bundles'] = global_bundles
	Plist::Emit.save_plist(global, OUTPUT_FILE)
end

task :theme do
	global_themes = {}
	tmThemes = Dir[THEME_DIR+"*.tmTheme"]
	if tmThemes
		tmThemes.each do |fname|
			global_themes[cleaned_name(fname, THEME_DIR)] = dirless_name(fname, THEME_DIR)
			puts cleaned_name(fname, THEME_DIR)
		end
	end
	Plist::Emit.save_plist(Hash[global_themes.sort], THEME_OUTPUT_FILE)
end
#puts global_fileTypes["scm"]
