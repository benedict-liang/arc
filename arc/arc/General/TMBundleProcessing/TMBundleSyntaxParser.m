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
+ (BOOL)dict:(NSDictionary*)dict HasScope:(NSString*)scope {
    if (!dict) {
        return NO;
    }
    for (id k in dict) {
        NSDictionary* item = [dict objectForKey:k];
        NSString* name = [item objectForKey:@"name"];
        if (name) {
            NSArray* capturableScopes = [item objectForKey:@"capturableScopes"];
            return [capturableScopes containsObject:scope];
        }
    }
    return NO;
}
+ (BOOL)searchBundle:(NSDictionary*)bundle For:(NSString*)scope {
// name appears in name, captures{}, beginCaptures{}, endCaptures{}, contentName,
    NSString* name = [bundle objectForKey:@"name"];
    BOOL flag = NO;
    if (name) {
        NSArray* capturableScopes = [bundle objectForKey:@"capturableScopes"];
        flag = [capturableScopes containsObject:scope];
    }
    if (!flag) {
        NSDictionary* captures = [bundle objectForKey:@"captures"];
        NSDictionary* beginCaptures = [bundle objectForKey:@"beginCaptures"];
        NSDictionary* endCaptures = [bundle objectForKey:@"endCaptures"];
        flag = [TMBundleSyntaxParser dict:captures HasScope:scope] || [TMBundleSyntaxParser dict:beginCaptures HasScope:scope] || [TMBundleSyntaxParser dict:endCaptures HasScope:scope];
    }
    if (!flag) {
        NSArray* patterns = [bundle objectForKey:@"patterns"];
        flag = [TMBundleSyntaxParser ]
    }
    
}

+ (NSDictionary *)prunePatterns:(NSArray*)patterns WithTheme:(NSDictionary* )theme {
    NSDictionary* scopes = [theme objectForKey:@"scopes"];
    NSMutableArray* newBundle = [NSMutableArray array];
    for (NSString* scope in scopes) {
        
    }
}
@end
