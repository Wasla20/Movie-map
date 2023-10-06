//
//  DetailViewController.swift
//  MovieMap
//
//  Created by Wasla Shafique on 05/10/2023.
//

import UIKit



class DetailViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    
    
    var selectedMovie : Movie? = nil
    var backdropURLImage : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = selectedMovie{
            
            print("inside detail view  \(movie.title)")
            
            
            DispatchQueue.main.async {
                self.backdropImage.image = self.backdropURLImage
                self.movieTitle.text = "Title : \(movie.title)"
                self.voteAverage.text = "Vote Average : \(movie.vote_average)"
                self.voteCount.text = "Vote Count : \(movie.vote_count)"
                self.overview.text = "Overview \n \(movie.overview)"
            }
            
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


    
    
    
    

