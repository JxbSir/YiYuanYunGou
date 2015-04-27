//
//  UIImage+LMImage.m
//  LMFramework
//
//  Created by LMinh on 28/12/2013.
//  Copyright (c) 2013 LMinh. All rights reserved.
//

#import "UIImage+LMImage.h"

@implementation UIImage (LMImage)

#pragma mark - CREATE IMAGE

+ (UIImage *)imageFromView:(UIView *)theView withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // -renderInContext: renders in the coordinate space of the layer,
    // so we must first apply the layer's geometry to the graphics context
    CGContextSaveGState(context);
    // Center the context around the window's anchor point
    CGContextTranslateCTM(context, size.width/2, size.height/2);
    // Apply the window's transform about the anchor point
    CGContextConcatCTM(context, [theView transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[theView bounds].size.width * [[theView layer] anchorPoint].x,
                          -[theView bounds].size.height * [[theView layer] anchorPoint].y);
    
    //	[theView.layer renderInContext:context];
    [theView drawViewHierarchyInRect:[theView bounds] afterScreenUpdates:NO];
    
    // Restore the context
    CGContextRestoreGState(context);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


#pragma mark - CUSTOMIZE IMAGE

- (UIImage *)blurredImageWithRadius:(CGFloat)radius
                         iterations:(NSUInteger)iterations
                          tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

@end
