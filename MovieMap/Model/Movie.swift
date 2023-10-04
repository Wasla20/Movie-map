//
//  Movie.swift
//  MovieMap
//
//  Created by Wasla Shafique on 04/10/2023.
//

import Foundation


struct Movie : Codable{
    let title : String
    let poster_path : String?
    let release_date : String
    let backdrop_path : String?
    let vote_average : Double
    let vote_count : Int
    let overview : String
 }


struct MovieApiResponse: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
