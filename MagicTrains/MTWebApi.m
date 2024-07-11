//
//  MTWebApi.m
//  TrainsProject
//
//  Created by Dawid Skrzypczyński on 15.06.2015.
//  Copyright (c) 2015 UMK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserStorage.h"
#import "MTWebApi.h"
#import "MTAvatarView.h"
#import "MTArchiver.h"
#import "MTiCloudUploader.h"
#import "MTiCloudDownloader.h"
#import "MTFileManager.h"
#import <CloudKit/CloudKit.h>

#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>

@implementation MTWebApi
@synthesize del;

static MTWebApi *myInstance;
static CKRecordID *user;
static BOOL isonline = true;

static NSNetService* service;
static NSString* servicename = @"";
//for connecting
static NSNetService* masterService;
static NSString* masterServiceName = @"";
static NSNetServiceBrowser* browser;

int listeningSocket;



NSMutableArray* downloadedlist;
CKContainer* myContainer;
-(id) init {
    if(!myInstance) {
        self = [super init];
        downloadedlist = [NSMutableArray array];
        
        myContainer = [CKContainer containerWithIdentifier:@"iCloud.pl.bedesign.TrainsProject"];
        [self synchronizeDownloadedList];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(detachTI)
                                                     name:@"Deattach"
                                                   object:nil];
        return self;
    }
    
    return myInstance;
}

+(id) getInstance {
    if(!myInstance) {
        myInstance = [[MTWebApi alloc] init];
        [MTWebApi getUserFinished: ^(CKRecordID* userRec){
            user = userRec;
        }];
    }
    
    return myInstance;
}

+(void) getUserFinished: (void(^)(CKRecordID*))finished {
    if(isonline){
    CKContainer *myContainer = [CKContainer containerWithIdentifier:@"iCloud.pl.bedesign.TrainsProject"];
    
    [myContainer fetchUserRecordIDWithCompletionHandler:^(CKRecordID *recordID, NSError *error) {
        //Jeśli w iCloud jeszcze nie ma tej infomracji...
        if(recordID==nil){
            finished(user);
        }else{
        [[myContainer publicCloudDatabase] fetchRecordWithID:recordID completionHandler:
         ^(CKRecord * _Nullable record, NSError* _Nullable err) {
             MTUserStorage *US = [MTUserStorage getInstance];
             if (record[@"MTUserAvatar"])
             {
                 [US setAvatarId: record[@"MTUserAvatar"] ];
             }
             else
             {
                 [self setUser];
             }
             [US setEnabledChallengeSceneNr: [(NSNumber*) record[@"MTEnabledChallenge1"] intValue] ForLevel:1];
             [US setEnabledChallengeSceneNr: [(NSNumber*) record[@"MTEnabledChallenge2"] intValue] ForLevel:2];
             [US setEnabledChallengeSceneNr: [(NSNumber*) record[@"MTEnabledChallenge3"] intValue] ForLevel:3];
             [US setEnabledChallengeSceneNr: [(NSNumber*) record[@"MTEnabledChallenge4"] intValue] ForLevel:4];
         }];
            if(error){
            //NSLog(@"Error %@",error);
            }
        else
            finished(recordID);
            user = recordID;
        }
     }
     
     ];
    }else{
        MTUserStorage *US = [MTUserStorage getInstance];
        finished(user);
        // KIEDY JEST OFFLINE
        // TODO
        // CHYBA Z LOKALNEGO STORAGE BY TRZEBA BYŁO POBRAĆ TEGO AVATARA?
    }
    
}
+(void) setUser {
    CKContainer *myContainer = [CKContainer containerWithIdentifier:@"iCloud.pl.bedesign.TrainsProject"];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    [publicDatabase fetchRecordWithID:user completionHandler:^(CKRecord *userRecord, NSError *error) {
        if (error) {
            // Error handling for failed fetch from public database
        } else {
            MTUserStorage *US = [MTUserStorage getInstance];
            userRecord[@"MTUserAvatar"] = [US getAvatarId];
            userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",1]] = [NSNumber numberWithInt:[US getEnabledChallengeForLevel:1]];
            userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",2]] = [NSNumber numberWithInt:[US getEnabledChallengeForLevel:2]];
            userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",3]] = [NSNumber numberWithInt:[US getEnabledChallengeForLevel:3]];
            userRecord[[NSString stringWithFormat:@"MTEnabledChallenge%d",4]] = [NSNumber numberWithInt:[US getEnabledChallengeForLevel:4]];
            
            // Modify the record and save it to the database
            [publicDatabase saveRecord:userRecord completionHandler:^(CKRecord                                                                      *savedRecord, NSError *saveError) {
                if (saveError){
                   //NSLog(@"%@",saveError);
                // Error handling for failed save to public database
                }
            }];
        } }];
}

-(void) cleanDownloadedList
{
    downloadedlist = [[NSMutableArray alloc] init];
    NSString *localDirectory = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/DownloadedScenes"];
    
    MTFileManager *fileManager = [MTFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:localDirectory])
    {
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:localDirectory error:nil];
        for (NSString *path in fileArray)
        {
            [fileManager removeItemAtPath:path error:nil];
        }
    }
    
}

-(void) synchronizeDownloadedList
{
    //W przypadku problemow z zapisame nalezy wykonac te metode
    //[self cleanDownloadedList];
    
    //Pobieranie listy z NSUserDefault celem zastapienia obecnej generowanej przy uruchomienia aplikacji
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[[userDefaults dictionaryRepresentation] allKeys] containsObject:@"DownloadedScenesList"])
    {
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"DownloadedScenesList"];
        NSMutableArray *tmpArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        downloadedlist = tmpArray;
    }
    
    //Hash z homeDirectory przy kazdej komplikacji jest inny, dlatego sciezki bezwzgledne w downloadedList sie nie beda zgadzaly... tutaj to naprawimy
    NSString *homeDirectory = NSHomeDirectory();
    
    for (NSMutableDictionary *dict in downloadedlist)
    {
        NSString *localFileBefore = dict[@"local_file"];
        NSString *localThumbnailBefore = dict[@"thumbnail"];
        
        if (![localFileBefore hasPrefix:homeDirectory])
        {
            int range = [localFileBefore rangeOfString:@"Documents/"].location;
            localFileBefore = [localFileBefore substringFromIndex:range];
            NSString *newFile = [[NSString alloc] initWithFormat:@"%@/%@", homeDirectory, localFileBefore];
            dict[@"local_file"] = newFile;
        }
        
        if (![localThumbnailBefore hasPrefix:homeDirectory])
        {
            int range = [localThumbnailBefore rangeOfString:@"Documents/"].location;
            localThumbnailBefore = [localThumbnailBefore substringFromIndex:range];
            NSString *newThumbnail = [[NSString alloc] initWithFormat:@"%@/%@", homeDirectory, localThumbnailBefore];
            dict[@"thumbnail"] = newThumbnail;
        }
    }
    
    //Okej... sprawdzmy co mamy w katalogu DownloadedScenes, gdzie winno byc to co w downloadedList
    MTFileManager *fileManager = [MTFileManager defaultManager];
    NSString *localDirectory = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/DownloadedScenes"];
    
    if ([fileManager fileExistsAtPath:localDirectory])
    {
        for (int i=0; i<downloadedlist.count; i++)
        {
            if (![fileManager fileExistsAtPath:downloadedlist[i][@"local_file"]])
            {
                [downloadedlist removeObjectAtIndex:i];
            }
        }
        
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:localDirectory error:nil];
        
        for (NSString *path in fileArray)
        {
            
            NSString *fullPath = [[NSString alloc] initWithFormat:@"%@/%@", localDirectory, path];
            
            if (downloadedlist.count == 0)
            {
                [fileManager removeItemAtPath:fullPath error:nil];
            }
            
            /*for (NSMutableDictionary *object in downloadedlist)
            {
               
                if ([object[@"local_file"] isEqualToString:fullPath] == [object[@"thumbnail"] isEqualToString:fullPath])
                {
                    [fileManager removeItemAtPath:fullPath error:nil];
                }
                
            }*/
        }
        
        [self saveSnapshotOfDownloadedList];
    
    }
    
    ////NSLog(@"DOWNLOAD LIST: %@", downloadedlist);
    
}

