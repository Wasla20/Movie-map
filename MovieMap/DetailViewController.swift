//
//  DetailViewController.swift
//  MovieMap
//
//  Created by Wasla Shafique on 05/10/2023.
//

import UIKit


protocol DetailViewDelegate {
    func updateDetailControllerUI(movie : Movie)


}
class DetailViewController: UIViewController {

    let selectedMovie : Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var vc = ViewController()
        vc.delegate = self
        if let movie = selectedMovie{
            
            print("inside detail view  \(movie.title)")
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

extension DetailViewController : DetailViewDelegate{
    func updateDetailControllerUI(movie: Movie) {
        
    }
    
    
    
    
}
