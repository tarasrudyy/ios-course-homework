//
//  EventView.swift
//  Diary
//
//  Created by Taras Rudyi on 4/16/16.
//  Copyright © 2016 Taras Rudyi. All rights reserved.
//

import UIKit

class EventView: UIView {

    var color = UIColor.redColor()
    
    var record: DiaryRecord? {
        didSet {
            if let weather = record?.weather {
                switch weather {
                case .Sunny:
                    color = UIColor.orangeColor()
                case .Cloudy:
                    color = UIColor.blueColor()
                case .Rainy:
                    color = UIColor.darkGrayColor()
                default:
                    color = UIColor.lightGrayColor()
                }
            }
        
            initSubviews()
        }
    }
    
    private func initSubviews() {
        let gap:CGFloat               =  10
        let dateWidth:CGFloat         =  40
        let dateHeight:CGFloat        =  18
        let dateLineHeight:CGFloat    =  30
        let nameLabelMaxWidth:CGFloat = 145
        
        var boundsSize = CGSizeZero
        
        // date view
        let dateLabel = UILabel()
        dateLabel.textColor = color
        dateLabel.font = UIFont.systemFontOfSize(8)
        dateLabel.text = record?.shortDate
        dateLabel.textAlignment = .Center
        
        dateLabel.frame.size.width  = dateWidth
        dateLabel.frame.size.height = dateHeight
        
        var rect = CGRectZero
        rect.origin.y = dateLineHeight
        rect.size = CGSizeMake(dateWidth, dateHeight)
        
        let dateView = getRoundedViewWithFrame(rect)
        dateView.addSubview(dateLabel)
        self.addSubview(dateView)
        
        // calulate new bounds
        boundsSize.width  += rect.size.width
        boundsSize.height += rect.size.height
        
        // draw vertical line
        var lineImageFrame = CGRectZero
        lineImageFrame.origin.x = rect.origin.x
        lineImageFrame.origin.y = 0
        lineImageFrame.size = CGSize(width: rect.size.width, height: dateLineHeight)
        var lineImageView = UIImageView(frame: lineImageFrame)
        lineImageView.image = drawLineInRect(ofSize: lineImageFrame.size, horizontally: false)
        self.addSubview(lineImageView)
        
        // calulate new bounds
        boundsSize.height += lineImageFrame.size.height
        
        // weather view
        if let weather = record?.weather {
            if weather != .None {
                let weatherSize = CGSizeMake(  2 * dateHeight,     2 * dateHeight)
                let imageSize   = CGSizeMake(0.7 * weatherSize.width, 0.7 * weatherSize.height)
                var imageFrame = CGRectZero
                imageFrame.origin.x = 0.5 * (weatherSize.width  - imageSize.width)
                imageFrame.origin.y = 0.5 * (weatherSize.height - imageSize.height)
                imageFrame.size = imageSize
                
                let weatherImageView = UIImageView(frame: imageFrame)
                weatherImageView.tintColor = color
                let images = ["sunny_sm", "rain_sm", "cloudy_sm"]
                weatherImageView.image = UIImage(named: images[weather.rawValue])?.imageWithRenderingMode(.AlwaysTemplate)
                
                rect.origin.x = dateView.frame.maxX + gap
                rect.origin.y = dateView.frame.midY - 0.5 * weatherSize.height
                rect.size = weatherSize
                
                let weatherView = getRoundedViewWithFrame(rect)
                weatherView.addSubview(weatherImageView)
                self.addSubview(weatherView)
                
                // calulate new bounds
                boundsSize.width += rect.size.width
                
                // draw horizontal line
                lineImageFrame = CGRectZero
                lineImageFrame.origin.x = rect.origin.x - gap
                lineImageFrame.origin.y = rect.origin.y
                lineImageFrame.size = CGSize(width: gap, height: weatherSize.height)
                lineImageView = UIImageView(frame: lineImageFrame)
                lineImageView.image = drawLineInRect(ofSize: lineImageFrame.size, horizontally: true)
                self.addSubview(lineImageView)
            }
        }
        
        // name view
        if !(record?.name ?? "").isEmpty {
            let nameLabel = UILabel()
            nameLabel.textColor = color
            nameLabel.font = UIFont.systemFontOfSize(11)
            nameLabel.lineBreakMode = .ByTruncatingTail
            nameLabel.text = record?.name
            nameLabel.textAlignment = .Center
            
            var nameSize = nameLabel.intrinsicContentSize()
            if nameSize.width > nameLabelMaxWidth {
                nameSize.width = nameLabelMaxWidth
            }
            nameSize.height = rect.height
            nameLabel.frame.origin.x = gap
            nameLabel.frame.size = nameSize
            
            rect.origin.x = rect.maxX + gap
            rect.origin.y = rect.midY - 0.5 * nameSize.height
            rect.size = nameSize
            rect.size.width += 2 * gap
            
            let nameView = getRoundedViewWithFrame(rect)
            nameView.addSubview(nameLabel)
            self.addSubview(nameView)
            
            // draw horizontal line
            lineImageFrame = CGRectZero
            lineImageFrame.origin.x = rect.origin.x - gap
            lineImageFrame.origin.y = rect.origin.y
            lineImageFrame.size = CGSize(width: gap, height: nameSize.height)
            lineImageView = UIImageView(frame: lineImageFrame)
            lineImageView.image = drawLineInRect(ofSize: lineImageFrame.size, horizontally: true)
            self.addSubview(lineImageView)
            
            // calulate new bounds
            boundsSize.width += rect.size.width
        }
        
        self.bounds.size = boundsSize
    }
    
    private func getRoundedViewWithFrame(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.layer.cornerRadius = 0.5 * frame.size.height
        view.layer.borderWidth  = 1
        view.layer.borderColor  = color.CGColor
        view.clipsToBounds      = true
        return view
    }
    
    private func drawLineInRect(ofSize size: CGSize, horizontally: Bool) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        CGContextSetLineWidth(context, 1)
        
        CGContextBeginPath(context)
        if horizontally {
            CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMidY(bounds))
            CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMidY(bounds))
        } else {
            CGContextMoveToPoint(context, CGRectGetMidX(bounds), CGRectGetMinY(bounds))
            CGContextAddLineToPoint(context, CGRectGetMidX(bounds), bounds.size.height)
        }
        CGContextStrokePath(context)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
//    // Only override drawRect: if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//    }

}