-(NSMutableURLRequest *) getAccessTokenRequest {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://allthattrains.com:8000/get_access_token"]];
    NSDictionary *requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"Jas3", @"username",
                                 @"123qwe", @"password",
                                 nil];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestData options:0 error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    return request;
}

-(NSMutableURLRequest *) saveGameWithFileName:(NSString *) fName {
    NSString *apiKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"apiKey"];
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://allthattrains.com:8000/api/games?apikey=", apiKey];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
   // NSString* myfname =[NSString stringWithFormat:@"%@-%@.mtd",random,ran];
    //NSString *myfname = @"SessionData1.mtd";
    NSString* fpath =[[NSHomeDirectory() stringByAppendingPathComponent: @"Documents"] stringByAppendingPathComponent: fName];
    NSData *imageData = [NSData dataWithContentsOfFile:fpath];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"game_zip\"; filename=\"%@\"\r\n",fName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: multipart/form-data\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    //NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    //[connection start];
    
    return request;
}
-(void)getListMyUploadedcb:(void (^)(NSArray*))cb{
    [self getListMyUploadedcb:cb page:0];
}
-(void)getListMyUploadedcb:(void (^)(NSArray*))cb page:(int)page{
    @synchronized (self) {
    static CKQueryCursor* cursor;
        static BOOL canGetNextPage;
        if (page == 0)
        {
            canGetNextPage=true;        }
        //NSLog(@"I can get Next Page: %d",canGetNextPage);
        if(canGetNextPage){
            canGetNextPage=false;
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"MTSandboxProject" predicate:[NSPredicate predicateWithValue:YES]];
    CKQueryOperation *queryOperation =[[CKQueryOperation alloc] initWithQuery:query];
    
    NSMutableArray *retValues = [[NSMutableArray alloc] init];
    if (page == 0)
    {
        cursor = nil;
    }
    else
    {
        if (cursor == nil)
        {
            cb( retValues);
            canGetNextPage=true;
            return;
        }else
        {
            queryOperation =[[CKQueryOperation alloc] initWithCursor:cursor];
        }
    }

    
    NSString* myavatar = [[[MTAvatarView alloc]init] getAvatarId];
    
    CKContainer *myContainer = [CKContainer containerWithIdentifier:@"iCloud.pl.bedesign.TrainsProject"];
    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
    queryOperation.desiredKeys = @[@"Thumbnail",@"CloudProjectID",@"AppVersion"];
    queryOperation.resultsLimit = 6;//CKQueryOperationMaximumResults;
    
    
    queryOperation.recordFetchedBlock = ^(CKRecord *results)
    {
        NSString *itemId = [NSString stringWithFormat:@"icloud://%@", results.recordID.recordName];
        canGetNextPage=true;
        CKAsset *tnAsset =results[@"Thumbnail"];
      
        
        
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:@{@"file": itemId,
                                                                                    @"author": user,
                                                                                    @"AppVersion":[NSNumber numberWithInt:0],
                                                                                    @"thumbnail": [tnAsset.fileURL path],
                                                                                    @"avatar":myavatar,
                                                                                    @"recordId": results.recordID,
                                                                                    @"shared": [[NSNumber alloc ] initWithBool:(results[@"CloudProjectID"] != NULL)]}];
        
        @try {
            //Próba pobrania wersji. jeśli się nie uda powinno zostać 0.
            item[@"AppVersion"] = results[@"AppVersion"];
        } @catch (NSException *exception) {
        } @finally {
        }
        
        ////NSLog(@"RecordFetched %@",item);
        [retValues addObject:item];
        
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *newCursor, NSError *error)
    {
        ////NSLog(@"Query completed %@",retValues);
        cursor = newCursor;
        
        dispatch_async(dispatch_get_main_queue(), ^{
                cb( retValues );
        });
    };
    
    [privateDatabase addOperation:queryOperation];
        }
    
    }
}
-(void)getSandboxListcb:(void (^)(NSArray*))cb{
    //LISTA SANDBOX LOKALNY
    NSString* myavatar = [[[MTAvatarView alloc]init] getAvatarId];
    NSMutableArray* a = [NSMutableArray array];
    
    for (int i = 1;i<=20;i++){
        if ([[MTArchiver getInstance] getSnapshotWithNr:i]==NULL){
            [a addObject:@{
                           @"id": [NSNumber numberWithInt:i],
                           @"file": [@"sandbox://" stringByAppendingString:[[MTArchiver getInstance] getSaveFilenameWith:i]],
                           @"local_file": [[MTArchiver getInstance] getSavedPathNameWith:i],
                           @"author": @"",
                           @"thumbnail": @"",
                           @"avatar":myavatar,
                           @"stars": @"0"
                           }];
        }else{
            [a addObject:@{
                           @"id": [NSNumber numberWithInt:i],
                           @"file": [@"sandbox://" stringByAppendingString:[[MTArchiver getInstance] getSaveFilenameWith:i]],
                           @"local_file": [[MTArchiver getInstance] getSavedPathNameWith:i],
                           @"author": @"",
                           @"thumbnail": [[MTArchiver getInstance] getSnapshotWithNr:i],
                           @"avatar":myavatar,
                           @"stars": @"0"
                           }];
        }
    }
    
    cb( a);
}

