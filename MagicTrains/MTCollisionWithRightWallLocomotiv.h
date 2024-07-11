//
//  MTCollisionWithWallLocomotiv.h
//  MagicTrains
//
//  Created by Dawid Skrzypczyński on 13.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"

@interface MTCollisionWithRightWallLocomotiv : MTCart 
-(bool)runMeWithGhostRepNode:(MTGhostRepresentationNode *)ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(int)getCategory;
-(NSString*)getImageName;
+(NSString*)DoGetMyType;
-(NSString*) getMyType;
@end
