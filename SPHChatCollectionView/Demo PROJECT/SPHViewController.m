//
//  SPHViewController.m
//  SPHChatCollectionView
//
//  Created by Siba Prasad Hota on 14/06/14.
//  Copyright (c) 2014 Wemakeappz. All rights reserved.
//

#import "SPHViewController.h"




// BELOW ITEMS FOR COLLECTION VIEW

#import "SPHCollectionViewcell.h"
#import "SPH_PARAM_List.h"
#import "iosMacroDefine.h"
static NSString *CellIdentifier = @"cellIdentifier";



@interface SPHViewController ()

@end

@implementation SPHViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    sphBubbledata =[[NSMutableArray alloc]init];
    
    UINib *cellNib = [UINib nibWithNibName:@"View" bundle:nil];
    [self.sphChatTable registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    
    [self SetupDummyMessages];
    
    isfromMe=NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.sphChatTable addGestureRecognizer:tap];
     self.sphChatTable.backgroundColor =[UIColor clearColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.messageField.leftView = paddingView;
    self.messageField.leftViewMode = UITextFieldViewModeAlways;
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////******* GENERATE RANDOM ID to SAVE IN LOCAL **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


-(NSString *) genRandStringLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////******* SETUP DUMMY MESSAGE / REPLACE THEM IN LIVE **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)SetupDummyMessages
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    //  msg_ID  Any Random ID
    
    //  mediaPath  : Your Message  or  Path of the Image
   
    [self adddMediaBubbledata:kSTextByme mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    //[self performSelector:@selector(messageSent:) withObject:@"0" afterDelay:1];

    [self adddMediaBubbledata:kSTextByOther mediaPath:@"Hello! How are you?" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSTextByme mediaPath:@"I'm doing Great!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSImagebyOther mediaPath:@"Yeah its cool!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSTextByme mediaPath:@"Supports Image too." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSTextByOther mediaPath:@"Yup. I like the tail part of it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    [self adddMediaBubbledata:kSImagebyme mediaPath:@"ImageUrl" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:@"ABFCXYZ"];
    
    [self adddMediaBubbledata:kSImagebyOther mediaPath:@"Hi, check this new control!" mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    [self adddMediaBubbledata:kSTextByme mediaPath:@"lets meet some time for dinner! hope you will like it." mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
    
    
  
    [self.sphChatTable reloadData];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////******* UPDATE WHEN MESSAGE SENT                   **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


-(void)messageSent:(NSString*)rownum
{
    int rowID=[rownum intValue];
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:rowID];
    
    [sphBubbledata  removeObjectAtIndex:rowID];
    feed_data.chat_send_status=kSent;
    [sphBubbledata insertObject:feed_data atIndex:rowID];
   
   // [self.sphChatTable reloadData];
   
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:rowID inSection:0],
                           // Add some more index paths if you want here
                           nil];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.sphChatTable reloadItemsAtIndexPaths:indexPaths];
    [UIView setAnimationsEnabled:animationsEnabled];
}

-(void)scrollTableview
{
    
    NSInteger item = [self collectionView:self.sphChatTable numberOfItemsInSection:0] - 1;
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self.sphChatTable
     scrollToItemAtIndexPath:lastIndexPath
     atScrollPosition:UICollectionViewScrollPositionBottom
     animated:NO];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////*******       SEND MESSAGE PRESSED                 **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)sendMessageNow:(id)sender
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    if ([self.messageField.text length]>0) {
        
        if (isfromMe)
        {
            NSString *rowNum=[NSString stringWithFormat:@"%d",(int)sphBubbledata.count];
            [self adddMediaBubbledata:kSTextByme mediaPath:self.messageField.text mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSending msg_ID:[self genRandStringLength:7]];
            [self performSelector:@selector(messageSent:) withObject:rowNum afterDelay:1];
            
            isfromMe=NO;
        }
        else
        {
            [self adddMediaBubbledata:kSTextByOther mediaPath:self.messageField.text mtime:[formatter stringFromDate:date] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:[self genRandStringLength:7]];
            isfromMe=YES;
        }
        
        [self.sphChatTable reloadData];
        [self scrollTableview];
    }
}


-(void)adddMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID
{
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    [sphBubbledata addObject:feed_data];
}




/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////******* KEYBOARD UPDOWN EVENT                      **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (sphBubbledata.count>2) {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    }
    
    CGRect msgframes=self.msgInPutView.frame;
    //CGRect btnframes=self.sendChatBtn.frame;
    CGRect tableviewframe=self.sphChatTable.frame;
    msgframes.origin.y=self.view.frame.size.height-260;
    tableviewframe.size.height-=200;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame=msgframes;
        self.sphChatTable.frame=tableviewframe;
    }];
    
   
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{ CGRect msgframes=self.msgInPutView.frame;
    //CGRect btnframes=self.sendChatBtn.frame;
    CGRect tableviewframe=self.sphChatTable.frame;
    
    msgframes.origin.y=self.view.frame.size.height-50;
    tableviewframe.size.height+=200;
    self.sphChatTable.frame=tableviewframe;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.msgInPutView.frame=msgframes;
    }];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////******* COLLECTION VIEW DELEGATE METHODS           **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[sphBubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kSTextByme]||[feed_data.chat_media_type isEqualToString:kSTextByOther])
    {
        
        NSStringDrawingContext *ctx = [NSStringDrawingContext new];
        NSAttributedString *aString = [[NSAttributedString alloc] initWithString:feed_data.chat_message];
        UITextView *calculationView = [[UITextView alloc] init];
        [calculationView setAttributedText:aString];
        CGRect textRect = [calculationView.text boundingRectWithSize: CGSizeMake(TWO_THIRDS_OF_PORTRAIT_WIDTH, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:calculationView.font} context:ctx];
        
        return CGSizeMake(306,textRect.size.height+40);
    }
    
    
    return CGSizeMake(306, 90);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return sphBubbledata.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     SPHCollectionViewcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        for (UIView *v in [cell.contentView subviews])
            [v removeFromSuperview];
        
        if ([self.sphChatTable.indexPathsForVisibleItems containsObject:indexPath])
        {
            [cell setFeedData:(SPH_PARAM_List*)[sphBubbledata objectAtIndex:indexPath.row]];
        }
    });
    return cell;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////******* COLLECTION VIEW DELEGATE ENDS     **************/////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