-(void)saveFinished:(NSString*)file{
    if(file != nil){
        int lvl,ch;
        [self getLevel:&lvl Challenge:&ch fromPath:file];
        
        [[MTUserStorage getInstance] setEnabledChallengeSceneNr:ch ForLevel:lvl];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:file];
    }
}

-(BOOL)checkOpened:(NSString *)file{
    int lvl,ch;
    [self getLevel:&lvl Challenge:&ch fromPath:file];
    
    int enabledChallenge = [[MTUserStorage getInstance]getEnabledChallengeForLevel:lvl];
    if (enabledChallenge >= ch){ //if ( [[NSUserDefaults standardUserDefaults] boolForKey:file]){
        return TRUE;
    }else{
        return FALSE;
    }
}
-(NSString*)checkFinished:(NSString*)file{
    int lvl,ch;
    [self getLevel:&lvl Challenge:&ch fromPath:file];
    
    int enabledChallenge = [[MTUserStorage getInstance]getEnabledChallengeForLevel:lvl];
    if ( enabledChallenge >= ch ){//[[NSUserDefaults standardUserDefaults] boolForKey:file]){
        return @"true";
    }else{
        return @"false";
    }
}
-(void)getLevel:(int *)lvl Challenge:(int *)ch fromPath:(NSString*) file{
    NSString* num = [file substringFromIndex:9];
    *lvl = [num intValue];
    NSString* num2 =[num substringFromIndex:2];
    *ch = [num2 intValue];
}

+(NSArray*)decodeList:(NSString*)path{
    if(path!=nil){
        NSData* data = [NSData dataWithContentsOfFile:path];
        //convert the bytes from the file into a string
        NSString* string = [[NSString alloc] initWithBytes:[data bytes]
                                                     length:[data length]
                                                   encoding:NSUTF8StringEncoding];
        
        NSString* delimiter = @"\n";
        NSArray* items = [string componentsSeparatedByString:delimiter];
    
        return items;
    }else{
        return nil;
    }
}

+(NSString*)tanslateToLocalPath:(NSString*)path{
    int offset= 0;
    if([path hasPrefix:@"icloud://"]) offset=9;
    if([path hasPrefix:@"book://"])offset=7;
    if([path hasPrefix:@"task://"]) offset=7;
    
    NSString* type = [path substringFromIndex:[path length]-3];
    NSString* filename = [[path substringFromIndex:offset] substringToIndex:[path length]-4-offset];
    
    
    return [[NSBundle mainBundle] pathForResource:filename ofType:type];
}

-(void)getContestFiles:(NSString*)type cb:(void (^)(NSArray*))cb{
    NSMutableArray*a = [NSMutableArray array];
    NSString* next_opened = @"true"; // pierwsze zawsze otwarte... todo zeby sprawdzac poprzendi poziom.
    
    //Tutaj założenie, że jest zawsze na dysku. offline-true;
    int hm = 10;
    if ([type intValue]==2)hm=6;
    
    for(int i = 1;i<=hm;i++){
        NSString* file = [NSString stringWithFormat:@"task://c_%@_%d.mtd",type,i ];
        [a addObject:@{@"file": file,
                       @"author": @"MT",
                       @"opened": next_opened,
                       @"available_offline":@"true",    //jeśli true, to zostanie ominięte pobieranie a od razu się dobierze do parametrów local_file itp
                       @"opening_level_set":@"2",   //przejście tego poziomu odblokuje zestaw o podanym numerze.
                       @"thumbnail": [NSString stringWithFormat:@"task://c_%@_%d.jpg",type,i ],
                       @"limits": [NSString stringWithFormat:@"task://c_%@_%d.txt",type,i ],
                       @"task": [NSString stringWithFormat:@"task://c_t_%@_%d.png",type,i ],
                       @"taskPro": [NSString stringWithFormat:@"task://c_tp_%@_%d.png",type,i ],
                       @"avatar":@"0-0-0-0"}
         ];
        
        
        next_opened = [self checkFinished:file];
    }
    
    cb( a);
    
}
-(void)getBookFiles:(NSString*)type cb:(void (^)(NSArray*))cb{
    NSMutableArray*a = [NSMutableArray array];
    NSString* next_opened = @"true"; // pierwsze zawsze otwarte... todo zeby sprawdzac poprzendi poziom.
    for(int i = 1;i<=6;i++){
        NSString* file = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"c_%@_%d",type,i ] ofType:@"mtd"];
        [a addObject:@{@"file": [NSString stringWithFormat:@"task://%@",file],
                       @"author": @"MT",
                       @"opened": next_opened,
                       @"thumbnail": [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"task://c_%@_%d",type,i ] ofType:@"jpg"],
                       @"task": [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"task://c_%@_%d",type,i ] ofType:@"png"],
                       @"avatar":@"0-0-0-0"}
         ];
        
                //next_opened = [self checkFinished:file];
    }
    
    cb( a);
    
}


-(void)getShowcaseListcb:(void (^)(NSArray*))cb{


    NSMutableArray*a = [NSMutableArray array];
    
    for(int i = 1;i<=14 ;i++){
        NSString* file = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"s_%d",i ] ofType:@"mtd"];
        NSString * spath = [NSString stringWithFormat:@"task://%@",file];
        
        NSDictionary* slownik = @{@"file": spath,
                                  @"local_file": file,
                                         @"author": @"MT",
                                         @"opened": @"true",
                                         @"thumbnail": [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"s_%d",i ] ofType:@"png"], @"tn":  [NSString stringWithFormat:@"task://s_%d.png",i],
                                        @"task": @"",
                                         @"avatar":@"0-0-0-0"};
        [a addObject:slownik         ];
        
             }
    
    cb( a);
    
}

-(void)getTopRatedCloudList:(int)page cb:(void (^)(NSArray*))cb{
   @synchronized (self) {
       [self getProjectList:page cb:cb recordType:@"MTCloudProject" database:[myContainer publicCloudDatabase] sortDescriptor:[[NSSortDescriptor alloc] initWithKey: @"Stars" ascending:false ]];
    
    }
}
-(void)getCloudListForAll:(int)page cb:(void (^)(NSArray*))cb{
    @synchronized (self) {
         [self getProjectList:page cb: cb recordType:@"MTCloudProject" database:[myContainer publicCloudDatabase]sortDescriptor:[[NSSortDescriptor alloc] initWithKey: @"modificationDate" ascending:true ]];
    }
   
}

