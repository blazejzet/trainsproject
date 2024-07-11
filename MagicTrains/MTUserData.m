//
//  MTUserData.m
//  TrainsProject
//
//  Created by Przemysław Porbadnik on 19.03.2016.
//  Copyright © 2016 UMK. All rights reserved.
//

#import "MTUserData.h"

@implementation MTUserData

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.MTUserAvatar forKey:@"MTUserAvatar"];
    [coder encodeInt64:self.MTEnabledChallenge1 forKey:@"MTEnabledChallenge1"];
    [coder encodeInt64:self.MTEnabledChallenge2 forKey:@"MTEnabledChallenge2"];
    [coder encodeInt64:self.MTEnabledChallenge3 forKey:@"MTEnabledChallenge3"];
    [coder encodeInt64:self.MTEnabledChallenge4 forKey:@"MTEnabledChallenge4"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.MTUserAvatar = [coder decodeObjectForKey:@"MTUserAvatar"];
        self.MTEnabledChallenge1 = [coder decodeInt64ForKey:@"MTEnabledChallenge1"];
        self.MTEnabledChallenge2 = [coder decodeInt64ForKey:@"MTEnabledChallenge2"];
        self.MTEnabledChallenge3 = [coder decodeInt64ForKey:@"MTEnabledChallenge3"];
        self.MTEnabledChallenge4 = [coder decodeInt64ForKey:@"MTEnabledChallenge4"];
    }
    return self;
}

@end
