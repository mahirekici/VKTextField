//
//  VKTextField.m
//  BOA.IOS.MobileBranch
//
//  Created by Doruk Kaan Bolu on 12.06.2019.
//  Copyright © 2019 Vakıf Katılım. All rights reserved.
//

#import "VKTextField.h"
#import "VKColor.h"

@interface VKTextField ()
@property (nonatomic, strong) CAShapeLayer *barLayer;
@end

@implementation VKTextField

- (void)setupDefaults {
    
    [self.contentView setFrame:self.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleSingleTap:)];
    [self.contentView addGestureRecognizer:tap];
    self.contentView.clipsToBounds = NO;
    
    self.textField.delegate = self;
    [self.textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    self.fontName = @"Gotham-Book";
    self.placeholderFontName = @"GothamNarrow-Book";
    self.errorFontName = @"GothamNarrow-Book";
    self.textType = VKTextFieldTextTypeDefault;
    self.secureTextEntry = NO;
    self.text = @"";
    self.placeholderText = @"";
    self.errorText = @"";
    self.backgroundColor = UIColor.whiteColor;
    self.clipsToBounds = NO;
    self.maxCharacterLength = -1;
    self.showInfoIcon = NO;
    
    VKColor *c = [[VKColor alloc] init];
    self.textField.textColor = c.textColor;
    self.lblPlaceholder.textColor = c.placeholderColor;
    self.lblError.textColor = c.errorColor;
    
    UITapGestureRecognizer *icontap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(handleIconTapped:)];
    [self.vImgTapArea addGestureRecognizer:icontap];
    self.vImgTapArea.alpha = 0;
    self.imgInfo.image = [UIImage imageNamed:@"infov2.png"];
    self.imgInfo.userInteractionEnabled = YES;
    
}

-(void)setKeyboardDoneButton
{
    CGFloat keyboardDoneButtonOffset = 15.0;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:CMLocalizedKey(@"keyboardDoneButton", nil)
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[BTheme colorForKey:@"defaultOrangeTextColor"],NSForegroundColorAttributeName ,nil] forState:UIControlStateNormal];
    
    UILabel *lbl=[[UILabel alloc]init];
    lbl.text=CMLocalizedKey(@"keyboardDoneButton", nil);
    [lbl sizeToFit];
    
    UIBarButtonItem *fixedButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    fixedButton.width=keyboardDoneButtonView.frame.size.width-lbl.frame.size.width-2*keyboardDoneButtonOffset;
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedButton, doneButton, nil]];
    self.textField.inputAccessoryView = keyboardDoneButtonView;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    if(!newSuperview)
        return;
    
    [self setKeyboardDoneButton];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)doneClicked:(id)sender
{
    [self resignFirstResponder];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        if (self.subviews.count == 0) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
            UIView *subview = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
            subview.frame = self.bounds;
            [self addSubview:subview];
            
            [self setupDefaults];
        }
    }
    return self;
}

