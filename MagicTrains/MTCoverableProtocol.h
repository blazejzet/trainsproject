//
//  MTCoverableProtocol.h
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 04.10.2015.
//  Copyright © 2015 UMK. All rights reserved.
//

#ifndef MTCoverableProtocol_h
#define MTCoverableProtocol_h
#import "MTBlockNode.h"
@protocol MTCoverableProtocol
-(void) whenBlockNodeIsAboveMe:(MTBlockNode* ) blockNode;
@end
#endif /* MTCoverableProtocol_h */
