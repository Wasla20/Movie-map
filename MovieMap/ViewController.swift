//
//  ViewController.swift
//  MovieMap
//
//  Created by Wasla Shafique on 04/10/2023.
//

import UIKit
import Foundation

class ViewController: UIViewController , UISearchBarDelegate{

    var moviesArray = [Movie]()
    
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movieManager = MovieManager()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       

        searchField.delegate = self
        movieManager.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //definesPresentationContext = true

    }


}

extension ViewController : UICollectionViewDataSource
{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesArray.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        /*
         let fimage = "https://image.tmdb.org/t/p/w500/\(moviesArray[indexPath.row].poster_path)"
         
         ImageLoader.sharedInstance.imageForUrl(urlString: fimage) { [weak self] (image, url) in
         if let image = image {
         // Ensure the cell is still visible before updating its contents
         if let indexPath = collectionView.indexPath(for: cell), indexPath.row == indexPath.row {
         cell.imageView?.image = image
         }
         }
         }*/
        
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        let imgURL = baseURL + (moviesArray[indexPath.item].poster_path ?? "")!
        //print("downloading !!  \(imgURL)")
        if  let url = URL(string: imgURL){
            downloadImage(from: url , cell: cell)
        }

        
        
        cell.textLabel?.text = moviesArray[indexPath.item].title
        return cell
    }
}
    
    
extension ViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // let detailViewController = DetailViewController()
        
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        self.navigationController?.pushViewController(detailViewController!, animated: true)
        
       /* DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.present(detailViewController, animated: true, completion: nil)
            
        }
        */
        let selectedMovie = moviesArray[indexPath.item]
         print("inside did select item at :  \(selectedMovie.title)")
         //performSegue(withIdentifier: "GoToDetails", sender: selectedMovie)*/
        
    }
   /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetails" {
            if let destinationVC = segue.destination as? DetailsViewController,
               let selectedMovie = sender as? Movie {
                destinationVC.selectedMovie = selectedMovie
            }
        }
    }*/
   
}


extension ViewController : MovieManagerDelegate{
   
   
    func didUpdateMovie(_ movieManager: MovieManager, movie: [Movie]) {
        print("inside didUpdateMovie")
  
        moviesArray = movie
        
        DispatchQueue.main.async {
           
            self.collectionView.reloadData()
        }
        
     
        

    }
    
    func didFailWithError(error: Error) {
        print(error)
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    func downloadImage(from url: URL, cell : MovieCollectionViewCell ) {
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
           // print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                cell.imageView.image = UIImage(data: data)
            }
        }
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

