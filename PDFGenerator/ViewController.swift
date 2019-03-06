//
//  ViewController.swift
//  PDFGenerator
//
//  Created by Brian Kayfitz on 2019-03-05.
//  Copyright © 2019 Brian Kayfitz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let palette = Palette(
            title: "American",
            colour1: .red,
            colour2: .white,
            colour3: .blue,
            details: "The colours of the American flag.  Looks a little French...")
        
        let pdf = PDFTemplate(palette: palette)
        view.addSubview(pdf.view)
//        pdf.renderInteractive()
        
    }
}

