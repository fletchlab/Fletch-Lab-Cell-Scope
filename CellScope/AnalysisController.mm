//
//  AnalysisController.m
//  CellScope
//
//  Created by Mike D'Ambrosio on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnalysisController.h"
#import "UIImage+OpenCV.h"


@implementation AnalysisController

-(id)init
{
    self=[super init];
    if (self!=nil){
        array = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)addImage: (UIImage*) image{
    [array addObject: image];
    
}

-(NSMutableArray *)getImageArray{
	return array;
}

/**
 * Structure to keep one pixel in RRRRRRRRGGGGGGGGBBBBBBBBAAAAAAAA format
 

struct pixel {
unsigned char r, g, b, a;
};
*/
- (void) analyzeImages{
    
    
    NSLog(@"analyzing from AnalysisController");
    if ([array count]>0){
    //for(UIImage *image in array) {
    //UIImage *image=[array objectAtIndex:(NSUInteger)0];
    
    for(int y=1; y<[array count]; y++){
        double t;
        int times = 1;
        UIImage *image=[array objectAtIndex:(NSUInteger)y-1];

        UIImage *image2=[array objectAtIndex:(NSUInteger)y];

        
        // Convert from UIImage to cv::Mat
        //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        t = (double)cv::getTickCount();
    
        
        //for (int i = 0; i < times; i++)
        //{
            //cv::Mat tempMat= [image2 CVMat];
            //cv::Mat tempMat2= [image CVMat];
        //}
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
        CGFloat cols = image.size.width;
        CGFloat rows = image.size.height;
        
        cv::Mat tempMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
        
        CGContextRef contextRef = CGBitmapContextCreate(tempMat.data,                 // Pointer to backing data
                                                        cols,                       // Width of bitmap
                                                        rows,                       // Height of bitmap
                                                        8,                          // Bits per component
                                                        tempMat.step[0],              // Bytes per row
                                                        colorSpace,                 // Colorspace
                                                        kCGImageAlphaNoneSkipLast |
                                                        kCGBitmapByteOrderDefault); // Bitmap info flags
        
        CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
        CGContextRelease(contextRef);
        CGColorSpaceRef colorSpace2 = CGImageGetColorSpace(image2.CGImage);
        CGFloat cols2 = image2.size.width;
        CGFloat rows2 = image2.size.height;
        
        cv::Mat tempMat2(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
        
        CGContextRef contextRef2 = CGBitmapContextCreate(tempMat2.data,                 // Pointer to backing data
                                                        cols,                       // Width of bitmap
                                                        rows,                       // Height of bitmap
                                                        8,                          // Bits per component
                                                        tempMat2.step[0],              // Bytes per row
                                                        colorSpace2,                 // Colorspace
                                                        kCGImageAlphaNoneSkipLast |
                                                        kCGBitmapByteOrderDefault); // Bitmap info flags
        
        CGContextDrawImage(contextRef2, CGRectMake(0, 0, cols2, rows2), image2.CGImage);
        CGContextRelease(contextRef2);

        
        t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
        
        //[pool release];
        
        NSLog(@"UIImage to cv::Mat: %gms", t);
        
        //do processing
        //cvCopyMakeBorder(Aa,Aab, cvPoint(0,0),IPL_BORDER_CONSTANT, cvScalarAll(0));
        cv::Mat dst(tempMat.size(), tempMat.type());
        cv::absdiff(tempMat, tempMat2, dst);
        //cv::copyMakeBorder(tempMat,dst,50,50,50,50,IPL_BORDER_CONSTANT, cvScalarAll(255) );
        NSLog(@"analysis complete");
        
        
        
        //IplImage* img=cvCreateImage(cvSize(640,480),IPL_DEPTH_8U,1);
        //CvScalar s;
        //IplImage iplimg = grayscaled;
        for( int i = 0; i < dst.rows; i++ )
        { 
            //for( int j = 0; j < grayscaled.cols; j++ )
            for( int j = 0; j < 853; j++ )

            { 
                
                //s=cvGet2D(grayscaled,i,j); // get the (i,j) pixel value
                //printf("intensity=%f\n",s.val[0]);
                //s.val[0]=111;
                //cvSet2D(grayscaled,i,j,s); // set the (i,j) pixel value
                //std::cout << grayscaled.at<uchar>(i,j) << " " << grayscaled.at<uchar>(i,j) << " " << grayscaled.at<uchar>(i,j) << std::endl;
                //IplImage* img=cvCreateImage(cvSize(640,480),IPL_DEPTH_8U,1);
                //CvScalar s;
                //s=cvGet2D(&iplimg,i,j); // get the (i,j) pixel value
                //printf("intensity=%f\n",s.val[0]);
                //s.val[0]=111;
                //cvSet2D(&iplimg,i,j,s); // set the (i,j) pixel value
                //float elem_a_b= grayscaled.ptr<float>(i)[3*j]; //access the first pixel of the element
                //printf("intensity=%f\n",elem_a_b);
                //if (elem_a_b<25){
                //if(j>480)
                    //printf("intensity=%f\n",s.val[0]);

                //if (s.val[0]<25){
                if ((dst.at<cv::Vec3b>(i,j)[0]+dst.at<cv::Vec3b>(i,j)[1]+dst.at<cv::Vec3b>(i,j)[2])<75){
                //if (dst.ptr<float>(i)[3*j]+dst.ptr<float>(i)[3*j+1]+dst.ptr<float>(i)[3*j+2])<75){

                    //dst.ptr<float>(i)[3*j]=0;
                    //dst.ptr<float>(i)[3*j+1]=0;
                    //dst.ptr<float>(i)[3*j+2]=0;
                    dst.at<cv::Vec3b>(i,j)[0] = 0;
                    dst.at<cv::Vec3b>(i,j)[1] = 0;
                    dst.at<cv::Vec3b>(i,j)[2] = 0;
                    //if(i>480)
                    if(j>480) {
                        //NSLog(@"j>480");
                        
                        //NSLog(@"%i",i);

                    }
                //NSLog(@"grayscaled rows%i",grayscaled.rows);

                //NSLog(@"grayscaled cols%i",grayscaled.cols);


                    
                    
                }



            }
        }
        for (int v=0; v<dst.rows; v++)
        {
            for (int t=0; t<dst.cols; t++)
            {
                //if (someArray[i][j] == 0)
                //if (t<480)
                {
                    //dst.at<cv::Vec3b>(v,t)[0] = 0;
                    //dst.at<cv::Vec3b>(v,t)[1] = 0;
                    //dst.at<cv::Vec3b>(v,t)[2] = 0;
                }
            }
        }

        /*for( int y = 0; y < grayscaled.rows; y++ )
            { 
            for( int x = 0; x < grayscaled.cols; x++ )
            { 
                for( int c = 0; c < 3; c++ )
                { 
                new_image.at<Vec3b>(y,x)[c] =cv::saturate_cast<uchar>( alpha*( image.at<Vec3b>(y,x)[c] ) + beta ); 
                }
            }
        }*/

        //cv::Mat myIplImageMat=cv::Mat(&iplimg,true); 

        
        //colormap
        
        cv::Mat(colored);
        cv::cvtColor(dst, colored, CV_BGR2HSV);

            
        // Convert from cv::Mat to UIImage
        // cv::Mat testMat = [image2 CVMat];
        
        t = (double)cv::getTickCount();
        UIImage *outImage; 
        for (int i = 0; i < times; i++)
        {
            outImage = [[UIImage alloc] initWithCVMat:colored];
            //[tempImage release];
        }
        
        t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
        
        NSLog(@"cv::Mat to UIImage: %gms", t);

        //UIImageWriteToSavedPhotosAlbum(outImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        //grayscale mask
        cv::Mat(grayscaled);
        cv::cvtColor(dst, grayscaled, CV_RGB2GRAY );
        cv::Mat(bw);

        cv::threshold(grayscaled,bw,25,255,CV_THRESH_BINARY);
        
        UIImage *outImagebw; 
        outImagebw = [[UIImage alloc] initWithCVMat:bw];
        UIImageWriteToSavedPhotosAlbum(outImagebw, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        
        CvMemStorage *storage;
        CvScalar white, black;
        double area;
        black = CV_RGB( 0, 0, 0 );
        white = CV_RGB( 255, 255, 255 );
        IplImage IplBW=bw;
        
        
                
        
        IplImage *input = cvCloneImage(&IplBW);
        int numContours=0;
        storage = cvCreateMemStorage(0); // pl.Ensure you will have enough room here.
        CvSeq *contour = NULL;
        int size=100;
        cvFindContours(input, storage, &contour, sizeof (CvContour),
                                        CV_RETR_LIST,
                                        CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));


        while(contour)
        {
            area = cvContourArea(contour, CV_WHOLE_SEQ );
            //NSLog(@"area countours: %f", area);

            if(area <= size)
            { // removes white dots
                cvDrawContours( &IplBW, contour, black, black, -1, CV_FILLED, 8 );
            }
            else
            {
                numContours++;
                //if( 0 < area && area <= size) // fills in black holes
                //    cvDrawContours( input, contour, white, white, -1, CV_FILLED, 8 );
            }
            contour = contour->h_next;
        }
        
        
        
        //int num_contours=cvFindContours(&input, storage, &contour, 25,
                       //CV_RETR_LIST,
                       //CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
        
        //int num_contours=cvFindContours(&IplBW, storage, &contour, sizeof (CvContour),
        //               CV_RETR_LIST,
        //               CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
        
        cv::Mat imgMat(&IplBW);  //Construct an Mat image "img" out of an IplImage
        UIImage *outImagebwopen; 
        outImagebwopen = [[UIImage alloc] initWithCVMat:imgMat];
        UIImageWriteToSavedPhotosAlbum(outImagebwopen, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

        NSLog(@"num countours:%i", numContours);
        

        cvReleaseMemStorage( &storage ); // desallocate CvSeq as well.
        cvReleaseImage(&input);



        
        /*
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
                

                CGContextRelease(context);
                CGContextRelease(context2);
                
            }
            NSLog(@"%i", y);
            ///pixels=NULL;
            //pixels2=NULL;
            //free(pixels);
            //free(pixels2);
            
                    }
        if(pixels) {
            //free(pixels);
        }
        if(pixels2) {
            //free(pixels2);
        }
         */
    }
         
    //UIImage *imagesquare=[self drawSquareOnImage:image];
    //UIImageWriteToSavedPhotosAlbum(imagesquare, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
     }
         
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

+ (cv::Mat)cvMatWithImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

int bwareaopen_(IplImage *image, int size)
{
    
    /* OpenCV equivalent of Matlab's bwareaopen.
     image must be 8 bits, 1 channel, black and white
     (objects) with values 0 and 255 respectively */
    
    CvMemStorage *storage;
    CvSeq *contour = NULL;
    CvScalar white, black;
    IplImage *input = NULL; // cvFindContours changes the input
    double area;
    int foundCountours = 0;
    
    black = CV_RGB( 0, 0, 0 );
    white = CV_RGB( 255, 255, 255 );
    
    if(image == NULL || size == 0)
        return(foundCountours);
    
    input = cvCloneImage(image);
    
    storage = cvCreateMemStorage(0); // pl.Ensure you will have enough room here.
    
    cvFindContours(input, storage, &contour, sizeof (CvContour),
                   CV_RETR_LIST,
                   CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
    
    while(contour)
    {
        area = cvContourArea(contour, CV_WHOLE_SEQ );
        if( -size <= area && area <= 0)
        { // removes white dots
            cvDrawContours( image, contour, black, black, -1, CV_FILLED, 8 );
        }
        else
        {
            if( 0 < area && area <= size) // fills in black holes
                cvDrawContours( image, contour, white, white, -1, CV_FILLED, 8 );
        }
        contour = contour->h_next;
    }
    
    cvReleaseMemStorage( &storage ); // desallocate CvSeq as well.
    cvReleaseImage(&input);
    
    return(foundCountours);
    
}


@end