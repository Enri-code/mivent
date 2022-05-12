- TODO
    - qr code
    - add time
    - create thumbnail for user and event display picture
    - convert all server dates from UTC to WAT
    - change remote event list generation logic and UI designs for each state
    - change default ticket and event image to a Mivent design
    <!-- - Limit editing of event
    - ability to work offline (but unsafe, if multiple users are scanning)
    - rule for events_data: only allowed from cloud functions
    - firebase security rules
    - create cloud schedule for event clean ups -->

    The [upgrader] package can use a forced upgrade version
    (minimum app version) simply by adding that version number to the
    description field in the app stores. Use this format:
    [:mav: [version]]
    Using that text says that the minimum app version is 1.2.3 and that earlier
    versions of this app will be forced to update to the current version.
<!-- - personalized events; popular, this month/week, running out, free, this weekend -->

- Features:
    - App links for sharing events
    <!-- - Report a problem, suggest an idea
    (If verified as host) -->
    - Invite user to event management


- Screens:
    - Host or attendee?
    - Login/sign up
        - with email, google, verify email

    (If verified as host)
    - Ticket Check-in, invite user to event management

    - Menu pages:
    (If verified as host)
    - Events by you
        - Scan QR code: <!-- 'offline mode' button -->
        - Live, draft, past
            - users going<!-- (by tickets or general) -->
            - request for ticket money (50%)
            <!-- - postpone event -->
        - 'Create an event' button, 'Delete event' button
            - Infos from event listing page
            - Privacy (public or private)
            - location on map
            - hosts name and image
            - Create ticket button
                - Price (free?)
                - amount?
                - How many slots/seats
                - visibility (public or private)
                - sales start time and end date/when
                event starts or halfway into the end
            - Upload for review button

    - Your events page
        - Attending events
        - Favourited events

    - Events Listing page
        - search bar, categories

        - Event section,
            - title,<!--  'show more' button -->
            - Event image, name, price range,
                thumbnail of users going & '+ [amount] going',
                location, time range of event, 'favourite' button

        - Events Listing info page
            - <!-- slide of event images -->
            - Infos from listing page...
            - time range of event<!-- / column of times -->
            - About, 'share' button
            <!-- - Event hosts, name, number & pic -->
            - map, contact organizer<!-- , Add to calender -->
            - 'Buy ticket'/ 'attend' button,
            - 'cancel attendance' button: if already attending
            <!-- - 'report' button -->

    - Your Tickets (event associated, price, amount)
            - past (used ticket or not?)
            - upcoming
                - qr code,
                - refund (before it starts)
            - Ticket Issues
            - Send ticket to user (username/link)



    - User page
        - Account info
            - Name, email, phone number, gender, picture, change password
            - Change email/phone number buttons

        <!-- - Notifications
        - Security -->
        - Manage Tickets
        - Support

        - Become a Host button
        - Log out
