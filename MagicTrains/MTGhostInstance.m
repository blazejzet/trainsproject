//
//  MTGhostInstance.m
//  MagicTrains
//
//  Created by Przemysław Porbadnik on 28.02.2014.
//  Copyright (c) 2014 Przemysław Porbadnik. All rights reserved.
//

#import "MTGhostInstance.h"
#import "MTViewController.h"
#import "MTMainScene.h"
#import "MTStorage.h"
#import "MTGhost.h"
#import "MTSpriteMoodNode.h"



@implementation MTGhostInstance
@synthesize costumeName;
@synthesize costumeVisuals;

-(id) initWithNr: (NSUInteger)ghostNumber
{
    MTStorage *storage = [MTStorage getInstance];
    MTGhost *ghost = [storage getGhostAt:ghostNumber];
    costumeName = ghost.costumeName;
    
    //self.ImageName = @"PAP.png";
    self.node = [[MTSpriteNode alloc] initWithImageNamed:costumeName];
    
    
    self.node.size = CGSizeMake(75, 75);
    self.node.anchorPoint = CGPointMake(0.5, 0.5);
    self.node.position = CGPointMake(0,0);
    self.numberOfMyGhost = ghostNumber;
    
    return self;
};
-(void) setPosition:(CGPoint)pt{
    [self.node setPosition:pt];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MTGhostInstance Changed" object:self];
}
// Serializacja ----------------------------------------------------------------
// Serializacja ----------------------------------------------------------------
// Serializacja ----------------------------------------------------------------
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:[self numberOfMyGhost]forKey:@"numberOfMyGhost"];
    [encoder encodeObject: [self node] forKey:@"node"];
    [encoder encodeObject: [self ImageName] forKey:@"ImageName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [self setNumberOfMyGhost:[decoder decodeIntegerForKey:@"numberOfMyGhost"] ];
    [self setNode:[decoder decodeObjectForKey:@"node"]];
    [self setImageName:[decoder decodeObjectForKey:@"ImageName"]];
    return self;
}
-(MTGhost*)getMyGhost
{
    return [[MTStorage getInstance]getGhostAt:self.numberOfMyGhost];
}

@end