-(void)getProjectList:(int)page cb:(void (^)(NSArray*))onSuccess
            recordType:(NSString *) recordType database: (CKDatabase *) database
       sortDescriptor: (NSSortDescriptor*)sortDesc{
    //NSLog(@"Getting %d Page of ...",page);
    static CKQueryCursor* cursor;
    static BOOL canGetNextPage;
    if (page == 0)
    {
        canGetNextPage=true;        }
    //NSLog(@"I can get Next Page: %d",canGetNextPage);
    if(canGetNextPage){
    canGetNextPage=false;
        
    CKQuery *query = [[CKQuery alloc] initWithRecordType:recordType predicate:[NSPredicate predicateWithValue:YES]];
    query.sortDescriptors = @[sortDesc];
    CKQueryOperation *queryOperation =[[CKQueryOperation alloc] initWithQuery:query];
    NSMutableArray *retValues = [[NSMutableArray alloc] init];
    if (page == 0)
    {
        cursor = nil;
    }
    else{
        if (cursor == nil)
        {
            onSuccess( retValues);
            canGetNextPage=true;
            return;
        }else
        {
            queryOperation =[[CKQueryOperation alloc] initWithCursor:cursor];
        }
    }
    
    NSString* myavatar = [[[MTAvatarView alloc]init] getAvatarId];
    
    
    queryOperation.desiredKeys = @[@"Thumbnail",@"UserID",@"Stars",@"AppVersion"];
    queryOperation.resultsLimit = 3;//CKQueryOperationMaximumResults;
    queryOperation.recordFetchedBlock = ^(CKRecord *results)
    {
         canGetNextPage=true;
        if ([recordType isEqualToString:@"MTSandboxProject"])
            [self onFetchedMTSandboxProjectRecord:results WithAvatar: myavatar
            resultsArray: retValues];
        else if([recordType isEqualToString:@"MTCloudProject"])
            [self onFetchedMTCloudProjectRecord: results WithDatabase: database
                                   resultsArray: retValues];
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor *newCursor, NSError *error)
    {
        
        cursor = newCursor;
        if ([recordType isEqualToString:@"MTSandboxProject"])
        dispatch_async(dispatch_get_main_queue(), ^{
            onSuccess( retValues );
        });
        else
            [self getAvatarsFromProjectsList:retValues Page:page
                                    Database:database SuccesCb:onSuccess
                             sortDescription: sortDesc];
    };
    
    [database addOperation:queryOperation];
        
    }
}

-(void)getStarRecordForScene:(CKRecordID*)projRec andUser:(CKRecordID*)userRec
                   completed: (void(^)(CKRecord *))completed failed: (void (^)(NSError*))failed{
    CKDatabase *db = [myContainer publicCloudDatabase];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"UserID = %@ and ProjectID = %@",  [[CKReference alloc] initWithRecordID:userRec action:CKReferenceActionDeleteSelf] ,
        [[CKReference alloc] initWithRecordID:projRec action:CKReferenceActionDeleteSelf]];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"MTStars" predicate:filter];
    
    void (^downloaded)(NSArray<CKRecord *>* , NSError *_Nullable) = ^(NSArray<CKRecord *>* arry, NSError *_Nullable err){
        if (err)
        {
            failed(err);
        }
        if ([arry count] > 0)
            
        {
            completed(arry[0]);
        }
        completed(nil);
    };
    
    [db performQuery:query inZoneWithID:NULL completionHandler: downloaded];
    
}

-(void)uploadStarRecord:(int)mark
               ForScene:(CKRecordID*)projRec
                andUser:(CKRecordID*)userRec
              completed:(void(^)(CKRecord *))completed
                 failed: (void (^)(NSError*))failed{
    CKDatabase *db = [myContainer publicCloudDatabase];

    CKRecord *starRec = [[CKRecord alloc] initWithRecordType:@"MTStars"];
    starRec[@"UserID"] = [[CKReference alloc] initWithRecordID: userRec action: CKReferenceActionDeleteSelf];
    starRec[@"ProjectID"] = [[CKReference alloc] initWithRecordID: projRec action: CKReferenceActionDeleteSelf];
    starRec[@"Stars"] = [[NSNumber alloc] initWithInt: mark];
    
    __block CKReference* ProjectRef = starRec[@"ProjectID"];
    __block NSNumber* ProjectGlobalNote = 0;
    void (^uploaded)(CKRecord * _Nullable , NSError *_Nullable) = ^(CKRecord * _Nullable reco, NSError *_Nullable err){
        if (err)
        {
            failed(err);
        }
        if (reco != NULL)
        {
            NSPredicate *filter = [NSPredicate predicateWithFormat:@"ProjectID = %@",  ProjectRef];
            CKQuery *starrQuery = [[CKQuery alloc] initWithRecordType:@"MTStars" predicate:filter];
            
            void (^countingStars)(NSArray <CKRecord *> * _Nullable, NSError * _Nullable) = ^(NSArray <CKRecord *> * _Nullable marks, NSError * _Nullable error){
                if (error)
                {
                    ////NSLog(@"%@",error);
                }else{
                    float sum = 0.0;
                    int count = 0;
                    for (CKRecord * mark in marks)
                    {
                        sum += ((NSNumber*)mark[@"Stars"]).floatValue;
                        count += 1;
                    }
                    float mark = 0.0;
                    if (count > 0)
                        mark = (sum / count);
                    
                    ProjectGlobalNote = [[NSNumber alloc] initWithFloat:mark];
                    [db fetchRecordWithID:[ProjectRef recordID] completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                        // PObrano record z projektem
                        record[@"Stars"] = ProjectGlobalNote;
                        
                        [db saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                            
                        }];
                    }];
                }
            };
            
            [db performQuery:starrQuery
                inZoneWithID:nil
           completionHandler:countingStars];
            completed(reco);
        }
        completed(nil);
    };
    
    [db saveRecord:starRec completionHandler:uploaded];
}

