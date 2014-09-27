//
//  LSREKVTableViewCell.m
//  HttpWorker
//
//  Created by 倪 李俊 on 14-9-23.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSREKVTableViewCell.h"

@implementation LSREKVTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //[[self detailTextLabel] setNumberOfLines:0];
        //[[self detailTextLabel] setLineBreakMode:(NSLineBreakByWordWrapping)];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
