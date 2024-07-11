//
//  MTArchiver.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 02.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTProjectTypeEnum.h"

@class SKTexture;

@interface MTArchiver : NSObject 

@property NSString *archivePath;

@property NSMutableArray *GhostArray;
@property NSMutableArray *GhostDataArray;
@property NSString *filename;
@property NSMutableDictionary *scene;


+(void)clear;
+(MTArchiver *)getNewInstance;
+(MTArchiver *)getInstance;
-(NSString*) getMiniatureWithNr:(NSUInteger) index;
-(NSString*) getSnapshotWithNr:(NSUInteger) index;
-(NSString *) getSaveFilenameWith:(NSUInteger) index;
-(NSString *) getSavedPathNameWith:(NSUInteger) index;
-(bool)encodeStorage;
-(id)decodeStorage;
-(bool)saveSnapshot:(UIView*)v;
-(bool)deleteStorage;
-(bool)deleteStorageAtPath:(NSString*)path;
-(bool)deleteMiniatureAtPath:(NSString*)path;
-(id)decodeStorageFromData:(NSData*)data AndProjectType:(MTProjectTypeEnum) projectType;
-(NSString*)getMiniature;
-(NSArray*)getCartList;
-(NSString*)getHelpImage;
-(NSString*)getBGImage;
-(void)deleteMiniature:(long)i;
@end