-(void) getAvatarsFromProjectsList:(NSArray *)projectsList Page:(int)page Database: (CKDatabase *) database SuccesCb:(void (^)(NSArray*))onSuccess sortDescription:(NSSortDescriptor *) sortDesc
{
    //static CKQueryCursor* cursor;
    ////NSLog(@"Query completed %@",projectsList);
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    void (^addAvatarToProject)(int inde) = ^(int ind)
    {
        if((projectsList[ind])[@"UserID"])
        {
            [database fetchRecordWithID: ((CKReference*)(projectsList[ind])[@"UserID"]).recordID completionHandler:^(CKRecord* record, NSError* err)
             {
                 CKRecord * rec = projectsList[ind];
                 NSString *itemId = [NSString stringWithFormat:@"icloud://%@", rec.recordID.recordName];
                 
                 int stars = 0;
                 if (rec[@"Stars"])
                     stars = ((NSNumber *)rec[@"Stars"]).integerValue;
                 
                 NSMutableDictionary* x = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                          @"file": itemId,
                                                                                          @"recordId": rec.recordID,
                                                                                          @"AppVersion": [MTWebApi getAppVersion],
                                                                                          @"thumbnail": [((CKAsset*)rec[@"Thumbnail"]).fileURL path],
                                                                                          @"avatar": record[@"MTUserAvatar"],
                                                                                          @"stars": [NSNumber numberWithInt:stars],//rec[@"Stars"],
                                                                                          @"modificationDate": rec.modificationDate,
                                                                                          @"author": rec.creatorUserRecordID}];
                 
                 
                 @try {
                     x[@"AppVersion"]= rec[@"AppVersion"];
                 } @catch (NSException *exception) {
                     
                 } @finally {
                     
                 }
                 
                
                 [resultArray addObject:x];
                 if (resultArray.count == projectsList.count)
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSSortDescriptor *sdesc = [[NSSortDescriptor alloc] initWithKey:([sortDesc.key isEqualToString: @"Stars"] ? @"stars" : sortDesc.key) ascending: sortDesc.ascending];
                         onSuccess( [resultArray sortedArrayUsingDescriptors:@[sdesc]] );
                     });
             }];
        }
    };
    
    for (int i=0; i < [projectsList count] ; i++)
    {
        addAvatarToProject(i);
    }
}

-(void) onFetchedMTCloudProjectRecord:(CKRecord *)result WithDatabase:(CKDatabase *)database resultsArray:(NSMutableArray *) retValues
{
    ////NSLog(@"RecordFetched %@",result);
    NSLog(@">>%@",result[@"AppVersion"]);
        [retValues addObject:result];

}
-(void) onFetchedMTSandboxProjectRecord:(CKRecord *)results WithAvatar:(NSString*)myavatar
                           resultsArray:(NSMutableArray *) retValues
{
    NSString *itemId = [NSString stringWithFormat:@"icloud://%@", results.recordID.recordName];
    
    CKAsset *tnAsset =results[@"Thumbnail"];
    
    NSDictionary *item = @{@"file": itemId,
                           @"AppVersion": results[@"AppVersion"],
                           @"author": user,
                           @"thumbnail": [tnAsset.fileURL path],
                           @"avatar":myavatar,
                           @"recordId": results.recordID};
    ////NSLog(@"RecordFetched %@",item);
    [retValues addObject:item];
}

+(NSData*)download:(NSString*)addr{
    NSURL* url = [NSURL URLWithString:addr];
    NSData* dat = [NSData dataWithContentsOfURL:url];
    return dat;
}

-(void)deleteSceneFromDevice:(NSDictionary*)scene completion:(void(^)(BOOL))completion {
    //USUSWANIE SCENY Z URZĄDZENIA
    [[MTArchiver getInstance] deleteStorageAtPath: scene[@"local_file"]];
    [[MTArchiver getInstance] deleteMiniatureAtPath: scene[@"thumbnail"]];
    
    completion(YES); //JESLI SIE UDALO
    
}
-(void)uploadToICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(BOOL))completion
{
    if ([[scene objectForKey:@"thumbnail"] length] == 0 ||
        [[scene objectForKey:@"local_file"]length] == 0)
    {
        ////NSLog(@"Niespojny slownik dla metody uploadToICloudScene:");
        return;
    }
    
    CKRecord *sandboxRecord = [[CKRecord alloc] initWithRecordType:@"MTSandboxProject"];

    NSURL *thumbUrl = [NSURL fileURLWithPath:[scene objectForKey:@"thumbnail"]];
    CKAsset *thumb = [[CKAsset alloc] initWithFileURL:thumbUrl];

    NSURL *projectUrl = [NSURL fileURLWithPath:[scene objectForKey:@"local_file"]];
    CKAsset *file = [[CKAsset alloc] initWithFileURL:projectUrl];
    
    //sandboxRecord[@"UserID"] = nil;//[[NSNumber alloc] initWithInt:1];
    sandboxRecord[@"MTStorage"] = file;
    sandboxRecord[@"Thumbnail"] = thumb;
    sandboxRecord[@"AppVersion"] = [MTWebApi getAppVersion];
    sandboxRecord[@"CloudProjectID"] = nil;
    CKReference *userIDRef = [[CKReference alloc] initWithRecordID:user action:CKReferenceActionNone];
    sandboxRecord[@"UserID"] = userIDRef;

    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
    
    [privateDatabase saveRecord:sandboxRecord completionHandler:^(CKRecord *sandboxRecord, NSError *error){
        if (!error) {
            ////NSLog(@"udalo sie %@",error);
        }
        else {
            ////NSLog(@"nie udalo sie %@",error);
        }
    }];
    
    MTiCloudUploader * mtu = [[MTiCloudUploader alloc]init];
    mtu.scene=scene;
    [mtu startUploadWithProgressUpdate:progressUpdate completion:completion];
}

-(void)downloadFromICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion
{
  [self doDownloadProjectFromICloud:scene
                     progressUpdate:progressUpdate
                         completion:completion
                           database:[myContainer publicCloudDatabase]];
}
-(void)downloadMyProjectFromICloud:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion
{
    [self doDownloadProjectFromICloud:scene
                       progressUpdate:progressUpdate
                           completion:completion
                             database:[myContainer privateCloudDatabase]];
}

-(void)doDownloadProjectFromICloud:(NSDictionary*)scene
                    progressUpdate:(void (^)(int))progressUpdate
                        completion:(void(^)(NSDictionary*))completion
                          database:(CKDatabase*)db
{
    MTiCloudDownloader * mtu = [[MTiCloudDownloader alloc]init];
    [db fetchRecordWithID:[scene objectForKey:@"recordId"] completionHandler:^(CKRecord *r, NSError *e) {
        NSMutableDictionary* d = [[NSMutableDictionary alloc]initWithDictionary:scene];
        CKAsset *a = (CKAsset *)r[@"MTStorage"];
        
        NSString *filePath = [a.fileURL path];
        d[@"local_file"] = filePath;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            mtu.scene = d;
            [mtu startDownloadWithProgressUpdate:progressUpdate completion:completion];
        });
    }];
}


-(void)downloadObjectiveFromICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion
{
    MTiCloudDownloader * mtu = [[MTiCloudDownloader alloc]init];
    mtu.scene=scene;
    [mtu startDownloadObjectiveWithProgressUpdate:progressUpdate completion:completion];
}

