//
//  TMBundleSyntaxParser.m
//  arc
//
//  Created by Benedict Liang on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TMBundleSyntaxParser.h"

@implementation TMBundleSyntaxParser

#pragma mark - Initializers

+ (NSDictionary*)plistByName:(NSString*)TMBundleName {
    if ([[TMBundleSyntaxParser existingBundles] objectForKey:TMBundleName]) {
        NSURL *syntaxFileURL = [[NSBundle mainBundle] URLForResource:TMBundleName withExtension:@"plist"];
        
        return [NSDictionary dictionaryWithContentsOfURL:syntaxFileURL];
    } else {
        return nil;
    }

}
+ (NSDictionary*)plistByFullName:(NSString*)fullName {
    
    NSURL *syntaxFileURL = [[NSBundle mainBundle] URLForResource:fullName withExtension:nil];
    
    return [NSDictionary dictionaryWithContentsOfURL:syntaxFileURL];
}

+ (NSDictionary*)existingBundles {
    NSURL* bundleConf = [[NSBundle mainBundle] URLForResource:@"BundleConf.plist" withExtension:nil];
    
    NSDictionary* extToBundle = [NSDictionary dictionaryWithContentsOfURL:bundleConf];
    
    return [extToBundle objectForKey:@"bundles"];
}
+ (NSDictionary*)fileTypesToBundles {
    NSURL* bundleConf = [[NSBundle mainBundle] URLForResource:@"BundleConf.plist" withExtension:nil];
    
    NSDictionary* extToBundle = [NSDictionary dictionaryWithContentsOfURL:bundleConf];
    
    return [extToBundle objectForKey:@"fileTypes"];
}

+ (NSDictionary*)plistForExt:(NSString *)fileExt {
    
    NSArray* legitBundles = [[TMBundleSyntaxParser fileTypesToBundles] objectForKey:fileExt];
    
    if (legitBundles) {
    
        NSString* bundleName = [legitBundles objectAtIndex:0];
        
        return [TMBundleSyntaxParser plistByFullName:bundleName];
    
    } else {
        NSLog(@"Appropriate bundle not found");
        
        return nil;
    }
}
@end
