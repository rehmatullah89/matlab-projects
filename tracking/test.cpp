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

int select_object = 0;     //select_object = 0,�٨S��磌��  1,�w���
int track_object = 0;      //1�N��}�ltracking, 0�N��L�l�a����, -1�N���l�� ����model

CvPoint origin;            //���o�ƹ��y�ЩҦb��m
CvRect selection;          //���o���ROI����T
CvRect track_window;
CvConnectedComp track_comp;

int hdims = 30;                        //histo�n���X��
float hranges_arr[] = {0,180};         //hue�u��0~180�Ӥw
float* hranges = hranges_arr;

bool g_bIsFinished = true;


// OpenCV �ƹ�Ĳ�o�᪺�^�I�禡
void on_mouse( int event, int x, int y, int flags, void* param )  //x-�b  ���k����  �̥���0,   y-�b  ���U����  �̤W��0
{
    if( !image )  //�ܤ֭n��image�~���I�ƹ�����  �~�ಣ�ͤU����ROI ���M���X
        return;
 
    if( image->origin )                //�p�Gimage->origin��1�N��ӹϥH���U�����I 0�h�O�H���W�����I  
        y = image->height - y;         //1�h��y�ȭ˸m �q�U���W�O����  �ܦ����U��0  match��Ϯy�жb

    if( select_object )                //�@�}�lselect_object��0  �ҥH�i����  ���O�u�n�@��F�ƹ���  �N�i�o�ӤF  �N��}�l��roi
    {
        selection.x = MIN(x, origin.x);         //�ƹ����U�h��  ���W�������H�ɦb��  �ҥH�@��update  ���̥���x
        selection.y = MIN(y, origin.y);         
        selection.width = selection.x + CV_IABS(x - origin.x);    //OFFSET�[X Y�����סA����W�L��ӵ����j�p
        selection.height = selection.y + CV_IABS(y - origin.y);   //CV_IAB�������  �N��  ��ӵ��������window����m
         
        selection.x = MAX( selection.x, 0 );       //X Y OFFSET�ܤ֭n�j��0  �p�G�ƹ���W�L�����~  �h�]��0
        selection.y = MAX( selection.y, 0 );
        selection.width = MIN( selection.width, image->width );       //�p�G�e�Ϊ��j�L����  �h������������
        selection.height = MIN( selection.height, image->height );    //�̤j�]���|�W�L�����j�p
        
		selection.width -= selection.x;     //�W���Ҩ����������צ���OFFSET  ���ȷƹ��첾������~
        selection.height -= selection.y;
    }

    switch( event )
    {
    case CV_EVENT_LBUTTONDOWN:
		{
			origin = cvPoint(x, y);
            selection = cvRect(x, y, 0, 0);     //����@��U�h  ��l��  ���o��roi����l�I(�����i��Oroi�|�Ө����䤤�@���I)
            select_object = 1;               //�@����F�ƹ���  �N����}�l�磌��
     		break;
		}
    case CV_EVENT_LBUTTONUP:
		{
			select_object = 0;              //�@����F�ƹ���  ����粒
            if( selection.width > 0 && selection.height > 0 )
                track_object = -1;          //���Froi�F  �i�H�}�l�i��tracking���u��F
        
			break;
		}
    }
}

//���hue�নRGB
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

// �}�l����v��
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
		{  // �v�����񵲧�
			g_bIsFinished = true;
            break;
		}

        if( !image )
        {
            /* allocate all the buffers */
            image = cvCreateImage( cvGetSize(frame), 8, 3 );
            image->origin = frame->origin; //�p�G���[�o�@�檺��  �U��copy�ʧ@������Aimage->origin�|�q���ڶ}�l��  ��i�v���|�˹L��

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
                track_object = 1;    //���ȵ���1�N��model�ئn  �i�H�l�a�F

				//�U����   �إ�histogram image
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
        if( c == 27 )   // ESC��,���X�{��
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

