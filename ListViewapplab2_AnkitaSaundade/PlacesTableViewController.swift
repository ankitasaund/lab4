//
//  PlacesTableViewController.swift
//  ListViewapplab2_AnkitaSaundade
//
//  Created by Prashant Saund on 2/8/17.
//  Copyright © 2017 MyOrg. All rights reserved.
//

import UIKit
import CoreData

class PlacesTableViewController: UITableViewController, UISearchResultsUpdating,NSFetchedResultsControllerDelegate
{
    var myPlaces = [PlaceObjectMO]()
    var searchController : UISearchController!
    var searchResults = [PlaceObjectMO]()
    
    let coreDataDB = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var fetchResultsController : NSFetchedResultsController<PlaceObjectMO>!
    
    let collation = UILocalizedIndexedCollation.current()
    var sections: [[AnyObject]] = []
    var objects: [AnyObject] = [] {
        didSet {
            let selector: Selector = "iPlaceName"
            sections = Array(repeating: [], count: collation.sectionTitles.count)
            
            let sortedObjects = collation.sortedArray(from: objects, collationStringSelector: selector)
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                sections[sectionNumber].append(object as AnyObject)
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return collation.sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return collation.sectionIndexTitles
    }
    
    override open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return collation.section(forSectionIndexTitle: index)
    }

    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let fetchRequest : NSFetchRequest<PlaceObjectMO> = PlaceObjectMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "iPlaceName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataDB, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do{
                try fetchResultsController.performFetch()
                myPlaces = fetchResultsController.fetchedObjects! as [PlaceObjectMO]
                
