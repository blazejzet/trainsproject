//
//  MTTestFaceView.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTTestFaceView.h"


@interface MTTestFaceView()
@property UIImageView*face;


@end
@implementation MTTestFaceView
@synthesize test;
@synthesize face;
@synthesize g;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 140, 140)];
    if (self) {
        // Initialization code
        face = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help_button"]];
        // Determine our start and stop angles for the arc (in radians)
        [self addSubview:face];
        face.center=CGPointMake(71, 71);
        
        self.userInteractionEnabled=YES;
       
        test = [[TestView alloc]init];
        [self addSubview:test];
        test.g=self;
    }
    return self;
}

-(void)setDelegate:(id<MTAutoHelpProtocol>)g{
    
    self.g=g;
    
}

-(void)startHelp{
    [self.g startHelp];
    [self.face removeFromSuperview ];
}
-(void)resetHelpTimerCounter{
    
}

@end
