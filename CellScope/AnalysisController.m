//
//  AnalysisController.m
//  CellScope
//
//  Created by Mike D'Ambrosio on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnalysisController.h"

@implementation AnalysisController

-(id)init
{
    self=[super init];
    if (self!=nil){
        array = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)addImage: ( UIImage*) image{
    [array addObject: image];
    
}

-(NSMutableArray *)getImageArray{
	return array;
}

/**
 * Structure to keep one pixel in RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA format
 */

struct pixel {
unsigned char r, g, b, a;
};

- (void) analyzeImages{
    NSLog(@"analyzing from AnalysisController");
    
    //for(UIImage *image in array) {
    UIImage *image=[array objectAtIndex:(NSUInteger)0];
    
    for(int y=1; y<[array count]; y++){
        UIImage *image2=[array objectAtIndex:(NSUInteger)y];
        
        numberOfRedPixels = 0;
        
        struct pixel* pixels = (struct pixel*) calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
        struct pixel* pixels2 = (struct pixel*) calloc(1, image2.size.width * image2.size.height * sizeof(struct pixel));    
        
        if (pixels != nil)
        {
            // Create a new bitmap
            
            CGContextRef context = CGBitmapContextCreate(
                                                         (void*) pixels,
                                                         image.size.width,
                                                         image.size.height,
                                                         8,
                                                         image.size.width * 4,
                                                         CGImageGetColorSpace(image.CGImage),
                                                         kCGImageAlphaPremultipliedLast
                                                         );
            CGContextRef context2 = CGBitmapContextCreate((void*) pixels2,
                                                          image2.size.width,
                                                          image2.size.height,
                                                          8,
                                                          image2.size.width * 4,
                                                          CGImageGetColorSpace(image2.CGImage),
                                                          kCGImageAlphaPremultipliedLast
                                                          );
            
            
            if (context != NULL)
            {
                // Draw the image in the bitmap
                
                CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
                CGContextDrawImage(context2, CGRectMake(0.0f, 0.0f, image2.size.width, image2.size.height), image2.CGImage);

                
                //add up the differences between images
                
                NSUInteger numberOfPixels = image.size.width * image.size.height;
                NSUInteger maxChange=0;
                NSUInteger maxChangeOld=0;
                maxChangePos=0;
                while (numberOfPixels > 0) {
                    int pixel_1r=pixels->r;
                    int pixel_2r=pixels2->r;
                    int pixel_1g=pixels->g;
                    int pixel_2g=pixels2->g;
                    int pixel_1b=pixels->b;
                    int pixel_2b=pixels2->b;
                    maxChange=abs(pixel_1r-pixel_2r)+abs(pixel_1g-pixel_2g)+abs(pixel_1b-pixel_2b);
                    if (maxChange>maxChangeOld){
                        maxChangePos=numberOfPixels;
                    }
                    numberOfRedPixels=numberOfRedPixels+abs(pixel_1r-pixel_2r)+abs(pixel_1g-pixel_2g)+abs(pixel_1b-pixel_2b);
                    
                    
                    pixels++;
                    pixels2++;
                    numberOfPixels--;
                }
                NSLog(@"%@", [NSNumber numberWithInt:numberOfRedPixels]);

            }
            CGContextRelease(context);
            CGContextRelease(context2);
            
            
        }
        if(pixels) {
            //free(pixels);
        }
        if(pixels2) {
            //free(pixels2);
        }	
    }
    UIImage *imagesquare=[self drawSquareOnImage:image];
    UIImageWriteToSavedPhotosAlbum(imagesquare, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}
- (UIImage *)drawSquareOnImage:(UIImage *)image
{
	// begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(image.size);
    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	// set stroking color and draw rect
    //stroke color will depend on the last comparison between images
    if (numberOfRedPixels<10000000){
        [[UIColor greenColor] setStroke];
    }
    else {
        [[UIColor redColor] setStroke];
    }
    
	//draw a rect in a psuedo random spot
    int valuex = (arc4random() % 10)+1;
    int valuey = (arc4random() % 10)+1;

    //NSLog(@"%i", value);
    CGContextStrokeRect(ctx, CGRectMake(valuex*37, valuey*26, 100, 100));
    int value2x = (arc4random() % 10)+1;
    int value2y = (arc4random() % 10)+1;
    CGContextStrokeRect(ctx, CGRectMake(value2x*37, value2y*26, 100, 100));
    int value3x = (arc4random() % 10)+1;
    int value3y = (arc4random() % 10)+1;
    CGContextStrokeRect(ctx, CGRectMake(value3x*37, value3y*26, 100, 100));


	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
	return retImage;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Unable to save the image  
    if (error)
        NSLog(@"error saving image");
    else // All is well
        NSLog(@"image saved in photo album");
}
@end