-(void)downloadThumbnailFromICloudScene:(NSDictionary*)scene progressUpdate:(void (^)(int))progressUpdate completion:(void(^)(NSDictionary*))completion
{
    MTiCloudDownloader * mtu = [[MTiCloudDownloader alloc]init];
    mtu.scene=scene;
    [mtu startDownloadThumbnailWithProgressUpdate:progressUpdate completion:completion];
    
}
-(void)deleteFromICloudScene:(NSDictionary*)scene completion:(void(^)(bool))completion {
    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
    
    void(^deleted) (CKRecordID * _Nullable, NSError * _Nullable) =
    ^(CKRecordID * _Nullable recordID, NSError * _Nullable error){
        if (error)
        {
            ////NSLog(@"Blad usuwania %@ rekordu %@",error,recordID);
            dispatch_async(dispatch_get_main_queue(),^{completion(NO);});
        }
        else
            dispatch_async(dispatch_get_main_queue(),^{completion(YES);});
    };
    
    [privateDatabase deleteRecordWithID:scene[@"recordId"] completionHandler:deleted];
}

-(bool) deleteSceneFromDevice: (NSDictionary*)scene {
    
    MTFileManager *fileManager = [MTFileManager defaultManager];
    //NSError *error = [[NSError alloc] init];
    
    if ([fileManager fileExistsAtPath:scene[@"local_file"]])
    {
        if(![fileManager removeItemAtPath:scene[@"local_file"] error:nil])
            return false;
    }
    
    if ([fileManager fileExistsAtPath:scene[@"thumbnail"]])
    {
        if(![fileManager removeItemAtPath:scene[@"thumbnail"] error:nil])
            return false;
    }
    
    //W przypadku kiedy projekt znajduje sie w Downloaded
    if ([scene[@"local_file"] rangeOfString:@"Documents/DownloadedScenes"].location != NSNotFound)
    {
        
        NSInteger index = [downloadedlist indexOfObjectPassingTest:^BOOL(NSMutableDictionary *dics, NSUInteger i, BOOL *stop) {
            if ([dics[@"local_file"] isEqualToString:scene[@"local_file"]]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        [downloadedlist removeObjectAtIndex:index];
        [self saveSnapshotOfDownloadedList];
        
        //[self synchronizeDownloadedList];
    }
    
    return true;

}

//Dodanie do listy pobranych
//tutaj jakiś zachowanie tej listy pomiędzy uruchomineiami by się przydało :)
-(void)addSceneToList:(NSDictionary*)scene{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithDictionary:scene];
    dict[@"file"] = [NSString stringWithFormat:@"saved://%@",[scene[@"file"] substringFromIndex:9]]; // Zaminaa icloud:// na saved://
    [downloadedlist addObject:dict];
    
    [self saveSnapshotOfDownloadedList];
    
}

-(void) saveSnapshotOfDownloadedList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:downloadedlist] forKey:@"DownloadedScenesList"];
    [defaults synchronize];
}

//LISTA POBRANYCH
-(void)getDownloadedListcb:(void (^)(NSArray*))cb{
    cb( downloadedlist);
}

-(void)changeShareStatus:(NSDictionary*)scene completion:(void(^)(BOOL,BOOL))completion{
    
    void(^comp) (BOOL stat) = ^(BOOL isShared){
        if (isShared)
        {
            [self unshareScene:scene completion:completion];
        }
        else
        {
            [self shareScene:scene completion:completion];
        }
    };
    [self checkIfShared: scene completion:comp];
}
-(void)shareScene:(NSDictionary*)scene completion:(void(^)(BOOL,BOOL))completion{
    //URUCHAMIANA ABY PODZIELIĆ SIĘ SCENĄ BEDĄCĄ W CHMURZE
    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    
    __block CKRecord* SandboxRecord = nil;
    
    void(^modified) () = ^(){
            completion(YES,YES);
        //////NSLog(@"Transakcja przebiegla pomyslnie.");
    };
    void(^uploaded) (CKRecord * _Nullable, NSError * _Nullable) =
    ^(CKRecord * _Nullable record, NSError * _Nullable error){
        if (error)
        {
            ////NSLog(@"Błąd wysylania do MTCloudProject %@ rekordu %@",error, record);
            completion(NO,YES);
        }
        else
        {
            SandboxRecord[@"CloudProjectID"] = [[CKReference alloc] initWithRecord:record
                                                                            action:CKReferenceActionNone];
            CKModifyRecordsOperation * modOp = [[CKModifyRecordsOperation alloc]
                                                            initWithRecordsToSave:@[ SandboxRecord ]
                                                                recordIDsToDelete: NULL];
            [modOp setCompletionBlock:modified];
            [privateDatabase addOperation:modOp];
            //////NSLog(@"Rekord %@ wyslany Pomyslnie", record);
        }
    };
    
    void(^downloaded) (CKRecord * _Nullable, NSError * _Nullable) =
    ^(CKRecord * _Nullable record, NSError * _Nullable error){
        if (error)
        {
            ////NSLog(@"Błąd pobierania z MTSandboxProject %@ rekordu %@",error, record);
            completion(NO,YES);
        }
        else
        {
            [privateDatabase fetchRecordWithID:record.creatorUserRecordID completionHandler:
            ^(CKRecord* userRecord, NSError *err){
                SandboxRecord = record;
                CKRecord *cloudRecord = [[CKRecord alloc] initWithRecordType:@"MTCloudProject"];
                CKAsset *privMTStorage = record[@"MTStorage"];
                CKAsset *pubMTStorage = [[CKAsset alloc] initWithFileURL: [privMTStorage fileURL] ];
                CKAsset *privThumb = record[@"Thumbnail"];
                CKAsset *pubThumb = [[CKAsset alloc] initWithFileURL: [privThumb fileURL] ];
                cloudRecord[@"MTStorage"] = pubMTStorage;
                cloudRecord[@"Thumbnail"] = pubThumb;
                cloudRecord[@"AppVersion"] =  record[@"AppVersion"];
                cloudRecord[@"Stars"] = [NSNumber numberWithInt:0];
                cloudRecord[@"UserID"] = [[CKReference alloc] initWithRecordID:record.creatorUserRecordID action:CKReferenceActionNone];
                cloudRecord[@"SandboxProjectID"] = [[CKReference alloc] initWithRecord: record
                                                                                action: CKReferenceActionDeleteSelf];
                
                [publicDatabase saveRecord:cloudRecord completionHandler:uploaded];
            }];
            
            //if(record[@"UserId"])
                //cloudRecord[@"UserID"] = record[@"UserId"];
            //else
                //cloudRecord[@"UserID"] = [[record creatorUserRecordID] ];
        }
    };
    [privateDatabase fetchRecordWithID:scene[@"recordId"] completionHandler: downloaded];
    [self unshareScene:scene completion:completion];
}
-(void)checkIfShared:(NSDictionary*)scene completion:(void(^)(BOOL))completion{
    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
    
    void(^downloaded) (CKRecord * _Nullable, NSError * _Nullable) =
    ^(CKRecord * _Nullable record, NSError * _Nullable error){
        if (error)
        {
            ////NSLog(@"Błąd pobierania z MTSandboxProject %@ rekordu %@",error, record);
            completion(NO);
        }else
        {
            if (record[@"CloudProjectID"])
                completion(YES);
            else
                completion(NO);
        }
        
    };
    
    [privateDatabase fetchRecordWithID:scene[@"recordId"] completionHandler: downloaded];
    
}
-(void)unshareScene:(NSDictionary*)scene completion:(void(^)(BOOL,BOOL))completion{
    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    
    __block CKRecord* SandboxRecord = nil;
    
    void(^modified) ( NSArray <CKRecord *> *savedRecords, NSArray <CKRecordID *> *deletedRecordIDs, NSError *operationError) =
    ^( NSArray <CKRecord *> *savedRecords, NSArray <CKRecordID *> *deletedRecordIDs, NSError *operationError){
        completion(YES,NO);
    };

    
    void(^deleted) ( NSArray <CKRecord *> *savedRecords, NSArray <CKRecordID *> *deletedRecordIDs, NSError *operationError) =
    ^( NSArray <CKRecord *> *savedRecords, NSArray <CKRecordID *> *deletedRecordIDs, NSError *operationError){
        if(deletedRecordIDs.count > 0){
            SandboxRecord[@"CloudProjectID"] = nil;
            CKModifyRecordsOperation * modOp = [[CKModifyRecordsOperation alloc]
                                                initWithRecordsToSave:@[ SandboxRecord ]
                                                recordIDsToDelete: NULL];
            [modOp setModifyRecordsCompletionBlock:modified];
            [privateDatabase addOperation:modOp];
        }
        else
        {
            completion(NO,NO);
        }
    };
    
    void(^downloaded) (CKRecord * _Nullable, NSError * _Nullable) =
    ^(CKRecord * _Nullable record, NSError * _Nullable error){
        if (error)
        {
            ////NSLog(@"Błąd pobierania z MTSandboxProject %@ rekordu %@",error, record);
            completion(NO,NO);
        }else
        {
            SandboxRecord = record;
            if (record[@"CloudProjectID"])
            {
                CKReference * cloudRecRef = record[@"CloudProjectID"];
                CKModifyRecordsOperation * modOp = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:NULL
                                                                                         recordIDsToDelete:@[[cloudRecRef recordID]]];
                modOp.modifyRecordsCompletionBlock = deleted;
                [publicDatabase addOperation:modOp];
            }
            else
            {
                completion(NO,NO);
            }
        }
        
    };
    
    [privateDatabase fetchRecordWithID:scene[@"recordId"] completionHandler: downloaded];
}


