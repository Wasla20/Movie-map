//
//  MovieManager.swift
//  MovieMap
//
//  Created by Wasla Shafique on 04/10/2023.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: [Movie])
    func didFailWithError(error: Error)
}

struct MovieManager{
    
    //let movieURL = //https://api.themoviedb.org/3/search/movie?query=\(query)&api_key=83d01f18538cb7a275147492f84c3698
    var delegate : MovieManagerDelegate?
    
    
    
    func fetchMovie(title: String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(title)&api_key=83d01f18538cb7a275147492f84c3698"
        print("title entered by user :  \(title)" )
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String) {
        print("inside perform request")
        if let url = URL(string: urlString) {
            
            
            let session = URLSession(configuration: .default)
            
            
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let movie = self.parseJSON(safeData) {
                        self.delegate?.didUpdateMovie(self, movie: movie)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ movieData: Data) -> [Movie]? {
        let decoder = JSONDecoder()
        print("inside json parser ")
        var moviesArray = [Movie]()
        
        do {
            let movies = try decoder.decode(MovieApiResponse.self, from: movieData)
            
            //print("decoded data : \(decodedData)" )
           
            //print("movies : \(decodedData.results)")
            for i in 0..<(movies.results.count-1
                              ){
                let title = movies.results[i].title
                let poster_path = movies.results[i].poster_path
                let release_date = movies.results[i].release_date
                let backdrop_path = movies.results[i].backdrop_path
                let vote_average = movies.results[i].vote_average
                let vote_count = movies.results[i].vote_count
                let overview = movies.results[i].overview
                
                
                // print("title : \(title)")
                //print("overview : \(overview)")
                
                //print("vote count : \(vote_count)")
                
                let newMovie = Movie(title: title, poster_path: poster_path, release_date: release_date,backdrop_path: backdrop_path, vote_average: vote_average, vote_count: vote_count, overview: overview)
                
                moviesArray.append(newMovie)
            }
            
            print("movies array in json parser : \(moviesArray)")
            return moviesArray

        } catch {
            delegate?.didFailWithError(error: error)
            print("error : \(error)")
            
            return nil
        }
    }
    
    
}
