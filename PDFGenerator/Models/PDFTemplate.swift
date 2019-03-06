//
//  PDFTemplate.swift
//  PDFGenerator
//
//  Created by Brian Kayfitz on 2019-03-05.
//  Copyright © 2019 Brian Kayfitz. All rights reserved.
//

import Foundation
import UIKit

class PDFTemplate: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var colour1: UIView!
    @IBOutlet private weak var colour2: UIView!
    @IBOutlet private weak var colour3: UIView!
    @IBOutlet private weak var moreInfo: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    private let palette: Palette
    private let a4PageSize = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    private let boxSize: CGFloat = 100
    
    init(palette: Palette) {
        self.palette = palette
        super.init(nibName: "PDFTemplate", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = palette.title
        colour1.backgroundColor = palette.colour1
        colour2.backgroundColor = palette.colour2
        colour3.backgroundColor = palette.colour3
        moreInfo.text = palette.details
        
        renderAsJustAnImage()
        renderInteractive()
    }
    
    func renderAsJustAnImage() {
        let render = UIGraphicsPDFRenderer(bounds: a4PageSize)
        
        let data = render.pdfData { context in
            context.beginPage()
            view.drawHierarchy(in: a4PageSize, afterScreenUpdates: true)
        }
        
        export(data: data, name: "static")
    }
    
    func renderInteractive() {
        let render = UIGraphicsPDFRenderer(bounds: a4PageSize)
        
        let data = render.pdfData { context in
            context.beginPage()
            
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
        
        export(data: data, name: "interactive")
    }
    
    private func formatted(text: String, font: UIFont) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func drawBox(colour: UIColor, context: UIGraphicsPDFRendererContext, x: CGFloat, y: CGFloat) {
        colour.setFill()
        context.fill(CGRect(x: x, y: y, width: boxSize, height: boxSize))
    }
    
    private func export(data: Data, name: String) {
        guard let docsUrl = docsDirectory() else {
            return
        }
        
        let pdfUrl = docsUrl.appendingPathComponent("\(name).pdf")
        do {
            try data.write(to: pdfUrl)
            print("Exported PDF")
            print(pdfUrl.description)
        } catch {
            print("PDF Rendering failed")
        }
    }
    
    private func docsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    }
}
