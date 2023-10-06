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
        collectionView.reloadData()
        
    }
    
    
}

extension ViewController : UICollectionViewDataSource
{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesArray.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("inside cellforItem")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        // let movie:Movie = moviesArray[indexPath.item]
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        let imgURL = baseURL + (moviesArray[indexPath.item].poster_path ?? "")!
        // print("downloading !!  \(imgURL)")
        if  let url = URL(string: imgURL){
            downloadImage(from: url , cell: cell)
        }
        
        cell.releaseLabel?.text = "\(moviesArray[indexPath.item].release_date)"
        cell.titleLabel?.text = moviesArray[indexPath.item].title
        
        
        //cell.updateUI(movie: movie)
        
        
        return cell
    }
}



extension ViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // let detailViewController = DetailViewController()
        print("inside did select item at ")
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        detailViewController?.selectedMovie = moviesArray[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w500/"
        let imgUrl = baseUrl + (moviesArray[indexPath.item].backdrop_path ?? "")!
        
        if  let url = URL(string: imgUrl){
            detailViewController?.backdropURLImage = downloadBackdropImage(from: url)
            
        }
        
        self.navigationController?.pushViewController(detailViewController!, animated: true)
        
    }
}


extension ViewController : MovieManagerDelegate{
    func didUpdateMovie(_ movieManager: MovieManager, movie: [Movie]) {
        //print("inside didUpdateMovie")
        
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
            // print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                
                cell.imageView.image = UIImage(data: data)
            }
        }
    }
    
    
    func downloadBackdropImage(from url: URL) -> UIImage? {
        var downloadedImage: UIImage?
        let semaphore = DispatchSemaphore(value: 0) // Create a semaphore to wait for the download task to complete
        
        getData(from: url) { data, response, error in
            defer {
                semaphore.signal() // Release the semaphore regardless of download success or failure
            }
            
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            // Create the UIImage from the downloaded data
            downloadedImage = UIImage(data: data)
        }
        
        _ = semaphore.wait(timeout: .distantFuture) // Wait for the download task to complete
        return downloadedImage
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


