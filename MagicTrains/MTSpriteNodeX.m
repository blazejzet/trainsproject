//
//  MTSpriteNodeX.m
//  TrainsProject
//
//  Created by Blazej Zyglarski on 03.04.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTSpriteNodeX.h"
#import "MTGhostsBarNode.h"
#import "MTGUI.h"
#import "MTAudioPlayer.h"

@implementation MTSpriteNodeX

CGPoint MTSpriteNodeXstart;
CGFloat MTSpriteNodeXxstart;


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    MTSpriteNodeXstart=self.position;
    MTSpriteNodeXxstart= [[touches anyObject] locationInNode:self.parent].x;
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   CGFloat MTSpriteNodeXxact = [[touches anyObject] locationInNode:self.parent].x;
    CGFloat dif = MTSpriteNodeXxact - MTSpriteNodeXxstart;
    
    //if(HEIGHT==768 && dif>0){
    //    self.position = CGPointMake(MTSpriteNodeXstart.x + dif, MTSpriteNodeXstart.y);
   // }
    
    if( dif<0 && dif>-80){
        self.position = CGPointMake(MTSpriteNodeXstart.x + dif, MTSpriteNodeXstart.y);
    }
    
    if(HEIGHT==768){//ipadnormal
        if(dif<-50){
            self.texture=[SKTexture textureWithImageNamed:@"stop_simulation_h_full"];
        }else{
            self.texture=[SKTexture textureWithImageNamed:@"stop_simulation_full"];
            
        }//   dif=-dif;
    }else{
    if(dif<-50){
        self.texture=[SKTexture textureWithImageNamed:@"stop_simulation_h"];
    }else{
        self.texture=[SKTexture textureWithImageNamed:@"stop_simulation"];
        
    }
    }
    
    
}


-(void) setup{
    self.texture=[SKTexture textureWithImageNamed:@"stop_simulation"];
    self.position=MTSpriteNodeXstart;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat MTSpriteNodeXxact = [[touches anyObject] locationInNode:self.parent].x;
    CGFloat dif = MTSpriteNodeXxact - MTSpriteNodeXxstart;
    //if(HEIGHT==768){//ipadnormal
     //   dif=-dif;
    //}
        if(dif<-50){
            [(MTGhostsBarNode *)[[self.scene childNodeWithName:@"MTRoot"] childNodeWithName:@"MTGhostsBarNode"]showBarNM];
            [[MTAudioPlayer instanceMTAudioPlayer] play:@"background_codeloop"];
            
            [self performSelector:@selector(setup) withObject:nil afterDelay:1.0];
        }else{
            [self setup];
        }
    
}


-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self setup];
}


@end
