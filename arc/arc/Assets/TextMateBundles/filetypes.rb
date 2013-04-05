require 'rubygems'
require 'plist'

global_fileTypes = {}

Dir['*.plist'].each do |fname|
 	parsed = Plist::parse_xml(fname)
 	ftypes = parsed['fileTypes']
 	if ftypes
 		ftypes.each do |ftype|
 			if !global_fileTypes[ftype]
 				global_fileTypes[ftype] = []
 			end
 		global_fileTypes[ftype].push(fname)
 		end
 	end
 end
 Plist::Emit.save_plist(global_fileTypes, "BundleConf.plist")

#puts global_fileTypes["scm"]
