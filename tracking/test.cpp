#ifdef _CH_
#pragma package <opencv>
#endif

#ifndef _EiC
// include libs
#pragma comment(lib, "cv.lib")
#pragma comment(lib, "highgui.lib")
#pragma comment(lib, "cxcore.lib")

#include "cv.h"
#include "highgui.h"
#include <stdio.h>
#include <ctype.h>
#endif


IplImage *image = 0, *hsv = 0, *hue = 0, *mask = 0, *backproject = 0, *histimg = 0;
CvHistogram *hist = 0;

int select_object = 0;     //select_object = 0,還沒圈選物件  1,已圈選
int track_object = 0;      //1代表開始tracking, 0代表無追縱物件, -1代表初始化 先建model

CvPoint origin;            //取得滑鼠座標所在位置
CvRect selection;          //取得選擇ROI的資訊
CvRect track_window;
CvConnectedComp track_comp;

int hdims = 30;                        //histo要分幾維
float hranges_arr[] = {0,180};         //hue只有0~180而已
float* hranges = hranges_arr;

bool g_bIsFinished = true;


// OpenCV 滑鼠觸發後的回呼函式
void on_mouse( int event, int x, int y, int flags, void* param )  //x-軸  往右為正  最左為0,   y-軸  往下為正  最上為0
{
    if( !image )  //至少要有image才能點滑鼠指標  才能產生下面的ROI 不然跳出
        return;
 
    if( image->origin )                //如果image->origin為1代表該圖以左下為原點 0則是以左上為原點  
        y = image->height - y;         //1則把y值倒置 從下往上是正值  變成左下為0  match原圖座標軸

    if( select_object )                //一開始select_object為0  所以進不來  但是只要一押了滑鼠鍵  就進得來了  代表開始選roi
    {
        selection.x = MIN(x, origin.x);         //滑鼠按下去後  左上角的值隨時在變  所以一直update  取最左的x
        selection.y = MIN(y, origin.y);         
        selection.width = selection.x + CV_IABS(x - origin.x);    //OFFSET加X Y的長度，不能超過整個視窗大小
        selection.height = selection.y + CV_IABS(y - origin.y);   //CV_IAB取絕對值  代表  整個視窗佔整個window的位置
         
        selection.x = MAX( selection.x, 0 );       //X Y OFFSET至少要大於0  如果滑鼠拖超過視窗外  則設為0
        selection.y = MAX( selection.y, 0 );
        selection.width = MIN( selection.width, image->width );       //如果寬或長大過視窗  則先取視窗長度
        selection.height = MIN( selection.height, image->height );    //最大也不會超過視窗大小
        
		selection.width -= selection.x;     //上面所取的視窗長度扣掉OFFSET  不怕滑鼠拖移到視窗外
        selection.height -= selection.y;
    }

    switch( event )
    {
    case CV_EVENT_LBUTTONDOWN:
		{
			origin = cvPoint(x, y);
            selection = cvRect(x, y, 0, 0);     //按鍵一押下去  初始化  先得到roi的初始點(但有可能是roi四個角的其中一個點)
            select_object = 1;               //一旦押了滑鼠鍵  就等於開始選物件
     		break;
		}
    case CV_EVENT_LBUTTONUP:
		{
			select_object = 0;              //一旦放了滑鼠鍵  物件選完
            if( selection.width > 0 && selection.height > 0 )
                track_object = -1;          //有了roi了  可以開始進行tracking的工具了
        
			break;
		}
    }
}

//把原hue轉成RGB
CvScalar hsv2rgb( float hue )
{
    int rgb[3], p, sector;
    static const int sector_data[][3]=
        {{0,2,1}, {1,2,0}, {1,0,2}, {2,0,1}, {2,1,0}, {0,1,2}};
    hue *= 0.033333333333333333333333333333333f;
    sector = cvFloor(hue);
    p = cvRound(255*(hue - sector));
    p ^= sector & 1 ? 255 : 0;

    rgb[sector_data[sector][0]] = 255;
    rgb[sector_data[sector][1]] = 0;
    rgb[sector_data[sector][2]] = p;

    return cvScalar(rgb[2], rgb[1], rgb[0],0);
}