/*
    callback z argumentami: (czy moge ocenić,moja ocena,ocena świata)
 
 */
-(void)checkStars:(NSDictionary*)scene completion:(void(^)(BOOL,int, int))cb
{
    [MTWebApi getUserFinished:^ (CKRecordID* userId){
        CKRecordID* sceneRec = (CKRecordID*)scene[@"recordId"];
        CKRecordID* sceneAuthor = (CKRecordID*)scene[@"author"];
        
        if (sceneAuthor == nil)
        {
            cb(FALSE, 0, 0);
            return;
        }
        int __block world = [scene[@"stars"] integerValue];
        
        void (^ completed) (CKRecord *) = ^(CKRecord * MarkRec) {
            int my = 0;
            if (MarkRec != nil)
                my = [ ( (NSNumber*) [MarkRec valueForKey: @"Stars"]) integerValue];
            
            // to jak ja (myavatar) ocenilem);
            
            if ([userId isEqual: sceneAuthor]){
                //czyli moja scena
                cb(FALSE, 0, world);
            }else{
                //jesli my>0 to znaczy ze oceniles.
                if(my > 0)
                    cb(FALSE, my, world);
                else
                    cb(TRUE, 0, world);
            }

        };
        void (^ failed) (NSError *) = ^(NSError * err) {
            
            ////NSLog(@"%@",err);
        };
        //∂srednia ocena ze swiata
        
        [self getStarRecordForScene: sceneRec andUser: sceneAuthor
                          completed: completed failed: failed];
            }];
}

+(void)setOffline{
    isonline=false;
}
+(void)setOnline{
    isonline=true;
}

-(void)setScene:(NSDictionary*)scene Stars:(int)stars{
    [self uploadStarRecord: stars
                  ForScene: scene[@"recordId"]
                   andUser: user
                 completed: ^(CKRecord* rec){}
                    failed: ^(NSError* err){}];
    
        //WYSYLANIE MOJEJ OCENY DO CHMURY W CHMURZE.
}


+(NSString*)getLang{
    NSString * lang = [NSLocale preferredLanguages].firstObject;
    if ([lang isEqualToString:@"pl-PL"]){return @"pl";}
    return @"en";
}

+(NSNumber*)getAppVersion{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
    NSArray* va  =[version componentsSeparatedByString:@"."];
    return [NSNumber numberWithInt:[va[0] intValue]*1000 + [va[1] intValue]];
}


+(BOOL)getSchool{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleIdentifier"];
    NSArray* va  =[version componentsSeparatedByString:@"."];
    return [@"tpfree" isEqualToString:(NSString*)va.lastObject];
}

+(BOOL)checkServicing{
    servicename = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"servicename"];
    if ([servicename length]>0){
        NSLog(@"Service name set up %@",servicename);
        if (!service){
            NSLog(@"Service not started - starting %@",servicename);
            return [MTWebApi broadcastService];
            
        }else{
            NSLog(@"Service  started already %@",service);
            return true;
        }
    }else{
        return false;
    }
}


