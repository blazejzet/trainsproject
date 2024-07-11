//
//  MTLocomotive.h
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 08.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTCart.h"
@interface MTLocomotive : MTCart <NSCoding>;
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(int)getCategory;
-(NSString*)getImageName;
-(NSString *)getMyType;
+(NSString*)DoGetMyType;
@end
