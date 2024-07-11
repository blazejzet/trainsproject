//
//  MTHpReduceValueCart.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 27.04.2014.
//  Copyright (c) 2014 UMK. All rights reserved.
//

#import "MTCart.h"

@class MTGhostRepresentationNode;
@interface MTHpReduceValueCart : MTCart

//-(void)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
-(int)getCategory;
-(NSString*)getImageName;
+(NSString*)DoGetMyType;


@end
