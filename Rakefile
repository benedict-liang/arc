require 'rubygems'
require 'plist'

BUNDLE_DIR = "arc/arc/Assets/TextMateBundles/"
OUTPUT_FILE = "arc/arc/General/TMBundleProcessing/BundleConf.plist"

#filters the extension and dir path
def cleaned_name(fname)
	ps = fname.split(BUNDLE_DIR)[1].split('.')
	return ps[0,ps.length-1].join('.')
end

def dirless_name(fname)
	return fname.split(BUNDLE_DIR)[1]
end
# task to generate BundleConfig.plist
# Structure of object produce:
#{'fileTypes':{fileType:[bundles]} , 'bundles':{bundleName:1}}
task :config do
	global_fileTypes = {}
	global_bundles = {}
	files = Dir[BUNDLE_DIR+"*.plist"]
#	puts files
	if files
		files.each do |fname|
			global_bundles[cleaned_name(fname)] = 1
			puts cleaned_name(fname)
		 	parsed = Plist::parse_xml(fname)
		 	ftypes = parsed['fileTypes']
		 	if ftypes
		 		ftypes.each do |ftype|
		 			if !global_fileTypes[ftype]
		 				global_fileTypes[ftype] = []
		 			end
		 		global_fileTypes[ftype].push(dirless_name(fname))
		 		end
	 		end
		end	
	end
	global = {}
	global['fileTypes'] = global_fileTypes
	global['bundles'] = global_bundles
	Plist::Emit.save_plist(global, OUTPUT_FILE)
end
#puts global_fileTypes["scm"]