// 開始播放影像
void PlayVideo()
{
	CvCapture* capture = 0;

	capture = cvCaptureFromAVI( "1.avi" ); 

    if( !capture )
    {
        fprintf(stderr,"Could not initialize capturing...\n");
		return;
    }

    cvNamedWindow( "Tracking Demo", 1 );
	cvNamedWindow( "Histogram", 1 );
	cvNamedWindow( "Back Project", 1);

    cvSetMouseCallback( "Tracking Demo", (CvMouseCallback)on_mouse );
 
    for(;;)
    {
        IplImage* frame = 0;
        int i, bin_w, c;

        frame = cvQueryFrame( capture );
        if( !frame )
		{  // 影片播放結束
			g_bIsFinished = true;
            break;
		}

        if( !image )
        {
            /* allocate all the buffers */
            image = cvCreateImage( cvGetSize(frame), 8, 3 );
            image->origin = frame->origin; //如果不加這一行的話  下面copy動作完之後，image->origin會從尾巴開始算  整張影像會倒過來

            hsv = cvCreateImage( cvGetSize(frame), 8, 3 );			
            hue = cvCreateImage( cvGetSize(frame), 8, 1 );            
			mask = cvCreateImage( cvGetSize(frame), 8, 1 );			
           
			backproject = cvCreateImage( cvGetSize(frame), 8, 1 );
			backproject->origin = frame->origin;   
			
			hist = cvCreateHist( 1, &hdims, CV_HIST_ARRAY, &hranges, 1 );
			histimg = cvCreateImage( cvGetSize(frame), 8, 3 );			
            cvZero( histimg );
        }

        cvCopy( frame, image, 0 );
        cvCvtColor( image, hsv, CV_BGR2HSV );

        if( track_object )
        {
            cvInRangeS( hsv, cvScalar(0, 0, 0,0), cvScalar(180, 255, 255, 0), mask );
            cvSplit( hsv, hue, 0, 0, 0 );

            if( track_object < 0 )
            {
                float max_val = 0.f;
                cvSetImageROI( hue, selection );
                cvSetImageROI( mask, selection );
                cvCalcHist( &hue, hist, 0, mask );
                cvGetMinMaxHistValue( hist, 0, &max_val, 0, 0 );
                cvConvertScale( hist->bins, hist->bins, max_val ? 255. / max_val : 0., 0 );
                cvResetImageROI( hue );
                cvResetImageROI( mask );
                track_window = selection;
                track_object = 1;    //此值等於1代表model建好  可以追縱了

				//下面為   建立histogram image
                cvZero( histimg );
                bin_w = histimg->width / hdims;
                for( i = 0; i < hdims; i++ )
                {
                    int val = cvRound( cvGetReal1D(hist->bins, i)*histimg->height/255 );
                    CvScalar color = hsv2rgb(i*180.f/hdims);
                    cvRectangle( histimg, cvPoint(i*bin_w, histimg->height),
                                 cvPoint((i+1)*bin_w, histimg->height - val),
                                 color, -1, 8, 0 );
                }
            }

            cvCalcBackProject( &hue, backproject, hist );
            cvAnd( backproject, mask, backproject, 0 );

			cvMeanShift( backproject, track_window,
				         cvTermCriteria( CV_TERMCRIT_EPS | CV_TERMCRIT_ITER, 10, 1 ),
				         &track_comp );
  
            track_window = track_comp.rect;
			            
			CvScalar cc;
			cc = cvScalar(255, 0, 0);
				
			cvRectangle( image, cvPoint(track_window.x, track_window.y),
				         cvPoint(track_window.x+ track_window.width, track_window.y+ track_window.height),
				         cc, 2, 8, 0 );												 		
        }
        
        if( select_object && selection.width > 0 && selection.height > 0 )
        {
            cvSetImageROI( image, selection );
            cvXorS( image, cvScalarAll(255), image, 0 );
            cvResetImageROI( image );
        }

        cvShowImage( "Tracking Demo", image );
        cvShowImage( "Histogram", histimg );
		cvShowImage( "Back Project", backproject );

	    c = cvWaitKey(150);
        if( c == 27 )   // ESC鍵,跳出程式
            break;

    }

    cvReleaseCapture( &capture );

	cvDestroyWindow( "Back Project" );
	cvDestroyWindow( "Histogram" );
    cvDestroyWindow("Tracking Demo");
}

int main()
{
	while(g_bIsFinished)
	{
		g_bIsFinished = false;
		PlayVideo();
	}

    return 0;
}

