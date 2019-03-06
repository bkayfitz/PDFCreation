//
//  PDFManualRenderer.swift
//  PDFGenerator
//
//  Created by Brian Kayfitz on 2019-03-06.
//  Copyright © 2019 Brian Kayfitz. All rights reserved.
//

import Foundation

class PDFManualRenderer: PDFRenderer {
    
    override func draw(context: UIGraphicsPDFRendererContext) {
        var x: CGFloat = 50
        var y: CGFloat = 50
        
        let margin: CGFloat = 10
        
        let formattedText = formatted(text: palette.title, font: UIFont.boldSystemFont(ofSize: 36))
        formattedText.draw(at: CGPoint(x: x, y: y))
        
        y += formattedText.size().height + margin
        
        drawBox(colour: palette.colour1, context: context, x: x, y: y)
        x += boxSize + margin
        
        drawBox(colour: palette.colour2, context: context, x: x, y: y)
        x += boxSize + margin
        
        drawBox(colour: palette.colour3, context: context, x: x, y: y)
        
        x = 50
        y += boxSize + margin
        
        let detailsText = formatted(text: palette.details, font: UIFont.systemFont(ofSize: 14))
        detailsText.draw(at: CGPoint(x: x, y: y))
    }
    
    
    private func formatted(text: String, font: UIFont) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func drawBox(colour: UIColor, context: UIGraphicsPDFRendererContext, x: CGFloat, y: CGFloat) {
        colour.setFill()
        context.fill(CGRect(x: x, y: y, width: boxSize, height: boxSize))
    }

}
