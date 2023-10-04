//
//  ViewController.swift
//  MovieMap
//
//  Created by Wasla Shafique on 04/10/2023.
//

import UIKit

class ViewController: UIViewController , UISearchBarDelegate{

    var moviesArray = [Movie]()
    
    
    //@IBAction func searchButtonPressed(_ sender: UIButton) {}
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
   // @IBOutlet weak var collectionView: UICollectionView!
    var movieManager = MovieManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchField.delegate = self

        collectionView.dataSource = self
    }


}

extension ViewController : UICollectionViewDataSource
{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.textLabel?.text = moviesArray[indexPath.item].title
        return cell
        
        
    }
    
    
}

extension ViewController : MovieManagerDelegate{
    func didUpdateMovie(_ movieManager: MovieManager, movie: [Movie]) {
        
       /* DispatchQueue.main.async {
            self.collectionView.reloadData()
        }*/
        
        print("inside didUpdateMovie \(movie)")
    }
    
    func didFailWithError(error: Error) {
        print(error)
        
    }
    
    
    
}

extension ViewController: UITextFieldDelegate {
    
  
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        print("inside search button pressed")
        searchField.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let movie = searchField.text {
            movieManager.fetchMovie(title: movie)
        }
        
        print("text changed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        if let movie = searchField.text {
            movieManager.fetchMovie(title: movie)
        }
        
        print("inside textfield did end editing")
        
        searchField.text = ""
        
    }
}