                if myPlaces.isEmpty {
                    initialization()
            }
            } catch{
                print(error)
            }
        
        //add A search controller and search bar to the app
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
        
    }
    
        //reload data otherwise even though the data is added it wont show on the table
    override func viewDidAppear(_ animated: Bool)
    {
        let fetchRequest = NSFetchRequest<PlaceObjectMO>(entityName: "PlaceObject")
        let sortDescriptor = NSSortDescriptor(key: "iPlaceName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataDB, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
            myPlaces = fetchResultsController.fetchedObjects! as [PlaceObjectMO]
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects{
            myPlaces = fetchedObjects as! [PlaceObjectMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return number of rows
        if searchController.isActive
        {
            return searchResults.count
        }
        else{
            return myPlaces.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PlacesCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlacesTableViewCell
        
        var cellItem : PlaceObjectMO
        if searchController.isActive
        {
            cellItem = searchResults[indexPath.row]
            
        }
        else{
            cellItem = myPlaces[indexPath.row]
        }
        //configure the cell
        //cell.cellPlaceName?.text = myPlaces[indexPath.row].iPlaceName
        cell.cellPlaceName?.text = cellItem.iPlaceName
        
        //display rounded images
        cell.cellImage?.layer.cornerRadius = cell.cellImage.frame.size.width/2.0
        cell.cellImage?.clipsToBounds = true
        cell.cellImage?.layer.masksToBounds = true
        cell.cellImage?.image = UIImage(data: cellItem.iPlaceImage as! Data)
         cell.cellPlaceDetail?.text = cellItem.iPlaceDetail
        
        cell.accessoryType = cellItem.iPlaceChecked ? .checkmark : .none
        //add fade-in anumation, set initial state, duration and final state
        //cell.alpha = 0
        //UIView.animate(withDuration: 10, animations: { cell.alpha = 1 })

        //for fly In animation
        var rotationTransform : CATransform3D = CATransform3DIdentity
        rotationTransform = CATransform3DTranslate(rotationTransform, -250, -250, 0)
        cell.cellImage?.layer.transform = rotationTransform
        UIView.animate(withDuration: 6, animations: {
            cell.cellImage?.layer.transform = CATransform3DIdentity
        })
        // Configure the cell...

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //reverse state of  whether item was checked or not
        //PlaceChecked[indexPath.row] = !(PlaceChecked[indexPath.row])
        
        //myPlaces[indexPath.row].iPlaceChecked = !(myPlaces[indexPath.row].iPlaceChecked)
        
        //Now show or hide  the checkmark on what the new state should be
        //if PlaceChecked[indexPath.row]
        let cellItem = searchController.isActive ?
        searchResults[indexPath.row] : myPlaces[indexPath.row]
        cellItem.iPlaceChecked = !(cellItem.iPlaceChecked)
        
            //if myPlaces[indexPath.row].iPlaceChecked
            if cellItem.iPlaceChecked
        {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        else
        {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        //return true
        if searchController.isActive
        {
            return false
        }
        else
        {
            return true
        }
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // Delete the row from the data source
            let itemToDelete = fetchResultsController.object(at: indexPath) 
            coreDataDB.delete(itemToDelete)
            
            do {
                try coreDataDB.save()
            } catch {
                print(error)
            }
        }else if editingStyle == .insert{
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPlaceDetail"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                let detailVC = segue.destination as! PlaceDetailController
                detailVC.plcDetail = searchController.isActive ? searchResults[indexPath.row] : myPlaces[indexPath.row]
            }
        }
        else if segue.identifier == "AddNewPlaces"
        {
            searchController.isActive = false
        }
    }
    
    func addData(newItem : PlaceObjectMO)
    {
        myPlaces.append(newItem)
    }
    
    
    // MARK: - Update search results
    
    func filterContentForSearchText(searchText : String){
        searchResults = myPlaces.filter({(Places: PlaceObjectMO)-> Bool in
            let nameMatch = Places.iPlaceName?.range(of:searchText, options:String.CompareOptions.caseInsensitive)
            return nameMatch != nil
        })
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        if let textToSeach = searchController.searchBar.text
        {
            filterContentForSearchText(searchText: textToSeach)
            tableView.reloadData()
        }
    }
    
    func initialization(){
        
        let initial = [
            PlaceObject (iPlaceName:"Bixby Bridge" , iPlaceImage: #imageLiteral(resourceName: "bigsur"), iPlaceDetail:"Bixby Creek Bridge, also known as Bixby Bridge, built in 1932 is a reinforced concrete open-spandrel arch bridge in Big Sur, California. The bridge is located 120 miles (190 km) south of San Francisco on state route 1(Highway 1)." , iPlaceChecked: false),
            PlaceObject ( iPlaceName:"Burney falls" , iPlaceImage:#imageLiteral(resourceName: "burney") , iPlaceDetail:"McArthur–Burney Falls Memorial State Park is the second oldest state park in the California State Parks system, located approximately 6 miles (9.7 km) north of Burney, California. The park offers camping, fishing, watersports, hiking and horseback riding facilities. The park is mainly known for the waterfall, Burney Falls, at the entrance of the park. Wildlife in the park includes bass, trout, Steller's jay, squirrels, woodpeckers, deer, and on rare occasion, black bear." , iPlaceChecked:false),
            PlaceObject ( iPlaceName:"Crater Lake" , iPlaceImage:#imageLiteral(resourceName: "crater") , iPlaceDetail: "Crater Lake National Park is a United States National Park located in southern Oregon. Established in 1902, Crater Lake National Park is the fifth-oldest national park in the U.S. and the only national park in Oregon. The park encompasses the caldera of Crater Lake, a remnant of a destroyed volcano, Mount Mazama, and the surrounding hills and forests.", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Garapata Beach" , iPlaceImage:#imageLiteral(resourceName: "garapatta") , iPlaceDetail: "Garrapata State Park is a state park of California, USA, located on Highway 1 6.7 miles (10.8 km) south of Carmel and 18 miles (29 km) north of Big Sur on the Monterey coast.It is marked only with one sign on the west side of the road", iPlaceChecked:false),
            PlaceObject ( iPlaceName: "Bodie-The ghost town", iPlaceImage: #imageLiteral(resourceName: "bodiw") , iPlaceDetail: "Bodie is a ghost town in the Bodie Hills east of the Sierra Nevada mountain range in Mono County, California, United States, about 75 miles (121 km) southeast of Lake Tahoe. It is located 12 mi (19 km) east-southeast of Bridgeport,[5] at an elevation of 8379 feet (2554 m).[1] As Bodie Historic District, the U.S. Department of the Interior recognizes it as a National Historic Landmark.", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Hanuman temple", iPlaceImage:#imageLiteral(resourceName: "hanuman") , iPlaceDetail: "Sankat Mochan Hanuman temple is located at Mount Madonna Center, Watsonville (CA). The temple is built during 2001-2003 and The Prana Pratishtha ceremony, “establishing the breath” within the sacred image, was performed in 2003. The temple is located on a scenic hill with a silent and peaceful environment.", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Hearst Castle", iPlaceImage:#imageLiteral(resourceName: "hearstcastle"), iPlaceDetail: "Hearst Castle is a National Historic Landmark and California Historical Landmark mansion located on the Central Coast of California, United States(approximately 250 miles (400 km) from both Los Angeles and San Francisco).", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Las Vegas" , iPlaceImage: #imageLiteral(resourceName: "vegas"), iPlaceDetail: "Las Vegas, in Nevada’s Mojave Desert, is a resort city famed for its vibrant nightlife, centered around 24-hour casinos and other entertainment options.", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Los Angeles", iPlaceImage:#imageLiteral(resourceName: "losangel") , iPlaceDetail:"Los Angeles is a sprawling Southern California city and the center of the nation’s film and television industry. Near its iconic Hollywood sign, studios such as Paramount Pictures, Universal and Warner Brothers offer behind-the-scenes tours. " , iPlaceChecked:false),
            PlaceObject (iPlaceName: "Mount Shasta" , iPlaceImage: #imageLiteral(resourceName: "mountshasta") , iPlaceDetail:"Mount Shasta is a city in Siskiyou County, California, at about 3,600 feet (1,100 m) above sea level on the flanks of Mount Shasta, a prominent northern California landmark. The city is less than 9 miles (14 km) southwest of the summit of its namesake volcano." , iPlaceChecked:false),
            PlaceObject (iPlaceName: "Myrtle Beach", iPlaceImage:#imageLiteral(resourceName: "myrtle") , iPlaceDetail:"Myrtle beach is a coastal city in South Carolina. It is situated on the center of a large and continuous stretch of beach known as the Grand Strand in northeastern South Carolina." , iPlaceChecked:false),
            PlaceObject (iPlaceName: "Niagara falls", iPlaceImage:#imageLiteral(resourceName: "niagara") , iPlaceDetail:"Niagara Falls is the collective name for three waterfalls that straddle the international border between Canada and the United States; more specifically, between the province of Ontario and the state of New York." , iPlaceChecked:false),
            PlaceObject (iPlaceName: "Pfeiffer Beach", iPlaceImage:#imageLiteral(resourceName: "peiffer") , iPlaceDetail:"Pfeiffer Beach, one of the most popular stretches of sand along the Big Sur coast, is famous for its purple-hued sand also wonderful rock formations. It is a perfect for a picnic and sand play, but you can’t swim there as the waves are too strong. You get a great picture opportunities here, specially Sunset.", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Point Reyes", iPlaceImage:#imageLiteral(resourceName: "pointreyes") , iPlaceDetail: "Point Reyes National Seashore is a 71,028-acre park preserve located on the Point Reyes Peninsula in Marin County, California. As a national seashore, it is maintained by the US National Park Service as an important nature preserve", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Santa Cruz", iPlaceImage: #imageLiteral(resourceName: "SantaC"), iPlaceDetail: "Santa Cruz is one of America’s surfing capitals, complete with its own museum devoted to the sport, and a beach whose waves are known all over the world." , iPlaceChecked:false),
            PlaceObject (iPlaceName: "San Francisco", iPlaceImage: #imageLiteral(resourceName: "goldengate"), iPlaceDetail:"San Francisco, in northern California, is a hilly city on the tip of a peninsula surrounded by the Pacific Ocean and San Francisco Bay. It's known for its year-round fog, iconic Golden Gate Bridge, cable cars and colorful Victorian houses.",iPlaceChecked:false),
            PlaceObject (iPlaceName: "San Gregorio Beach", iPlaceImage:#imageLiteral(resourceName: "Sang") , iPlaceDetail: "San Gregorio State Beach is a beach near San Gregorio, California, USA, south of Half Moon Bay. Part of the California State Park System, the beach lies just west of the intersection of State Route 1 and State Route 84.", iPlaceChecked:false),
            PlaceObject (iPlaceName: "Watkin Glen" , iPlaceImage:#imageLiteral(resourceName: "watkins") , iPlaceDetail:"Watkins Glen is the site of scenic Watkins Glen State Park.Watkins Glen is a village in Schuyler County, New York, United States. The population was 1,859 at the 2010 census. It is the county seat of Schuyler County. The Village of Watkins Glen lies within the towns of Dix and Reading." , iPlaceChecked:false),
            PlaceObject (iPlaceName: "WonderWorks", iPlaceImage: #imageLiteral(resourceName: "Wonder") , iPlaceDetail:"WonderWorks is an entertainment center focused on science exhibits with five locations in the United States.Each WonderWorks location contains interactive, entertainment exhibits on the themes of space, physics and math." , iPlaceChecked:false),
            PlaceObject (iPlaceName:"Yosemite National Park" , iPlaceImage: #imageLiteral(resourceName: "yosemite"), iPlaceDetail:"Yosemite National Park is in California’s Sierra Nevada mountains. It’s famed for its giant, ancient sequoia trees, and for Tunnel View, the iconic vista of towering Bridalveil Fall and the granite cliffs of El Capitan and Half Dome." , iPlaceChecked:false)]
        
        for entry in initial {
            let placeEntry = NSEntityDescription.insertNewObject(forEntityName: "PlaceObject", into: coreDataDB) as! PlaceObjectMO
            
            placeEntry.iPlaceName = entry.iPlaceName
            placeEntry.iPlaceImage = UIImagePNGRepresentation(entry.iPlaceImage!) as NSData?
            placeEntry.iPlaceDetail = entry.iPlaceDetail
            placeEntry.iPlaceChecked = entry.iPlaceChecked
        }
        
        do {
            try coreDataDB.save()
        } catch {
            print(error)
        }
    }
}