#pragma mark- TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.textType == VKTextFieldTextTypeMoneyNoDecimal) {
        
        NSString *valueFormatted = [self.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@",_fecCode] withString:@""];
        NSNumber *nValue = [BTextField numberFromString:valueFormatted withFormat:TextFormatTypeMoney];
        double value = [nValue doubleValue];
        if (value == 0.0) {
            [self setPlaceholderPosition:1];
        } else {
            self.textField.text = [BTextField stringFromNumber:nValue withFractionDigits:0 groupingSeperator:@"" decimalSeparator:@","];
        }
    } else if (self.textType == VKTextFieldTextTypeMoney) {
        
        NSString *valueFormatted = _fecCode.length > 0 ? [self.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@",_fecCode] withString:@""] : self.text;
        NSNumber *nValue = [BTextField numberFromString:valueFormatted withFormat:TextFormatTypeMoneyWithDecimal];
        double value = [nValue doubleValue];
        if (value == 0.0) {
            [self setPlaceholderPosition:1];
        } else {
            self.textField.text = [BTextField stringFromNumber:nValue withFractionDigits:2 groupingSeperator:@"" decimalSeparator:@","];
        }
    } else {
        [self setPlaceholderPosition:1];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.textField.text == nil || [self.textField.text isEqualToString:@""]) {
        [self setPlaceholderPosition:0];
    } else {
        if (self.textType == VKTextFieldTextTypeMoneyNoDecimal) {
            NSNumber *nValue = [BTextField numberFromString:self.text withFractionDigits:0 groupingSeperator:@"" decimalSeparator:@","];
            NSString* valueFormatted = [BTextField stringFromNumber:nValue withFormat:TextFormatTypeMoney];
            self.textField.text = [NSString stringWithFormat:[NSString stringWithFormat:@" %@",_fecCode], valueFormatted];
        } else if (self.textType == VKTextFieldTextTypeMoney) {
            NSNumber *nValue = [BTextField numberFromString:self.text withFractionDigits:2 groupingSeperator:@"" decimalSeparator:@","];
            NSString* valueFormatted = [BTextField stringFromNumber:nValue withFormat:TextFormatTypeMoneyWithDecimal];
            self.textField.text = _fecCode.length > 0 ? [NSString stringWithFormat:@"%@ %@", valueFormatted, _fecCode] : valueFormatted;
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(vkTextField:DidEndEditing:)]){            [self.delegate vkTextField:self DidEndEditing:self.text];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@%@",self.text, string];
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if (str.length > self.maxCharacterLength
        && range.length == 0) {
        return NO;
    }
    
    if (self.textType == VKTextFieldTextTypeInteger) {
        if (![self isNumeric:string]) {
            return NO;
        }
    } else if (self.textType == VKTextFieldTextTypeAlpha) {
        if (![self isAlpha:string]) {
            return NO;
        }
    } else if (self.textType == VKTextFieldTextTypeDecimal) {
        if (![self isDecimal:string]) {
            return NO;
        }
    } else if (self.textType == VKTextFieldTextTypeMoneyNoDecimal) {
        if (![self isNumeric:string]) {
            return NO;
        }
    } else if (self.textType == VKTextFieldTextTypeMoney) {
        
        if ([string isEqualToString:@","]) {
            
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"," options:NSRegularExpressionCaseInsensitive error:&error];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.text options:0 range:NSMakeRange(0, [self.text length])];
            
            if (numberOfMatches > 0) {
                return NO;
            }
            
            NSInteger controlCount = self.maxCharacterLength - 3;
            if (self.text.length > controlCount) {
                return NO;
            }
        }
        
        
        NSArray *splitArray = [textField.text componentsSeparatedByString:@","];
        
        if (splitArray.count > 1 &&
            range.length == 0) {
            return !([splitArray.lastObject length] > 1);
        }
        
        if (![self isDecimal:string]) {
            return NO;
        }
    } else if (self.textType == VKTextFieldTextTypePhone) {
      if (string.length) {
        NSLog(@"%d",textField.tag);
        if ([textField tag] == 90) {
          if (textField.text.length<=14) {
                       if (textField.text.length== 3 )  {
                           NSLog(@"%@",textField.text);
                           if ([textField.text containsString:@"("]){
                               
                               } else {
                                NSString *tempStr=[NSString stringWithFormat:@"(%@) ",textField.text];
                                textField.text=tempStr;
                               }
                       } else if (textField.text.length== 4) {
                         NSString *tempStr=[NSString stringWithFormat:@"%@) ",textField.text];
                         textField.text=tempStr;
                       } else if (textField.text.length== 9) {
                           NSString *tempStr=[NSString stringWithFormat:@"%@ ",textField.text];
                           textField.text=tempStr;
                       } else if (textField.text.length== 12) {
                           NSString *tempStr=[NSString stringWithFormat:@"%@ ",textField.text];
                           textField.text=tempStr;
                       } else if (textField.text.length== 13) {
                           NSString *tempStr=[NSString stringWithFormat:@"%@ ",textField.text];
                           textField.text=tempStr;
                       }
                   } else {
                       return NO;
                   }
        }
        else
        {
          if (textField.text.length<=19) {
            return YES;
          }
          else
          {
            return NO;
          }
          
        }
//        if ([textField.text containsString:@"+90"]) {
//
//          if (textField.text.length<=18) {
//            if (textField.text.length== 3 ) {
//                NSString *tempStr=[NSString stringWithFormat:@"%@ ",textField.text];
//                textField.text=tempStr;
//            } else if (textField.text.length== 7) {
//              NSArray *stringComponents = [textField.text componentsSeparatedByString:@" "];
//              NSString *firstPart = [[textField text] substringWithRange:NSMakeRange(0, 3)];
//              NSString *secondPart = [[textField text] substringWithRange:NSMakeRange(4, 3)];
//              NSLog(@"Birinci part = %@",firstPart);
//
//              textField.text=[NSString stringWithFormat:@"%@ (%@) ",firstPart, secondPart];
//            } else if (textField.text.length== 13) {
//              NSString *firstPart = [[textField text] substringWithRange:NSMakeRange(0, 3)];
//              NSString *secondPart = [[textField text] substringWithRange:NSMakeRange(4, 5)];
//              NSString *thirdPart = [[textField text] substringWithRange:NSMakeRange(10, 3)];
//
//              textField.text=[NSString stringWithFormat:@"%@ %@ %@ ",firstPart, secondPart,thirdPart];
//
//            } else if (textField.text.length== 16) {
//                NSString *firstPart = [[textField text] substringWithRange:NSMakeRange(0, 3)];
//                NSString *secondPart = [[textField text] substringWithRange:NSMakeRange(4, 5)];
//                NSString *thirdPart = [[textField text] substringWithRange:NSMakeRange(10, 3)];
//              NSString *fourthPart = [[textField text] substringWithRange:NSMakeRange(14, 2)];
//
//                textField.text=[NSString stringWithFormat:@"%@ %@ %@ %@ ",firstPart, secondPart,thirdPart,fourthPart];
//            } else if (textField.text.length == 18) {
//                NSString *firstPart = [[textField text] substringWithRange:NSMakeRange(0, 3)];
//                NSString *secondPart = [[textField text] substringWithRange:NSMakeRange(4, 5)];
//                NSString *thirdPart = [[textField text] substringWithRange:NSMakeRange(10, 3)];
//              NSString *fourthPart = [[textField text] substringWithRange:NSMakeRange(14, 2)];
//              NSString *fifthPart = [[textField text] substringWithRange:NSMakeRange(16, 2)];
//
//                textField.text=[NSString stringWithFormat:@"%@ %@ %@ %@%@",firstPart, secondPart,thirdPart,fourthPart,fifthPart];
//            }
//          }
//          else
//          {
//            return NO;
//          }
//        }
      }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(vkTextField:shouldChangeCharactersInRange:replacementString:)]) {
            return [self.delegate vkTextField:self shouldChangeCharactersInRange:range replacementString:string];
        }
    }
    
    return YES;
}

