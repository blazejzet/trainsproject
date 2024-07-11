//  ENHGlowFilter.h
#import <CoreImage/CoreImage.h>

@interface MTGlowFilter : CIFilter

@property (strong, nonatomic) UIColor *glowColor;
@property (strong, nonatomic) CIImage *inputImage;
@property (strong, nonatomic) NSNumber *inputRadius;
@property (strong, nonatomic) CIVector *inputCenter;

@end
