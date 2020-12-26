//
//  ContainerController.swift
//  Stud
//
//  Created by Shanti Mickens on 5/13/20.
//  Copyright © 2020 Shanti Mickens. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMAppAuth

private let reuseIdentifier = "EventCell"

class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    let calendar = CalendarController()
    let settings = SettingsController()
    let transition = SlideInTransition()
    var currentView: UIView?
    
    let service = GTLRCalendarService()
    public var events: [Event] = []
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCalendarService()
        
        getEvents(for: "primary")
    }
    
    // MARK: - Handlers
    
    @objc func handleMenuToggle() {
        let menuController = MenuController()
        menuController.didTapMenuOption = { menuOption in
            self.transitionToNew(menuOption)
        }
        menuController.modalPresentationStyle = .overCurrentContext
        menuController.transitioningDelegate = self
        present(menuController, animated: true)
    }
    
    @objc func handleEditList() {
        // displays add event form
        let eventController = EventController()
        eventController.addEvent = { event in
            self.addEvent(event)
            self.dismiss(animated: true, completion: nil)
        }
        let controller = UINavigationController(rootViewController: eventController)
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Dash"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "bars")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        let navbarAppearance = UINavigationBarAppearance()
        navbarAppearance.configureWithOpaqueBackground()
        navbarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navbarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // displays home page
        transitionToNew(MenuOption.Calendar)
    }
    
    func setTitle(_ page: String) {
        navigationItem.title = page
    }
    
    func transitionToNew(_ page: MenuOption) {
        let title = String(describing: page).capitalized
        self.setTitle(title)
        
        if currentView != nil {
            currentView?.removeFromSuperview()
        }
        
        switch page {
            case .Calendar:
                navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "new")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleEditList))
                calendar.view.frame = self.view.bounds
                //vc.view.bounds = (self.currentView?.bounds)!
                self.view.addSubview(calendar.view)
                addChild(calendar)
                calendar.didMove(toParent: self)
                self.currentView = calendar.view
            case .Settings:
                navigationItem.rightBarButtonItem = nil
                let vc = SettingsController()
                //vc.view.frame = self.view.bounds
                //vc.view.bounds = (self.currentView?.bounds)!
                self.view.addSubview(vc.view)
                addChild(vc)
                vc.didMove(toParent: self)
                self.currentView = vc.view
        }
    }
    
    func setupCalendarService() {
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.maxRetryInterval = 15
        
        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser, let authentication = currentUser.authentication else { return }
        
        service.authorizer = authentication.fetcherAuthorizer()
    }
    
    // get calendar events
    func getEvents(for calendarID: String) {
        // You can pass start and end dates with function parameters
        //let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))

        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarID)
        eventsListQuery.timeMin = GTLRDateTime(date: Calendar.current.startOfDay(for: Date()))
        eventsListQuery.timeMax = GTLRDateTime(date: Calendar.current.startOfDay(for: Date().addingTimeInterval(60*60*24*31)))
        eventsListQuery.singleEvents = true // true makes it return recurring events
        eventsListQuery.orderBy = kGTLRCalendarOrderByStartTime
                
        service.executeQuery(eventsListQuery, delegate: self, didFinish: #selector(returnEvents(ticket: result: error:)))
    }
    
    @objc func returnEvents(ticket: GTLRServiceTicket, result: GTLRCalendar_Events, error: NSError?) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        calendar.dates = []
        calendar.events = []
        if let items = result.items, items.isEmpty == false {
            events = []
            for item in items {
                let start: GTLRDateTime! = item.start?.dateTime ?? item.start?.date // datetime is for events that have a start time, like 9:00 am while date is for all-day events
                let end: GTLRDateTime! = item.end?.dateTime ?? item.end?.date
                let event = Event(type: EventType.Other, title: item.summary ?? "Untitled", desc: item.descriptionProperty, start: start, end: end)
                let index = calendar.dates.firstIndex(of: DateFormatter.localizedString(from: start.date, dateStyle: .medium, timeStyle: .none)) ?? -1
                if index != -1 {
                    calendar.events[index].append(event)
                } else {
                    calendar.dates.append(DateFormatter.localizedString(from: start.date, dateStyle: .medium, timeStyle: .none))
                    calendar.events.append([event])
                }
            }
        }
        calendar.expandedEvents = []
        calendar.tableView.reloadData()
    }
    
    func addEvent(_ event: GTLRCalendar_Event) {
        let query = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: "primary")
        service.executeQuery(query) { (ticker, result, error) in
            if let error = error {
                print(error)
                return
            }
            self.getEvents(for: "primary")
        }
    }
    
}

extension ContainerController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

