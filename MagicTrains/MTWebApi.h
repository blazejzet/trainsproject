//
//  MTWebApi.h
//  TrainsProject
//
//  Created by Dawid Skrzypczyński on 15.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//
#import "ServiceInfoProtocol.h"

@interface MTWebApi : NSObject<NSNetServiceBrowserDelegate,NSNetServiceDelegate>

@property (weak) id<ServiceInfoProtocol> del;
+(id) getInstance;
+(NSString*)tanslateToLocalPath:(NSString*)path;
+(NSArray*)decodeList:(NSString*)path;
-(NSMutableURLRequest *) getAccessTokenRequest;

-(NSMutableURLRequest *) saveGameWithFileName:(NSString *) fName;
-(void)getTopRatedCloudList:(int)page cb:(void (^)(NSArray*))cb;
-(void)getCloudListForAll:(int)page cb:(void (^)(NSArray*))cb ;


//LISTA WYSLANYCH
-(void)getListMyUploadedcb:(void (^)(NSArray*))cb;
-(void)getListMyUploadedcb:(void (^)(NSArray*))cb page:(int)page;
//LISTA SANDBOX
-(void)getSandboxListcb:(void (^)(NSArray*))cb;

+(NSData*)download:(NSString*)addr;

+(void)getUser;

-(void)uploadToICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(BOOL))completion;
-(void)deleteSceneFromDevice:(NSDictionary*)scene completion:(void(^)(BOOL))completion;
-(void)changeShareStatus:(NSDictionary*)scene completion:(void(^)(BOOL,BOOL))completion;
-(void)shareScene:(NSDictionary*)scene completion:(void(^)(BOOL,BOOL))completion;
-(void)checkIfShared:(NSDictionary*)scene completion:(void(^)(BOOL))completion;
-(void)unshareScene:(NSDictionary*)scene completion:(void(^)(BOOL,BOOL))completion;

-(void)downloadMyProjectFromICloud:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion;

-(void)downloadFromICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion;
//GRAFIKA - cel zadania
-(void)downloadObjectiveFromICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary *))completion;
//GRAFIKA - MINIATURA;
-(void)downloadThumbnailFromICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion;

-(void)deleteFromICloudScene:(NSDictionary*)scene completion:(void(^)(bool))completion;
-(bool) deleteSceneFromDevice: (NSDictionary*)scene; //do usuwania pobranych specjalna metoda


-(void)getShowcaseListcb:(void (^)(NSArray*))cb;

+(NSNumber*)getAppVersion;

//ZAPISYWANIE SCEN DO LISTY POBRANYCH
-(void)addSceneToList:(NSDictionary*)scene;
//LISTA POBRANYCH
-(void)getDownloadedListcb:(void (^)(NSArray*))cb;

-(void)getContestFiles:(NSString*)type cb:(void (^)(NSArray*))cb;
-(void)getBookFiles:(NSString*)type cb:(void (^)(NSArray*))cb;

//ustawianie ukończenia poziomów kolejnych
-(void)saveFinished:(NSString*)file;
-(NSString*)checkFinished:(NSString*)file;
-(BOOL)checkOpened:(NSString*)file; // czy otwarty poziom


//sprawdzneie jak jest oceniona scena
-(void)checkStars:(NSDictionary*)scene completion:(void(^)(BOOL,int, int))cb;
-(void)setScene:(NSDictionary*)scene Stars:(int)stars;

+(void)setOffline;
+(void)setOnline;

+(NSString*)getLang;
+(BOOL)getSchool;

//BROADCAST I KOMUNIKACJA SZKOLNA
+(BOOL)checkServicing;
+(BOOL)broadcastService;
-(void)stopBroadcasting;
- (void)broadCastMessage:(NSString*)message;
-(void)attachTI:(NSString*)name;
-(void)detachTI;

+(BOOL)checkMasterService;
-(void) starListening;
-(void)checkTI;


+(BOOL)checkMasterServiceWorking;
@end