-(void)textFieldDidChange:(id)notification {
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(vkTextField:DidChange:)]){
            [self.delegate vkTextField:self DidChange:self.text];
        }
    }
}

#pragma mark- self overrides

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

#pragma mark- custom methods

-(void)handleIconTapped:(UITapGestureRecognizer *)recognizer {
    if (!self.showInfoIcon) {
        return;
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(vkTextFieldInfoIconTapped:)]) {
            [self.delegate vkTextFieldInfoIconTapped:self];
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if (placeholderPosition == 0) {
        [self becomeFirstResponder];
    }
}

-(void) setPlaceholderPosition:(int)position {
    if (placeholderPosition != position) {
        
        [self layoutIfNeeded];
        
        
        [UIView animateWithDuration:0.3
                         animations:^{
            if(position == 0) {
                self.constPlaceholderToUnderline.constant = 9;
                self.lblPlaceholder.transform = CGAffineTransformIdentity;
                self.vImgTapArea.transform = CGAffineTransformIdentity;
                self.vImgTapArea.alpha = self.showInfoIcon ? 0 : 0;
                
            } else {
                self.constPlaceholderToUnderline.constant = 39;
                self.lblPlaceholder.transform = CGAffineTransformScale(self.lblPlaceholder.transform, 14.0/18.0, 14.0/18.0);
                self.lblPlaceholder.transform = CGAffineTransformTranslate(self.lblPlaceholder.transform, self.lblPlaceholder.frame.origin.x * -1.0, 0);
                self.vImgTapArea.alpha = self.showInfoIcon ? 1 : 0;
                self.vImgTapArea.transform = CGAffineTransformTranslate(self.vImgTapArea.transform, self.lblPlaceholder.frame.origin.x * -5.0, -30);
            }
            [self layoutIfNeeded];
        }
                         completion:^(BOOL finished){
            placeholderPosition = position;
        }];
    }
}

