//
//  ViewController.swift
//  MovieMap
//
//  Created by Wasla Shafique on 04/10/2023.
//

import UIKit

class ViewController: UIViewController {

   var movieArray = [Movie]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
    }


}

extension UIViewController : UICollectionViewDataSource
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

