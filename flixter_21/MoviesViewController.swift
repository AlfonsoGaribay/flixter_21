//
//  MoviesViewController.swift
//  flixter_21
//
//  Created by Fonzie on 2/19/21.
//

import UIKit
import AlamofireImage


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // properties
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var movies = [[String:Any]]() // this an array of dictionaries review this.
    
    //fin properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        //print("Hello World")
        // beginning API code
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
            
            self.movies = dataDictionary["results"] as! [[String:Any]] // what is casting, review it.
            self.tableView.reloadData()
            
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data
            
            //print(dataDictionary) <- prints the content of the array of information about my movies
            
           }
        }
        task.resume()
        // fin API code
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        
        // review swift optionals
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis // this will get one line of the synopsis we need to figure out how to optimize it 
        
        let baseUrl = "https://image.tmdb.org/t/p/w185" // <--haha found the bug!! its .org not .ord :p
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Loading up the details screen here....")
        
        //Find the selected movie
        let cell = sender as! UITableViewCell // <-- not sure what to do about this
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // pass the selected movie to the details view controller
        //the sender ios the cell that was tapped on
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        
        tableView.deselectRow(at: indexPath, animated: true) // <-- this deselects the row we selected 
        
    }
    
}
