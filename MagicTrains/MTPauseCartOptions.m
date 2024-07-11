//
//  MTPauseCartOptions.m
//  MagicTrains
//

#import "MTPauseCartOptions.h"
#import "MTPauseCart.h"
#import "MTCategoryBarNode.h"
#import "MTViewController.h"
#import "MTGUI.h"
#import "MTStorage.h"
#import "MTGhost.h"

@implementation MTPauseCartOptions

static MTPauseCartOptions *myInstanceMTPCU;

+(void)clear
{
    myInstanceMTPCU = nil;
}
-(id) init
{
    self = [super init];
    self.timePanel = [[MTWheelPanel alloc]init];

    [self prepareOptions];
    return self;
}

-(void) prepareOptions
{
    [self.timePanel prepareAsMiddlePanelWithMax:MAX_CART_TIME Min:MIN_CART_TIME fullRotate:MAX_CART_TIME /2];
}

-(void) showOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    if (categoryBarNode.someOptionsOpened == false)
    {
        categoryBarNode.someOptionsOpened = true;
        
        [self.timePanel showPanel];
        
        [categoryBarNode openBlocksArea];
    }
}

-(void) hideOptions
{
    MTCategoryBarNode *categoryBarNode = (MTCategoryBarNode*)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTCategoryBarNode"];
    
    [self.timePanel hidePanel];
    
    categoryBarNode.someOptionsOpened = false;
}
///--------------------------------------------------------------------------///
// Serializacja                                                               //
///--------------------------------------------------------------------------///

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.timePanel = [aDecoder decodeObjectForKey:@"timePanel"];
    
    [self prepareOptions];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.timePanel forKey:@"timePanel"];
}
@end
