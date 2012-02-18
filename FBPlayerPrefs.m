//
//  FBPlayerPrefs.m
//  Unity-iPhone
//
//  Created by Matt Mechtley on 2008.11.19.
//  Copyright 2008 Flashbang Studios, LLC. All rights reserved.
//

#import "FBPlayerPrefs.h"



@implementation FBPlayerPrefs

+ (void)initialize
{
	[FBPlayerPrefs readPrefsFile];
}

#pragma mark ---- Set pref values ----

/*
 * Stores a Unity PlayerPrefs value as various types
 */

+ (void)setInt:(int)value withKey:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

+ (void)setFloat:(float)value withKey:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
}

+ (void)setString:(NSString *)value withKey:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

#pragma mark ---- Get pref values ----

/*
 * Gets a stored Unity PlayerPrefs value as various types
 */

+ (int)getInt:(NSString *)key orDefault:(int)value
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

int getMenuKey( const char *key ,int value){
				
		return [[NSUserDefaults standardUserDefaults] integerForKey:key];
		}
	


+ (float)getFloat:(NSString *)key orDefault:(float)value
{
	return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+ (NSString *)getString:(NSString *)key orDefault:(NSString *)value
{
	NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
	return (str == nil) ? value : str;
}

#pragma mark ---- Check for and delete entries ----

/*
 * Determines whether the Unity PlayerPrefs file contains the given key
 */
+ (BOOL)hasKey:(NSString *)key
{
	return ([[NSUserDefaults standardUserDefaults] objectForKey:key] != nil);
}

/*
 * Removes the given key from the Unity PlayerPrefs file
 */
+ (void)deleteKey:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

#pragma mark ---- PlayerPrefs file operations ----

/*
 * Reads the Unity PlayerPrefs file from disk, storing the contents in prefsCache
 */
+ (void)readPrefsFile
{
	NSString *path = [[[NSBundle mainBundle] bundlePath] 
					  stringByAppendingPathComponent:DEFAULT_PREFS_FILE];
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	if(dict != nil)
		[[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

/*
 * Saves the prefs file and unloads it from memory
 */
+ (void)saveAndUnload
{
	[NSUserDefaults resetStandardUserDefaults];
}

@end
