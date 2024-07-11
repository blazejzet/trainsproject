//
//  MTFileManager.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 08.11.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#import "MTFileManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MTFileManager

-(id) init{
    self = [super init];
    return self;
}

+(MTFileManager *) defaultManager {
    return (MTFileManager *)[super defaultManager];
}

-(NSString *) MD5FromFilepath:(NSString *) path
{
    if( [self fileExistsAtPath:path isDirectory:nil] )
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( data.bytes, (CC_LONG)data.length, digest );
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ )
        {
            [output appendFormat:@"%02x", digest[i]];
        }
        
        return output;
    }

    return @"";
}

-(bool) CompareMD5BetweenFilepath1:(NSString *) path Filepath2: (NSString *) path2
{
    return [[self MD5FromFilepath: path] isEqualToString:[self MD5FromFilepath: path2]];
}

-(bool) CreateDirectoryInPath: (NSString *)path
{
    if (![[MTFileManager defaultManager] fileExistsAtPath:path]){
        NSError* error;
        if(![[MTFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error])
            {
                ////NSLog(@"[%@] Nie mozna utworzyc katalogu w podanej sciezce", [self class]);
                return false;
            }
    }
    return true;
}

@end
