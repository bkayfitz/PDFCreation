//
//  PDFRender.swift
//  PDFGenerator
//
//  Created by Brian Kayfitz on 2019-03-06.
//  Copyright © 2019 Brian Kayfitz. All rights reserved.
//

import Foundation
import UIKit

class PDFRenderer {
    let filename = "demo"
    let a4PageSize = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
    
    let palette: Palette
    init(palette: Palette) {
        self.palette = palette
    }
    
    func render() {
        let render = UIGraphicsPDFRenderer(bounds: a4PageSize)
        let data = render.pdfData { context in
            context.beginPage()
            self.draw(context: context)
        }
        
        export(data: data)
    }

    // Abstract, subclasses must overwrite
    func draw(context: UIGraphicsPDFRendererContext) {}
    
    private func export(data: Data) {
        guard let docsUrl = docsDirectory() else {
            return
        }
        
        let pdfUrl = docsUrl.appendingPathComponent("\(filename).pdf")
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
