//
//  MTNotSandboxProjectOrganizer.m
//  TrainsProject
//
//  Created by Mateusz Wieczorkowski on 03.04.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTNotSandboxProjectOrganizer.h"
#import "MTCodeTabNode.h"

@implementation MTNotSandboxProjectOrganizer

static MTNotSandboxProjectOrganizer *myMTNotSandboxProjectOrganizerInstance;

+(MTNotSandboxProjectOrganizer*) getInstance{
    if (myMTNotSandboxProjectOrganizerInstance != nil)
        return myMTNotSandboxProjectOrganizerInstance;
    
    myMTNotSandboxProjectOrganizerInstance = [[MTNotSandboxProjectOrganizer alloc] init];
    return myMTNotSandboxProjectOrganizerInstance;
}

-(id)init
{
    if (self = [super init])
    {
        self.cbn = (MTCategoryBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCategoryBarNode"];
        self.can = (MTCodeAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCodeAreaNode"];
        self.gbn = (MTGhostsBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTGhostsBarNode"];
        self.mainscene = (MTMainScene*)[MTViewController getInstance].mainScene;
        self.resources = [MTResources getInstance];
        
        /* Tablica bedzie zawierala ilosc wagonow w danej kategorii 
         np. self.CartsInCategories[1] bedzie zawieralo NSNumber z iloscia wagonow w pierwszej od gory kategorii */
        self.CartsInCategories = [NSMutableArray array];
        for (int i=0; i<7; i++)
        {
            [self.CartsInCategories addObject:[NSNumber numberWithInt:0]];
        }
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(tabChange:)
                                                     name:@"Tab"
                                                   object:nil];*/
    }
    return self;
}

/* KATEGORIE WAGONÓW Z MTCategoryBarNode'a
 ----------------------------------------*/
-(void)calculateCartsInCategories
{
    self.CartsInCategories = [NSMutableArray array];
    
    for (int i=0; i<7; i++)
    {
        [self.CartsInCategories addObject:[NSNumber numberWithInt:0]];
    }
    
    [self preprareCarts];
    
    for (MTCart *cart in self.resources.carts.allValues)
    {
        if ([cart isActive])
        {
            int val = [self.CartsInCategories[[cart getCategory]] intValue];
            [self.CartsInCategories replaceObjectAtIndex:[cart getCategory] withObject:[NSNumber numberWithInt:val+1]];
        }
    }
    
    /* Tu można sprawdzić czy działa przeliczanie wagonów*/
     ////NSLog(@"AKTUALNE STATY CARTSOW W KATEGORIACH: %@", self.CartsInCategories);
}

-(void)unactiveCategoryIconsWithoutCarts
{
    self.cbn = (MTCategoryBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCategoryBarNode"];
    self.can = (MTCodeAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCodeAreaNode"];
    
    for (MTSpriteNode *icon in self.cbn.children)
    {
        if([icon isKindOfClass:[MTCategoryIconNode class]])
        {
            int categoryNumber = ((MTCategoryIconNode *)icon).CategoryNumber;
            
            //Wyeliminowanie kategorii ustawień
            if (categoryNumber != 50)
            {
                if ([[self.CartsInCategories objectAtIndex:categoryNumber] intValue] == 0)
                    [((MTCategoryIconNode *)icon) makeMeUnactive];
                else
                    [((MTCategoryIconNode *)icon) makeMeActive];
            }
        }
    }
}

-(void)unactiveAllCategoryIcons
{
    self.cbn = (MTCategoryBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCategoryBarNode"];
    self.can = (MTCodeAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCodeAreaNode"];
    
    for (MTSpriteNode *icon in self.cbn.children)
    {
        if([icon isKindOfClass:[MTCategoryIconNode class]])
        {
            int categoryNumber = ((MTCategoryIconNode *)icon).CategoryNumber;
            if (categoryNumber != 50)
                [((MTCategoryIconNode *)icon) makeMeUnactive];
        }
    }
}

/*Jeśli projekt jest typu sandbox*/
-(void)activeAllCategoryIcons
{
    self.cbn = (MTCategoryBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCategoryBarNode"];
    self.can = (MTCodeAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCodeAreaNode"];
    
    for (MTSpriteNode *icon in self.cbn.children)
    {
        if([icon isKindOfClass:[MTCategoryIconNode class]])
        {
            int categoryNumber = ((MTCategoryIconNode *)icon).CategoryNumber;
            if (categoryNumber != 50)
                [((MTCategoryIconNode *)icon) makeMeActive];
        }
    }
}


/*TABY Z MTCodeAreaNode'a
 -----------------------*/

-(bool) isSelectedTabBlocked
{
    self.can = (MTCodeAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCodeAreaNode"];
    self.gbn = (MTGhostsBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTGhostsBarNode"];
    int selectedTab = [self.can getSelectedTabNumber];
    
    /*USTAWIAM BOOL'e*/
    bool byTapNumber = (selectedTab==0 || selectedTab==3);
    bool learnORquest = ([MTStorage getInstance].ProjectType == MTProjectTypeLearn || [MTStorage getInstance].ProjectType == MTProjectTypeQuest);
    bool sandboxORshared = ([MTStorage getInstance].ProjectType == MTProjectTypeUser || [MTStorage getInstance].ProjectType == MTProjectTypeShared);
    bool byGhost = [((MTGhost *)[self.gbn getSelectedGhost]) getAllowedCoding];
    //bool byProjectType = true;
    
    /*Typ projektu LEARN lub QUEST*/
    if (learnORquest)
    {
        if (byGhost)
        {
            if (byTapNumber)
            {
                
                return true;
                
            } else {
                
                return false;
                
            }
            
        } else {
            
            return true;
            
        }
        
    }
    
    /*TYP PROJEKTU SHARED*/
    
    if (sandboxORshared)
    {
        if (byGhost)
        {
            return false;
            
        } else {
            
            return true;
            
        }
    }
    
    
    return true;
}

-(void) preprareCategoryIconsForThisTap
{
    if(![self isSelectedTabBlocked])
    {
        [self unactiveCategoryIconsWithoutCarts];
    } else {
        [self unactiveAllCategoryIcons];
    }
        
}

-(bool) isThisTabBlocked: (int)tabNumber
{
    self.can = (MTCodeAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCodeAreaNode"];
    self.gbn = (MTGhostsBarNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTGhostsBarNode"];
    int selectedTab = tabNumber;
    
    /*USTAWIAM BOOL'e*/
    bool byTapNumber = (selectedTab==0 || selectedTab==3);
    bool learnORquest = ([MTStorage getInstance].ProjectType == MTProjectTypeLearn || [MTStorage getInstance].ProjectType == MTProjectTypeQuest);
    bool sandboxORshared = ([MTStorage getInstance].ProjectType == MTProjectTypeUser || [MTStorage getInstance].ProjectType == MTProjectTypeShared);
    bool byGhost = [((MTGhost *)[self.gbn getSelectedGhost]) getAllowedCoding];
    //bool byProjectType = true;
    
    /*Typ projektu LEARN lub QUEST*/
    if (learnORquest)
    {
        if (byGhost)
        {
            if (byTapNumber)
            {
                
                return true;
                
            } else {
                
                return false;
                
            }
            
        } else {
            
            return true;
            
        }
        
    }
    
    /*TYP PROJEKTU SHARED*/
    
    if (sandboxORshared)
    {
        if (byGhost)
        {
            return false;
            
        } else {
            
            return true;
            
        }
    }
    
    
    return true;
}

-(void) prepareCategoryIconsForTab: (int)tabNumber
{
    if(![self isThisTabBlocked:tabNumber])
    {
        [self unactiveCategoryIconsWithoutCarts];
    } else {
        [self unactiveAllCategoryIcons];
    }
}

-(void) updateTabTextures
{
    
    self.can = (MTCodeAreaNode *)[[[MTViewController getInstance].mainScene childNodeWithName:@"MTRoot"]childNodeWithName:@"MTCodeAreaNode"];
    
    for (MTSpriteNode* child in self.can.tabParent.children)
    {
        if ([child isKindOfClass:[MTCodeTabNode class]])
        {
            int tabNumber = ((MTCodeTabNode*) child).tabNumber;
            
            //Sprawdzam czy to tab dla klona
            if (tabNumber == 3 || tabNumber == 4)
            {
                if([self isThisTabBlocked:tabNumber])
                {
                    
                    [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"cloneCodeTabDisabled"]]];
                    
                } else {
                    
                    [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"cloneCodeTab"]]];
                    
                }
            } else {
                
                if([self isThisTabBlocked:tabNumber])
                {
                    
                    [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"codeTabDisabled"]]];
                    
                } else {
                    
                    [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"codeTab"]]];
                    
                }
            }
        
        }
    }
    
    int selectedTab = [self.can getSelectedTabNumber];
    
    for (MTSpriteNode* child in self.can.tabParent.children)
    {
        if ([child isKindOfClass:[MTCodeTabNode class]])
        {
            
            int tabNumber = ((MTCodeTabNode*) child).tabNumber;

            if (selectedTab == tabNumber && (tabNumber == 3 || tabNumber == 4))
            {
                
                if([self isThisTabBlocked:tabNumber])
                {
                    
                    [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"selectedCloneCodeTabDisabled"]]];
                    
                } else {
                    
                    [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"selectedCloneCodeTab"]]];
                    
                }
                
                
            } else {
                
                if (selectedTab == tabNumber)
                    if([self isThisTabBlocked:tabNumber])
                    {
                        
                        [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"selectedCodeTabDisabled"]]];
                        
                    } else {
                        
                        [child runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"selectedCodeTab"]]];
                        
                    }
                
            }
                
                
            }
    }
    
    
    
    
}

/*PRZYGOTOWANIE WAGONOW*/
-(void) preprareCarts {
    
    self.mainscene = (MTMainScene*)[MTViewController getInstance].mainScene;
    
    bool byProjectType = ([MTStorage getInstance].ProjectType == MTProjectTypeLearn || [MTStorage getInstance].ProjectType == MTProjectTypeQuest);
    
    if (!byProjectType)
    {
        for (MTCart *cart in self.resources.carts.allValues)
        {
            cart.activeNow = true;
        }
    } else {
        
        for (MTCart *cart in self.resources.carts.allValues)
        {
            cart.activeNow = false;
        }
    
        for (NSString *cart in self.mainscene.inactiveCartList)
        {
            ((MTCart*)[self.resources.carts valueForKey:cart]).activeNow = true;
        }
    }
    
}

@end