- (void)broadCastMessage:(NSString*)message
{
    int socketSD = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (socketSD <= 0) {
        NSLog(@"Error: Could not open socket.");
        return;
    }
    
    // set socket options enable broadcast
    int broadcastEnable = 1;
    int ret = setsockopt(socketSD, SOL_SOCKET, SO_BROADCAST, &broadcastEnable, sizeof(broadcastEnable));
    if (ret) {
        NSLog(@"Error: Could not open set socket to broadcast mode");
        close(socketSD);
        return;
    }
    
    // Configure the port and ip we want to send to
    struct sockaddr_in broadcastAddr;
    memset(&broadcastAddr, 0, sizeof(broadcastAddr));
    broadcastAddr.sin_family = AF_INET;
    inet_pton(AF_INET, "255.255.255.255", &broadcastAddr.sin_addr);
    broadcastAddr.sin_port = htons(1234);
    

    NSString* nsrequest = [NSString  stringWithFormat:@"%@:::%@",servicename,message];
    char *request = [nsrequest cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"Sending message %@",nsrequest);
    ret = sendto(socketSD, request, strlen(request), 0, (struct sockaddr*)&broadcastAddr, sizeof(broadcastAddr));
    if (ret < 0) {
        NSLog(@"Error: Could not open send broadcast.");
        close(socketSD);
        return;
    }
    
    close(socketSD);
    
  
    
}
-(void) stopBroadcasting{
    [service stop];
    servicename = nil;
    [[NSUserDefaults standardUserDefaults] setObject:servicename forKey:@"servicename"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
 //   [service ];
}
+(BOOL)broadcastService{
    
    MTWebApi* delegate = [MTWebApi getInstance];
    in_port_t port = ntohs(1234);
    // setup bonjour service
    servicename = [NSUUID UUID].UUIDString;
    
    //servicename = UIDevice
    NSLog(@"Starting %@",servicename);
    [[NSUserDefaults standardUserDefaults] setObject:servicename forKey:@"servicename"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    service = [[NSNetService alloc] initWithDomain:@""
                                                   type:@"_tpmaster._udp"
                                                   name:servicename
                                                   port:port];
    if(!service)
    {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Unable to advertise service", NSLocalizedDescriptionKey, @"nil returned from NSNetService init", NSLocalizedFailureReasonErrorKey, @"You might like to try clicking listen again to see if the error persists.", NSLocalizedRecoverySuggestionErrorKey, nil]];
        NSLog(@"Error: %@",[error localizedFailureReason]);
        
    }
    [service setDelegate:delegate];
    [service publish];
    return true;

}



-(void)netServiceDidPublish:(NSNetService *)sender{
    //OPUBLIKOWANE
    NSLog(@"OPUBLIKOWANE %@",sender);
}

-(void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *,NSNumber *> *)errorDict{
    NSLog(@"BŁĄD PUBLIKACJI %@ %@",sender,errorDict);
    
}

-(void)attachTI:(NSString*)name{
    masterServiceName = name;
    [[NSUserDefaults standardUserDefaults] setObject:masterServiceName forKey:@"masterServiceName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"WEBAPI Attaching %@",masterServiceName);
    [self starListening];
}
-(void)detachTI{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"masterServiceName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    masterServiceName = @"";
    
}

-(void)checkTI{
    
    browser = [[NSNetServiceBrowser alloc] init];
    [browser setDelegate:self];
    [browser searchForServicesOfType:@"_tpmaster._udp." inDomain:@""];
    if(browser)
    {
        NSLog(@"Browser has been setup");
    }
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
    NSLog(@"Found Service – %@", netService);
    masterService=netService;
    masterServiceName = [netService name];
    NSLog(@"Found Service Name – %@", masterServiceName);
    //[self.del ServiceFound:masterServiceName];
    [self attachTI:masterServiceName];
    
    [netServiceBrowser stop];
  
}



-(void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser
{
    NSLog(@"Service Browser Will Search");
}


-(void) starListening{
    masterServiceName = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"masterServiceName"];
    if ([masterServiceName length]>0){
        NSLog(@"Starting to listen for %@",masterServiceName);
       
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
                [self listenForPackets];
            
        });
    }
}


+(BOOL)checkMasterServiceWorking{
    if (listeningSocket>0){
        return true;
    }else{
        return false;
    }
}

+(BOOL)checkMasterService{
  /*  masterServiceName = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"masterServiceName"];
    if ([masterServiceName length]>0){
        NSLog(@"Master Service name set up %@",masterServiceName);
        
        [[MTWebApi getInstance] starListening];
        return true;
        
    }else{
        NSLog(@"Master Service name not set up");
        
        return false;
    }
   */
    return false;
}





- (void)listenForPackets
{
    
    listeningSocket = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (listeningSocket <= 0) {
        NSLog(@"Error: listenForPackets - socket() failed.");
        return;
    }
    
    // set timeout to 100 seconds.
    struct timeval timeV;
    timeV.tv_sec = 10;
    timeV.tv_usec = 0;
    
    if (setsockopt(listeningSocket, SOL_SOCKET, SO_RCVTIMEO, &timeV, sizeof(timeV)) == -1) {
        NSLog(@"Error: listenForPackets - setsockopt failed");
        close(listeningSocket);
        return;
    }
    
    // bind the port
    struct sockaddr_in sockaddr;
    memset(&sockaddr, 0, sizeof(sockaddr));
    
    sockaddr.sin_len = sizeof(sockaddr);
    sockaddr.sin_family = AF_INET;
    sockaddr.sin_port = htons(1234);
    sockaddr.sin_addr.s_addr = htonl(INADDR_ANY);
    
    int status = bind(listeningSocket, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
    if (status == -1) {
        close(listeningSocket);
        NSLog(@"Error: listenForPackets - bind() failed.");
        return;
    }
    
    
    struct sockaddr_in receiveSockaddr;
    socklen_t receiveSockaddrLen = sizeof(receiveSockaddr);
    
    size_t bufSize = 9216;
        while(true) {
            void *buf = malloc(bufSize);

    ssize_t result = recvfrom(listeningSocket, buf, bufSize, 0, (struct sockaddr *)&receiveSockaddr, &receiveSockaddrLen);
    
    NSData *data = nil;
        NSLog(@"Przysło %d",result);
    if (result > 0) {
        if ((size_t)result != bufSize) {
            buf = realloc(buf, result);
        }
        data = [NSData dataWithBytesNoCopy:buf length:result freeWhenDone:YES];
        
        char addrBuf[INET_ADDRSTRLEN];
        if (inet_ntop(AF_INET, &receiveSockaddr.sin_addr, addrBuf, (size_t)sizeof(addrBuf)) == NULL) {
            addrBuf[0] = '\0';
        }
        
        NSString *address = [NSString stringWithCString:addrBuf encoding:NSASCIIStringEncoding];
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog (@"%@%@", address,msg);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self didReceiveMessage:msg fromAddress:address];
        });
   
    } else {
        free(buf);
    }
     }
    

    close(listeningSocket);
}

- (void)didReceiveMessage:(NSString *)message fromAddress:(NSString *)address
{
    int code = 0;
    code = [[message componentsSeparatedByString:@":::"][1] intValue];
    if(code==5){
        NSLog(@"Deattach");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Deattach" object:self];
    }
    if ([message containsString:masterServiceName]){
        NSLog(@"Got Message: %@ from %@ ::: code %d",message,address,code);
        
        switch (code) {
            case 1:
                
                NSLog(@"Exiting to main Screen");
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteExit" object:self];
                break;
                
            case 2:
                NSLog(@"Clearing All");
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteAllClear" object:self];
                break;
                
            case 3:
                NSLog(@"Blocking interface");
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteBlock" object:self];
                break;
                
            case 4:
                NSLog(@"Un blocking interface");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteUnBlock" object:self];
                
               
                break;
                
            default:
                break;
        }
    }
    
}





@end