-(BOOL)isNumeric:(NSString*) string
{
    for (int i = 0; i < string.length; i++) {
        if(!([string characterAtIndex:i] >= '0' && [string characterAtIndex:i] <= '9')) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)isDecimal:(NSString*) string
{
    for (int i = 0; i < string.length; i++) {
        if(!([string characterAtIndex:i] >= '0' && [string characterAtIndex:i] <= '9') &&
           !([string characterAtIndex:i] == '.' || [string characterAtIndex:i] == ',')) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)isAlpha:(NSString*) strChar
{
    for (int i = 0; i < strChar.length; i++) {
        if(!([strChar characterAtIndex:0] >= 'A' && [strChar characterAtIndex:0] <= 'Z') || ([strChar characterAtIndex:0] >= 'a' && [strChar characterAtIndex:0] <= 'z'))
            return NO;
    }
    return YES;
}

// Designer methods
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.lblPlaceholder.textColor = placeholderColor;
}

-(void) setText:(NSString *)text {
    if (![self.textField.text isEqualToString:text]) {
        if (placeholderPosition == 0 && ![text isEqualToString:@""]) {
            [self setPlaceholderPosition:1];
        } else if (placeholderPosition == 1 && [text isEqualToString:@""]) {
            [self setPlaceholderPosition:0];
        }
        self.textField.text = text;
        //        [self textFieldDidEndEditing:self.textField];
    }
}

-(NSString*) text {
    return self.textField.text;
}

-(void) setFontName:(NSString *)fontName {
    if (![_fontName isEqualToString:fontName]) {
        _fontName = fontName;
        [self.textField setFont:[UIFont fontWithName:self.fontName size:18.0]];
    }
}

-(void) setPlaceholderText:(NSString *)placeholderText {
    if (![self.lblPlaceholder.text isEqualToString:placeholderText]) {
        self.lblPlaceholder.text = placeholderText;
    }
}
-(NSString*) placeholderText {
    return self.lblPlaceholder.text;
}

-(void) setPlaceholderFontName:(NSString *)placeholderFontName {
    if (![_placeholderFontName isEqualToString:placeholderFontName]) {
        _placeholderFontName = placeholderFontName;
        [self.lblPlaceholder setFont:[UIFont fontWithName:self.placeholderFontName size:16.0]];
    }
}

-(void) setSecureTextEntry:(BOOL)secureTextEntry {
    self.textField.secureTextEntry = secureTextEntry;
}
-(BOOL) secureTextEntry {
    return self.textField.secureTextEntry;
}

-(void) setTextType:(VKTextFieldTextType)textType {
    _textType = textType;
    if (textType == VKTextFieldTextTypeDefault) {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    } else if (textType == VKTextFieldTextTypeInteger) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (textType == VKTextFieldTextTypeDecimal) {
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    } else if (textType == VKTextFieldTextTypeAlpha) {
        self.textField.keyboardType = UIKeyboardTypeDefault;
    } else if (textType == VKTextFieldTextTypeMoneyNoDecimal) {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (textType == VKTextFieldTextTypeMoney) {
        self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    } else if (textType == VKTextFieldTextTypePhone) {
           self.textField.keyboardType = UIKeyboardTypePhonePad;
    }
}

-(void) setErrorText:(NSString *)errorText {
    
    _errorText = errorText;
    VKColor *c = [[VKColor alloc] init];
    
    if ([errorText isEqualToString:@""]) {
        self.vUnderline.backgroundColor = c.grayBorderColor;
        self.lblError.text = errorText;
        self.constErrorToUnderline.constant = 0;
        
    } else {
        self.vUnderline.backgroundColor = c.errorColor;
        self.lblError.text = errorText;
        self.constErrorToUnderline.constant = 4;
    }
    self.lblError.textColor = c.errorColor;
}

- (void)setWarningText:(NSString *)warningText {
    
    _warningText = warningText;
    VKColor *c = [[VKColor alloc] init];
    
    if ([warningText isEqualToString:@""]) {
        self.vUnderline.backgroundColor = c.grayBorderColor;
        self.lblError.text = warningText;
        self.constErrorToUnderline.constant = 0;
        
    } else {
        self.vUnderline.backgroundColor = c.grayBorderColor;
        self.lblError.text = warningText;
        self.constErrorToUnderline.constant = 4;
    }
    self.lblError.textColor = c.placeholderColor;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.textField.textColor = textColor;
}

@end
