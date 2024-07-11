
//  MTArchiver.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 02.05.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTArchiver.h"
#import "MTStorage.h"
#import "MTGhost.h"
#import "MTGhostInstance.h"
#import "MTTrain.h"
#import "MTSubTrain.h"
#import "MTCart.h"
#import "MTWebApi.h"

@interface MTArchiver ()

@property NSMutableDictionary *miniatures;

@end

@implementation MTArchiver

static MTArchiver* myInstanceMTA;

+(MTArchiver*)getInstance
{
    if(!myInstanceMTA)
    {
        myInstanceMTA = [[MTArchiver alloc]initSingleton];
    }
    return myInstanceMTA;
}


+(void)clear
{
    myInstanceMTA = nil;
}


+(MTArchiver*)getNewInstance
{
        myInstanceMTA = [[MTArchiver alloc]initSingleton];
    return myInstanceMTA;
}


-(id)initSingleton
{
#if DEBUG_NSLog
    ////NSLog(@"Tworze archivera");
#endif
    [self setArchivePath:
     [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"]];
    [self decodeSessionsInfo ];
#if DEBUG_NSLog
    ////NSLog(@"Tworze Archivera");
#endif
    if(! self.miniatures)
    {
        self.miniatures = [[NSMutableDictionary alloc] init];
    }
    myInstanceMTA = self;
    return myInstanceMTA;
}
-(NSString *) getMiniatureWithNr:(NSUInteger) index
{
    ////NSLog(@"returnig : %@",self.miniatures[[NSString stringWithFormat:@"%lu",(unsigned long)index]]);
    //if ( self.miniatures[[NSString stringWithFormat:@"%lu",(unsigned long)index]]){
    return self.miniatures[[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    //}else{
    //   return @"empty.png";
    // }
}

-(NSString *) getSaveFilenameWith:(NSUInteger) index
{
    return [NSString stringWithFormat:@"SessionData%lu.mtd",(unsigned long) index];
}

-(NSString *) getSavedPathNameWith:(NSUInteger) index
{
    return [[self archivePath] stringByAppendingPathComponent:
            [NSString stringWithFormat:@"SessionData%lu.mtd",(unsigned long) index]];
}


-(NSString *) getSnapshotWithNr:(NSUInteger) index
{
    NSString* path =[[self archivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"SessionData%lu.png",(unsigned long) index]];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:path isDirectory:false]){
        return path;
    }else{
        return nil;
    }
    
}
/**
 *  Metoda zapisująca informacje o zapisanych sesjach użytkownika do archiwum.
 */
-(bool)encodeSessionsInfo
{
    /// przygotowanie klucza do wartosci w słowniku miniatures, na podstawie nazwy wybranego pliku
    NSString *number = [self.filename stringByReplacingOccurrencesOfString:@"SessionData" withString:@""];
    number = [number stringByReplacingOccurrencesOfString:@".mtd" withString:@""];
    
    /// zapisanie nazwy miniaturki do slowanika miniatures
    MTGhost *G =((MTGhost*)[[MTStorage getInstance] getAllGhosts][0]);
    self.miniatures[number] = G.costumeName;
    
    /// zapisanie slownika do pliku
    [NSKeyedArchiver archiveRootObject: self.miniatures toFile: [[self archivePath] stringByAppendingPathComponent:@"miniatures.mtd"]];
    return true;
}

/**
 *  Metoda wczytująca informacje o zapisanych sesjach użytkownika z archiwum.
 */
-(bool)decodeSessionsInfo
{
    self.miniatures = [NSKeyedUnarchiver unarchiveObjectWithFile: [[self archivePath] stringByAppendingPathComponent:@"miniatures.mtd"]];
    return true;
}

/**
 *  Funkcja czyszcząca
 */
-(bool)deleteStorageAtPath:(NSString*) path{
    
    NSLog(@"Deleting %@",path);
    if (path == nil){
        return false;
    }
    if ([path length]==0){
        return false;
    }
    NSFileManager* fileManager= [NSFileManager defaultManager];
    @try {
        if ([fileManager fileExistsAtPath:path]){
            if( [fileManager removeItemAtPath:path error:NULL]
           ){
            return true;
            
        }
        }
    } @catch (NSException *exception) {
        NSLog(@">ERR> %@",exception);
    } @finally {
        
    }
    
    
    return false;
}

-(bool)deleteMiniatureAtPath:(NSString*) path{
    
    NSFileManager* fileManager= [NSFileManager defaultManager];

        if ([fileManager fileExistsAtPath:path]){
    if([fileManager removeItemAtPath:path error:NULL]){
        return true;
    }
            
        }
    
    return false;
}

-(bool)deleteStorage{
    NSString* path =[[self archivePath] stringByAppendingPathComponent:self.filename];
    return [self deleteStorageAtPath: path];
}

- (UIImage *)compressForUpload:(UIImage *)original :(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

-(bool)saveSnapshot:(UIView*)v{
    
    //dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    //dispatch_async(backgroundQueue, ^{
   // MTStorage* storage = [MTStorage getInstance];
    
    //NSString* path =[[self archivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.filename]];
    NSString *path =@"";
    if (![self.scene[@"file"] hasPrefix:@"sandbox"])
        path = self.scene[@"thumbnail"];
    else
        path = [self.scene[@"local_file"] stringByReplacingOccurrencesOfString:@".mtd" withString:@".png"];
    // Captures SpriteKit content!
    UIGraphicsBeginImageContextWithOptions(v.bounds.size, NO, 0.4);
    [v drawViewHierarchyInRect:v.bounds afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImage * small = [self compressForUpload:snapshotImage :0.25];
    [UIImagePNGRepresentation(snapshotImage) writeToFile:path atomically:YES];
    ////    [UIImagePNGRepresentation(small) writeToFile:path atomically:YES];
    //});
    
    return true;
}

/**
 * Funkcja zapisująca sesję użytkownika do archiwum.
 */
-(bool)encodeStorage
{
    ////NSLog(@"xxx");
    //NSError *er = [[NSError alloc] init];
    
    if ([self.scene[@"file"] hasPrefix:@"sandbox://"] || [self.scene[@"file"] hasPrefix:@"saved://"]){//czyli jeśli zapisany lub z sandboxa.
    //[self encodeSessionsInfo];
    MTStorage* storage = [MTStorage getInstance];
    NSString* path = self.scene[@"local_file"];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:storage];
    NSString* str = [data base64EncodedStringWithOptions:0];
    bool val = [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    // bool val = [NSKeyedArchiver archiveRootObject: storage toFile:path];
    
    // NSString * s = [storage getGhostsList];
    

        if (val){
        //NSLog(@"Zapis do %@, sie udał",path);
        }
        else{
        //NSLog(@"%@ : Zapis do %@, sie nie powiodl",er,path);
        }
    
    return val;
    }
    return false;
}
/**
 * Funkcja odczytująca sesję użytkownika z archiwum.
 */
-(id)decodeStorage
{
    self.GhostArray = [[NSMutableArray alloc] init];
    id val =nil;
    ////NSLog(@"opening document from %@",self.filename);

    NSString* path= self.scene[@"local_file"];
    
    ////NSLog(@"opening from %@",path);
    
    @try{
     /* to tak musi byc juz dwa razy zmienialismy na init with content of file ale nie da sie wczytac */
        NSString* content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSData * data = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
        val = [NSKeyedUnarchiver unarchiveObjectWithData:data];
      
    }@catch(NSException * e){
        ////NSLog(@"%@",e);
        val = nil;
    }
    
    if (val)
    {
#if DEBUG_NSLog
        ////NSLog(@"Odczyt z %@, sie udał",path);
#endif
    }
    else
    {
#if DEBUG_NSLog
        ////NSLog(@"Odczyt z %@, sie nie powiodl",path);
#endif
        [[[MTStorage alloc] initSingleton] setProjectType: MTProjectTypeUser];
    }
    
    return self;
}

-(id)decodeStorageFromData:(NSData*)data AndProjectType:(MTProjectTypeEnum) projectType
{
    self.GhostArray = [[NSMutableArray alloc] init];
    
    
    NSString* dat = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //TODO wczesniej bylo to nizej
    //NSString* dat = [NSString stringWithUTF8String:[data bytes]];
    
    NSData * ctt = [[NSData alloc]initWithBase64EncodedString:dat options:0];
    id val = [NSKeyedUnarchiver unarchiveObjectWithData:ctt];
    //id val =nil;
    
    if (val)
    {
#if DEBUG_NSLog
        ////NSLog(@"Odczyt z sie udał");
#endif
    }
    else
    {
#if DEBUG_NSLog
        ////NSLog(@"Odczyt z  sie nie powiodl");
#endif
    }
    
    [[MTStorage getInstance] setProjectType:projectType];
    
    return self;
}

-(NSString*)getMiniature{
    return [[self archivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@TMP.png",self.filename]];
}

-(void)deleteMiniature:(long)i{
    NSString* nazwa = [[self archivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@TMP.png",self.filename]];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:nazwa error:nil];
}

-(NSString*)getHelpImage{
    NSString * p = [[self archivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@OBJ.png",self.filename]];
    return p;
}

-(NSString*)getBGImage{
    NSString * p = [[self archivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@BG.png",self.filename]];
    return p;
}
-(NSArray*)getCartList{
    NSString * path =[[self archivePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@LIST.txt",self.filename]];
   // NSArray * cos = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    return [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    //return
}


-(id)init
{
#if DEBUG_NSLog
    ////NSLog(@"inicjuje archivera w zly sposob");
#endif
    return nil;
}
@end
