//
//  UIImage+Filter.m
//  BLE-LED
//
//  Created by xlliu on 14-9-10.
//  Copyright (c) 2014年 jiuzhou. All rights reserved.
//

#import "UIImage+Filter.h"

@implementation UIImage (Filter)

- (UIImage *)withFilterName:(NSString *)filterName
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *cImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setDefaults];
    
    [filter setValue:cImage forKey:kCIInputImageKey];
    
    CGImageRef cgImage = [context createCGImage:filter.outputImage
                                       fromRect:filter.outputImage.extent];
    
    UIImage *outputImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return outputImage;

}

@end
