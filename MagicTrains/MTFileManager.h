//
//  MTFileManager.h
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 08.11.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFileManager : NSFileManager

+(MTFileManager *) defaultManager;
-(NSString *) MD5FromFilepath:(NSString *) path;
-(bool) CompareMD5BetweenFilepath1:(NSString *) path Filepath2: (NSString *) path2;
-(bool) CreateDirectoryInPath: (NSString *)path;

@end
