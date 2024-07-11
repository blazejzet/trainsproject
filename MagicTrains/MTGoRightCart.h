//
//  MTGoRightCart.h
//  MagicTrains
//
//  Created by Kamil Tomasiak on 26.03.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGoCart.h"

@class MTMoveCartsOptions;
@class MTGhostRepresentationNode;
@interface MTGoRightCart : MTGoCart

@property bool optionsOpen;
/*-(void)showOptions;
-(void) hideOptions;*/

-(BOOL)runMeWithGhostRepNode:(MTGhostRepresentationNode*) ghostRepNode;
-(MTCart*) getNewWithSubTrain: (MTSubTrain *) train;
//-(int)getCategory;
-(NSString*)getImageName;
+(NSString*)DoGetMyType;





@end
